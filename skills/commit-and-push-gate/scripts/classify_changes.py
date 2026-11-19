#!/usr/bin/env python3
"""Classify a git working tree for safe-to-commit.

Usage: classify_changes.py [--session-repo PATH]

Runs in the repository whose changes are about to be committed (the current
directory). PATH (or the SESSION_REPO environment variable) is the directory
the agent session was opened in. When that directory belongs to a different
repository than the current one, the verdict is "sibling_confirm". Without
it the sibling check cannot run, and the verdict carries a warning saying so.
Reads git state, applies the deterministic sensitivity and repository-boundary
rules, and emits a JSON verdict to stdout. The commit step remains
authoritative for mutation.

Exit codes: 0 on success (even if tree is blocked or needs confirm),
1 on git-error (not a repo, git not on PATH).
"""

from __future__ import annotations

import json
import os
import re
import subprocess
import sys
from pathlib import Path

# Filename patterns that block a commit. The blocker is on intent, not
# extension only: "credentials.json" blocks, "credentials_test.json"
# also blocks, because the substring is the canonical signal.
BLOCK_PATTERNS = [
    re.compile(r"(^|/)\.env(\..*)?$"),
    re.compile(r"credentials", re.IGNORECASE),
    re.compile(r"secret", re.IGNORECASE),
    re.compile(r"(^|/)id_rsa(\.pub)?$"),
    re.compile(r"(^|/)id_ed25519(\.pub)?$"),
    re.compile(r"(^|/)id_ecdsa(\.pub)?$"),
    re.compile(r"\.pem$"),
    re.compile(r"\.key$"),
    re.compile(r"\.p12$"),
    re.compile(r"\.pfx$"),
]

# Patterns that get a softer "token" warning. The user may still want
# to commit (e.g., a public OAuth token in a doc), so this is a warning
# not a hard block.
TOKEN_WARN_PATTERN = re.compile(r"token", re.IGNORECASE)

MAX_BINARY_SIZE_BYTES = 10 * 1024 * 1024  # 10 MB


def run_git(args: list[str]) -> str:
    """Run git with the given args, return stdout. Raise on error."""
    result = subprocess.run(
        ["git", *args],
        capture_output=True,
        text=True,
        check=False,
    )
    if result.returncode != 0:
        raise RuntimeError(f"git {' '.join(args)} failed: {result.stderr.strip()}")
    return result.stdout


def changed_paths() -> tuple[list[str], list[str]]:
    """Parse `git status --porcelain=v2` for paths in the working tree.

    Returns paths relative to the repo root, including staged,
    unstaged, untracked. Submodules and renames are flattened to the
    primary path. Unmerged (conflicted) entries are returned separately as the
    second item: they are never safe to commit.
    """
    out = run_git(["status", "--porcelain=v2", "-z", "--untracked-files=all"])
    paths: list[str] = []
    unmerged: list[str] = []
    if not out:
        return paths, unmerged
    # NUL-delimited records. Each starts with a status character.
    # 1, 2, u, ? are the prefixes we care about.
    records = out.split("\x00")
    i = 0
    while i < len(records):
        rec = records[i]
        if not rec:
            i += 1
            continue
        kind = rec[0]
        if kind == "u":
            # unmerged: `u <XY> <sub> <m1> <m2> <m3> <mW> <h1> <h2> <h3> <path>`
            parts = rec.split(" ")
            unmerged.append(" ".join(parts[10:]))
            i += 1
        elif kind == "1":
            # `1 <XY> <sub> <mH> <mI> <mW> <hH> <hI> <path>`
            # path is the last whitespace-separated token; everything
            # before is fixed fields.
            parts = rec.split(" ")
            paths.append(" ".join(parts[8:]))
            i += 1
        elif kind == "2":
            # rename: `2 <XY> ... <path>` and the NEXT record is <origPath>
            parts = rec.split(" ")
            paths.append(" ".join(parts[9:]))
            # consume the origPath record
            i += 2
        elif kind == "?":
            # `? <path>` for untracked
            paths.append(rec[2:])
            i += 1
        else:
            i += 1
    unmerged = [p for p in unmerged if p]
    return [p for p in paths if p] + [p for p in unmerged if p not in paths], unmerged


def detect_blocks(paths: list[str], repo_root: Path) -> tuple[list[str], list[str]]:
    """Return (blocked, warnings) lists for the given changed paths."""
    blocked: list[str] = []
    warnings: list[str] = []
    for p in paths:
        full = repo_root / p
        # Sensitive-name patterns block outright.
        for pat in BLOCK_PATTERNS:
            if pat.search(p):
                blocked.append(p)
                break
        else:
            # Size check for files that exist (untracked but present).
            if full.is_file():
                try:
                    if full.stat().st_size > MAX_BINARY_SIZE_BYTES:
                        blocked.append(f"{p} (over 10 MB)")
                        continue
                except OSError:
                    pass
            if TOKEN_WARN_PATTERN.search(p):
                warnings.append(f"{p} (filename contains 'token')")
    return blocked, warnings


def detect_force_added_ignored(paths: list[str]) -> list[str]:
    """Return paths that are normally gitignored but appear in the diff.

    Uses `git check-ignore` per file. Empty list if all clear.
    """
    flagged: list[str] = []
    for p in paths:
        result = subprocess.run(
            ["git", "check-ignore", "--no-index", "--", p],
            capture_output=True,
            text=True,
            check=False,
        )
        # check-ignore exits 0 if the path is ignored, 1 if it is not.
        # Anything else is a real failure and must not pass silently.
        if result.returncode == 0:
            flagged.append(p)
        elif result.returncode != 1:
            raise RuntimeError(
                f"git check-ignore failed (exit {result.returncode}) for {p}: {result.stderr.strip()}"
            )
    return flagged


def sample_commit_messages(n: int = 10) -> list[str]:
    """Sample the last N commit subjects. Empty list if no history."""
    try:
        out = run_git(["log", f"-n", str(n), "--format=%s"])
    except RuntimeError:
        return []
    return [line for line in out.splitlines() if line.strip()]


def propose_message(samples: list[str], paths: list[str], diff_stat: str) -> str:
    """Generate a placeholder commit message that matches sampled style.

    This is deterministic templating. The LLM-side skill replaces or
    refines the message before commit; this is a default.
    """
    if not paths:
        return "chore: no changes"
    # Detect conventional-prefix convention from samples.
    prefix_count = sum(
        1
        for s in samples
        if re.match(r"^(feat|fix|chore|docs|refactor|perf|test|style|build|ci|revert)(\(|:|!)", s)
    )
    use_prefix = prefix_count >= 7

    # Pick a prefix based on file types changed.
    if any(p.endswith((".md", ".txt")) for p in paths) and not any(
        p.endswith((".py", ".ts", ".js", ".go", ".rs")) for p in paths
    ):
        prefix = "docs"
    elif any("test" in p.lower() for p in paths) and not any(
        ("src/" in p or "lib/" in p) for p in paths
    ):
        prefix = "test"
    else:
        prefix = "chore"

    n = len(paths)
    head = paths[0].split("/")[-1] if paths else "change"
    body = f"update {head}" + (f" and {n - 1} more file{'s' if n > 2 else ''}" if n > 1 else "")
    if use_prefix:
        return f"{prefix}: {body}"
    return body


def toplevel_of(path: str) -> Path | None:
    """Return the git top-level directory containing path, or None."""
    result = subprocess.run(
        ["git", "-C", path, "rev-parse", "--show-toplevel"],
        capture_output=True,
        text=True,
        check=False,
    )
    if result.returncode != 0 or not result.stdout.strip():
        return None
    return Path(result.stdout.strip()).resolve()


def diff_base() -> str:
    """HEAD when the repository has a commit, else git's empty tree."""
    probe = subprocess.run(
        ["git", "rev-parse", "--verify", "--quiet", "HEAD"],
        capture_output=True,
        text=True,
        check=False,
    )
    if probe.returncode == 0:
        return "HEAD"
    return run_git(["hash-object", "-t", "tree", "/dev/null"]).strip()


def parse_session_repo(argv: list[str]) -> str | None:
    value = os.environ.get("SESSION_REPO") or None
    i = 0
    while i < len(argv):
        if argv[i] == "--session-repo" and i + 1 < len(argv):
            value = argv[i + 1]
            i += 2
        elif argv[i].startswith("--session-repo="):
            value = argv[i].split("=", 1)[1]
            i += 1
        else:
            print(f"usage: classify_changes.py [--session-repo PATH] (unknown argument {argv[i]})", file=sys.stderr)
            raise SystemExit(2)
    return value


def main() -> int:
    session_arg = parse_session_repo(sys.argv[1:])
    try:
        repo_root_str = run_git(["rev-parse", "--show-toplevel"]).strip()
    except RuntimeError as e:
        print(json.dumps({"error": str(e), "tree_status": "error"}), file=sys.stdout)
        return 1
    repo_root = Path(repo_root_str)
    working_dir = Path(os.getcwd()).resolve()

    paths, unmerged = changed_paths()
    if not paths:
        print(
            json.dumps(
                {
                    "tree_status": "clean",
                    "blocked_files": [],
                    "warnings": [],
                    "sibling_repo": False,
                    "repo_root": str(repo_root),
                    "working_dir": str(working_dir),
                    "sample_messages": [],
                    "suggested_message": "",
                    "diff_stat": "",
                },
                indent=2,
            )
        )
        return 0

    blocked, warnings = detect_blocks(paths, repo_root)
    try:
        force_ignored = detect_force_added_ignored(paths)
    except RuntimeError as e:
        print(json.dumps({"error": str(e), "tree_status": "error"}))
        return 1
    if force_ignored:
        warnings.extend(f"{p} (matches .gitignore but is staged)" for p in force_ignored)

    # Sibling-repo detection: the session's own repository (given explicitly)
    # against the repository the changes are in (the current directory's).
    session_repo = toplevel_of(session_arg) if session_arg else None
    if session_arg and session_repo is None:
        print(
            json.dumps(
                {"error": f"session repo is not inside a git repository: {session_arg}", "tree_status": "error"}
            )
        )
        return 1
    if session_repo is None:
        warnings.append("session repo not given: the sibling-repository check did not run")
    sibling = session_repo is not None and session_repo != repo_root.resolve()

    diff_stat = run_git(["diff", "--stat", diff_base()]).strip()
    samples = sample_commit_messages(10)
    suggested = propose_message(samples, paths, diff_stat)

    if unmerged:
        status = "unmerged"
    elif blocked:
        status = "blocked"
    elif sibling:
        status = "sibling_confirm"
    else:
        status = "safe"

    print(
        json.dumps(
            {
                "tree_status": status,
                "blocked_files": blocked,
                "unmerged_files": unmerged,
                "reason": (
                    "unresolved merge conflicts remain; resolve and stage them first"
                    if unmerged
                    else ""
                ),
                "warnings": warnings,
                "sibling_repo": sibling,
                "session_repo": str(session_repo) if session_repo else None,
                "repo_root": str(repo_root),
                "working_dir": str(working_dir),
                "sample_messages": samples,
                "suggested_message": suggested,
                "diff_stat": diff_stat,
                "changed_paths": paths,
            },
            indent=2,
        )
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
