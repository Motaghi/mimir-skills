#!/usr/bin/env python3
"""Group git-log commits into Keep-a-Changelog sections.

Reads git log from stdin in the format produced by:
    git log --no-merges --format='%H%x00%s%x00%b%x1e' <range>

Each record is separated by ASCII RS (\\x1e). Each field within a record
is separated by ASCII NUL (\\x00): hash, subject, body.

Writes a JSON dict to stdout with sections + version_bump_suggestion.
Exit codes: 0 on success, 1 on a malformed record (a diagnostic goes to stderr).
"""

from __future__ import annotations

import json
import re
import sys

# Conventional-commit prefix mapped to changelog section + version impact.
# Order matters for the regex: more specific patterns first.
PREFIX_RULES = [
    # (regex, section, bump-impact)
    (re.compile(r"^feat!:|^feat\([^)]+\)!:"), "changed", "major"),
    (re.compile(r"^fix!:|^fix\([^)]+\)!:"), "fixed", "major"),
    (re.compile(r"^feat:|^feat\("), "added", "minor"),
    (re.compile(r"^fix:|^fix\("), "fixed", "patch"),
    (re.compile(r"^perf:|^perf\("), "changed", "patch"),
    (re.compile(r"^refactor:|^refactor\("), "changed", "patch"),
    (re.compile(r"^revert:|^revert\("), "removed", "patch"),
    (re.compile(r"^deprecate:|^deprecate\("), "deprecated", "minor"),
    (re.compile(r"^security:|^security\("), "security", "patch"),
    # Subject-only categories that count toward "other" (still listed but no bump).
    (re.compile(r"^docs:|^docs\("), "other", "patch"),
    (re.compile(r"^chore:|^chore\("), "other", "patch"),
    (re.compile(r"^test:|^test\("), "other", "patch"),
    (re.compile(r"^style:|^style\("), "other", "patch"),
    (re.compile(r"^build:|^build\("), "other", "patch"),
    (re.compile(r"^ci:|^ci\("), "other", "patch"),
]

BREAKING_HEADER = re.compile(r"^([A-Za-z]+)(\([^)]*\))?!:")

BUMP_RANK = {"patch": 0, "minor": 1, "major": 2}
RANK_BUMP = {v: k for k, v in BUMP_RANK.items()}


def classify_record(subject: str, body: str) -> tuple[str, str | None]:
    """Return (section, bump_impact) for one commit.

    The section comes from the commit type as written. The breaking impact is
    computed separately: a "!" before the colon on any type, or a
    BREAKING CHANGE or BREAKING-CHANGE footer, forces a major bump without
    moving the commit to another section.

    If the subject has no conventional prefix, the section is 'other'
    and the bump_impact is None (meaning: we cannot suggest a bump from
    this commit alone).
    """
    header_breaking = BREAKING_HEADER.match(subject)
    breaking = bool(header_breaking) or bool(
        re.search(r"^BREAKING[ -]CHANGE:", body, flags=re.MULTILINE)
    )

    section, bump = None, None
    for pattern, rule_section, rule_bump in PREFIX_RULES:
        if pattern.search(subject):
            section, bump = rule_section, rule_bump
            break
    if section is None and header_breaking:
        # Types such as "refactor!:" are not matched with the "!" in place.
        bare = header_breaking.group(1) + (header_breaking.group(2) or "") + ":"
        for pattern, rule_section, rule_bump in PREFIX_RULES:
            if pattern.search(bare):
                section, bump = rule_section, rule_bump
                break

    if breaking:
        return (section if section not in (None, "other") else "changed"), "major"
    if section is None:
        return "other", None
    return section, bump


def main() -> int:
    raw = sys.stdin.read()
    if not raw.strip():
        print(
            json.dumps(
                {
                    "added": [],
                    "changed": [],
                    "fixed": [],
                    "removed": [],
                    "deprecated": [],
                    "security": [],
                    "other": [],
                    "version_bump_suggestion": "ask",
                    "reason": "empty input",
                }
            )
        )
        return 0

    sections: dict[str, list[str]] = {
        "added": [],
        "changed": [],
        "fixed": [],
        "removed": [],
        "deprecated": [],
        "security": [],
        "other": [],
    }
    bump_observed: int | None = None
    saw_conventional = False

    record_number = 0
    for record in raw.split("\x1e"):
        record = record.strip()
        if not record:
            continue
        record_number += 1
        parts = record.split("\x00")
        # Exactly three fields: hash, subject, body. Anything else is malformed.
        if len(parts) != 3 or not parts[0].strip() or not parts[1].strip():
            print(
                f"group_commits: malformed record {record_number}: expected exactly 3 NUL-separated fields "
                f"(hash, subject, body), found {len(parts)}, or an empty hash or subject",
                file=sys.stderr,
            )
            return 1
        full_subject = parts[1].strip()
        body = parts[2]

        section, bump = classify_record(full_subject, body)
        sections[section].append(full_subject)
        if bump is not None:
            saw_conventional = True
            rank = BUMP_RANK[bump]
            if bump_observed is None or rank > bump_observed:
                bump_observed = rank

    if not saw_conventional:
        suggestion = "ask"
        reason = "no conventional-commit prefixes detected"
    else:
        suggestion = RANK_BUMP[bump_observed]  # type: ignore[index]
        reason = f"highest observed impact in range: {suggestion}"

    out = dict(sections)
    out["version_bump_suggestion"] = suggestion
    out["reason"] = reason
    print(json.dumps(out, indent=2))
    return 0


if __name__ == "__main__":
    sys.exit(main())
