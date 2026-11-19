---
name: commit-and-push-gate
description: Use when the user says "commit this", "stage and commit" or "let's commit". Builds the commit from the files this session changed, classifies them against the project's commit rules (safe in the session's own repository, explicit confirmation for sibling repositories and gated paths, blocked for .env, credential and key files and files over 10 MB), proposes a message in the repository's style and commits exactly those paths. Commits only; push is a separate instruction.
---

# commit-and-push-gate

Classifies a working tree and proposes a safe commit. The agent does the commit itself, but only after the classifier and the project's commit rules say the paths are fine to stage. Setup-specific values (the commit command, gated paths, sibling repositories, the push route) live in a profile; see `profiles/example.md` for the fields and a worked example. Your own profile is `commit-and-push-gate.profile.md` in the project root; if it is not there, ask the user where it is, or use the defaults in this file. Keep it in your project, not in this folder.

## Inputs

One optional input: an explicit list of files to commit. Without it, the candidates are the files this session changed for the task. The skill runs in the session's repository and reads:

- `pwd` and `git rev-parse --show-toplevel` to find the repository root.
- `git status --porcelain=v2` for the changed-file inventory.
- `git diff --stat` for sizing.
- `git log -n 10 --format='%s'` for commit-message style.
- The profile's commit policy: which paths are gated and which commit command to use.

## What it needs

- A shell and read access to git.
- Python 3 for the bundled classifier.
- A way to stage exact paths and commit them. The profile names the command; `git --literal-pathspecs add -- <paths>` followed by `git --literal-pathspecs commit -m <message> -- <paths>` works when the profile names nothing else.
- A way to ask the user a question and wait for the answer.

Run the helper by its absolute path. `<skill-dir>` below means the folder that holds this `SKILL.md`, resolved to an absolute path from where the skill is installed (not a path relative to the project). The helper's git calls inspect the current directory, so run it from the repository whose changes you are committing. If the commit command is unavailable, stop before staging anything. Do not fall back to staging the whole tree.

## Process

0. Build the candidate list from the files this session changed, or the list the user gave. Show other changed paths as "not part of this commit" and never stage them.

1. Run the classifier from the repository you are about to commit in, and tell it which directory the session was opened in, so it can tell a sibling repository from the session's own:

   ```bash
   python3 "<skill-dir>/scripts/classify_changes.py" --session-repo "<directory the session was opened in>"
   ```

   Without `--session-repo` (or the `SESSION_REPO` environment variable) the sibling check cannot run; the result then carries a warning, and you must treat any commit outside the session's own repository as needing confirmation.

   The helper returns JSON: `{tree_status, blocked_files, unmerged_files, reason, warnings, sibling_repo, session_repo, repo_root, working_dir, sample_messages, suggested_message, diff_stat, changed_paths}`.

2. Interpret the result:
   - `tree_status == "clean"`: nothing to commit. Tell the user and stop.
   - `tree_status == "unmerged"`: the tree has unresolved merge conflicts (`unmerged_files`). Show them and stop; the user resolves and stages them first. Never commit a conflicted file.
   - `tree_status == "blocked"`: if a blocked file is among the candidates, show it and refuse to commit. The user must remove the sensitive or oversized file from the candidates before retrying.
   - `tree_status == "sibling_confirm"`: the changed files live under a repository other than the one the session was opened in. Tell the user plainly ("the session was opened at `<working_dir>` but the changes are under `<repo_root>`") and ask for explicit confirmation before staging.
   - `tree_status == "safe"`: go to step 3.

3. Decide whether a second confirmation is needed:
   - All candidates are in the session's repository and the profile marks none of them as gated: the user's request to commit is the approval. Show the diff stat and the message, then continue.
   - The profile marks a candidate as gated (for example deployment configuration, or shared tooling whose design notes must be updated in the same change): show the diff and any note update, and wait for an explicit "go".
   - `sibling_confirm`: wait for an explicit yes for that repository.

4. Stage exactly the candidates and create the commit with the message, using the profile's commit command. Pass the paths literally: `git --literal-pathspecs add -- <paths>` and `git --literal-pathspecs commit -m "<message>" -- <paths>` (or write each path as `:(literal)<path>`), so a file name containing `*`, `?`, `[` or a leading `:` is never read as a pattern. Never stage the whole tree and never commit without exact paths. Exact paths matter because parallel sessions often share one working tree: a commit without paths sweeps another session's staged or half-finished files into yours. If the candidate set changed after approval, show it and ask again.

5. Never push as part of this commit gate. A push needs a separate, explicit instruction from the user, through the route the profile names. Do not infer push authority from "go".

## Sensitivity heuristics

The classifier blocks files matching:

- `.env`, `.env.*` (any extension).
- `*credentials*`, `*secret*` (basenames containing those substrings, case-insensitive).
- `id_rsa`, `id_ed25519`, `id_ecdsa` (SSH private keys).
- `*.pem`, `*.key`, `*.p12`, `*.pfx` (certificate and key files).
- Any file over 10 MB.

Basenames containing `token` get a warning, not a block. Show the warning and check the file's content before committing it.

Files listed in `.gitignore` are left out of the staged set by git itself. The classifier also checks `git check-ignore` for every file in the diff and warns when a normally ignored file has been force-added.

## Commit-message style sampling

The classifier samples the last 10 commit subjects (`git log -n 10 --format='%s'`) and detects:

- Conventional-commit prefix usage (`feat:`, `fix:`, and so on). If 7 or more of 10 use prefixes, the suggestion uses one.
- Subject length distribution. The suggestion aims at the median length.
- Whether subjects start with an imperative verb.

The message text is templated from the diff stat. The user always sees and approves it before the commit.

## Out of scope

- Pushing, force-pushing, tagging and branching. The skill is local only.
- Pre-commit hook integration. Existing hooks fire normally when the commit runs.
- Coordinated commits across several repositories. One repository at a time.
