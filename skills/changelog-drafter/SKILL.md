---
name: changelog-drafter
description: Use when the user asks for a changelog, release notes, or a summary of commits since a release tag or date. Reads git log in the current working repo, groups commits into Keep-a-Changelog sections (Added / Changed / Fixed / Removed / Deprecated / Security), proposes a version bump from conventional-commit prefixes, writes a new entry to CHANGELOG.md at the repo root. Trigger phrasing includes "draft a changelog", "release notes for vN", "what shipped since X", "summarize commits since the last tag".
---

# changelog-drafter

Produces a Keep-a-Changelog entry from the current repo's git log. The skill runs in the user's working repo (whichever directory the session opened in or the user has `cd`-ed into).

## External runtime dependencies

- `shell` for bounded repository-history commands and the bundled helper.
- `git-read` for bounded repository-history queries.
- `python-tooling` for the package helper.
- `filesystem` for reading and updating `CHANGELOG.md`.
- `user-decision` before writing the proposed entry.

Run package helpers with this skill package as the working directory. If a
required executable or capability is unavailable, stop and report the missing dependency.
Do not substitute an ambient script or write an unvalidated entry.

## Inputs

1. **Range**, one of:
   - Last release tag: detect via `git describe --tags --abbrev=0` and use as the lower bound.
   - Explicit date: user passes "since 2026-05-01" or similar.
   - "since main": last divergence from the main branch.
   - Default if all of the above are missing or unclear: ask the user which range to use. Do not silently default to "all of history".
2. **Optional version bump**: user may provide "this is v1.4.0" explicitly. Otherwise the skill proposes one from conventional-commit prefixes per the rules in `scripts/group_commits.py`.

## Process

1. Resolve the range to a git rev expression.
2. Run git in the target repository by explicit path and keep its exit status. Run the helper by the absolute path of this skill's `scripts/group_commits.py`:

   ```bash
   REPO=/absolute/path/to/target/repo
   SKILL_DIR=/absolute/path/to/this/skill
   set -o pipefail
   COUNT=$(git -C "$REPO" rev-list --count --no-merges "$RANGE") \
     || { echo "changelog-drafter: git failed for range $RANGE in $REPO" >&2; exit 1; }
   [ "$COUNT" -gt 0 ] \
     || { echo "changelog-drafter: no commits in range $RANGE" >&2; exit 1; }
   git -C "$REPO" log --no-merges --format='%H%x00%s%x00%b%x1e' "$RANGE" \
     | python3 "$SKILL_DIR/scripts/group_commits.py"
   ```

   The unusual delimiters survive multi-line commit bodies because the log goes through a pipe and not a shell variable. If git fails, stop with that error and write nothing. A malformed record makes the helper print a diagnostic on stderr and exit 1; treat that as an error and write nothing. Empty input is not success: the helper answers an empty log with an "ask" suggestion and exit 0, so the count check above is what catches a bad range or a repository problem. Report it and ask for another range.
3. The helper reads the log from stdin.

   The helper returns JSON: `{added, changed, fixed, removed, deprecated, security, other, version_bump_suggestion}`.
4. Format as Keep-a-Changelog markdown:

   ```
   ## [<version>] - <date>

   ### Added
   - ...

   ### Changed
   - ...

   ### Fixed
   - ...
   ```

   Omit sections that have zero entries. Date is today's local date in ISO format.
5. If `CHANGELOG.md` exists at the repo root, prepend the new entry under the file's existing top-level heading. If not, create one with a Keep-a-Changelog header.
6. Show the user the diff before writing. Ask for explicit approval through
   `user-decision`.

## Version-bump rules

The helper proposes a semver bump from the prefix mix in the range:

- A `!` before the colon on any type (`feat!:`, `perf(api)!:`, `refactor!:`), or a `BREAKING CHANGE:` or `BREAKING-CHANGE:` footer line: major bump.
- Any `feat:` without a breaking marker: minor bump.
- Only `fix:` / `perf:` / `refactor:` / `docs:` / `chore:` / `test:`: patch bump.
- No conventional prefixes at all: ask the user.

The user can override the suggestion at the prompt.

## Out of scope

- Multi-package monorepo version coordination. Per-package CHANGELOGs are a future skill if recurrence justifies.
- Pushing tags or releases. The skill never invokes `git tag` or `git push`. Tagging is the user's call.

## Output location

`CHANGELOG.md` at the repo root, edited in place after user confirmation.
