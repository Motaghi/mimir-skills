---
name: run-close-pack
description: >-
  Close a run whose output reaches an end user, a store page, or a public
  post: freeze the tested tip, run the decisive suite and battery under one
  resource contract, hand replay and serve rehearsal on the tested tip, docs
  commit last, finalize once on the close sha, then assemble the public pack.
  Reads a per-project profile (see profiles/example.md); the skill body names
  no project, host, provider, or model. Use when a build's last feature lane
  has a verdict and anything public follows, or for a text-only public output.
---

# run-close-pack

## Authority order
The user's current instructions, the project's own rules, and the accepted kickoff outrank this skill. Hard stops and no-retry rules win over completion pressure.

This skill picks no model, provider or agent and dispatches nothing itself. It does not push, upload, submit to a store or publish on its own say-so: each of those is handed back to the orchestrating session as a request, and anything public waits for the owner's go.

## Shared base
Read the section "Shared base: capacity and evidence" of the parallel-run-control-plane skill before step 1, even on a single-lane run. Its rules on ranked fallbacks, pause-and-post, saved artifacts over channel lines, and the owner-unreachable default apply here unchanged.

## Profile
Your own profile is `run-close-pack.profile.md` in the project root; if it is not there, ask the user where it is. Read it. `profiles/example.md` lists every field with a worked example for an invented project; copy it into your project and fill in your own values. Which fields are required depends on the path. The text-only path (see Trigger) needs only: channel path, channel retention, texts folder, text pipeline steps, previous public version, durable evidence store path and close docs folder. The full path needs every field. A missing required field stops the close before step 1 and is posted on the channel. A blank value counts as missing and stops the close the same way. Fields the chosen path does not use are not required.

## Trigger
Loads once the last feature lane has a verdict, for any run whose output reaches an end user, a store page, or a public post. Text-only public output (no build) takes the lightweight path: steps 1, 6 and 7, then a final channel line that names the close sha and the evidence store path, skipping steps 2 through 5, 8 and 9; every skipped step is posted as skipped.

## Close sequence
Each step is gated on the one before. Steps 1 to 6 run on the tested tip and test code. Step 7 is the only commit. Step 8 rebuilds and rehashes; any failure at this step, including a determinism failure, is a stop that returns to step 1. Any product-code fix at any step restarts the close at step 1, and channel lines from then on cite the new sha.

1. Freeze the tested tip. Post the sha on the channel with the channel-append helper. Every line below cites it until step 7.
2. Decisive suite in its own isolated working copy on the tested tip. State the expected reds against the merge order first, one per line as `<spec-basename> :<line>`; once the classified list is written, the parallel-run-control-plane skill's `<control-plane-dir>/scripts/red-set-reconcile.sh <expected-reds-file> <classified-list>` compares the two (exit 0 clean, 1 drift, 2 cannot run) and any drift is posted on the channel. Load-class failures (timeouts, layout assertions) get one lone quiet rerun, one worker, started only when the 1-minute load average is below the profile's load threshold; a rerun started while the load average is at or above the threshold is void and is repeated once it drops below it. Write the classified list from `references/classified-list-template.md` into the durable evidence store; the channel line names that file. A stale pin (category D) is a lane defect, never recorded as a flake: the lane that moved the value fixes the pin, and the suite re-runs on a new tested tip. Verdict: no new regression, or a named regression that stops the close.
3. Battery in a clean checkout beside the suite under the resource contract: non-browser chunks (type check, lint, unit tests, build) under the profile's worker cap; every step that opens a browser or binds the suite's ports waits for the suite to end.
4. Hand replay of the tested-tip build at shipped defaults through a static file server, never the dev server: the first ten minutes of use plus every route this run touched. An app root that fails to render is always investigated, never retried past. This is a gate.
5. Serve rehearsal on a scratch port with the real upload bundle shape; the scratch port is distinct from the port half of the profile's serve port and folder field, and that port serves only the closed version. Run `<skill-dir>/scripts/artifact-shape-check.sh <upload bundle> <source snapshot> <entry file> <manifest file>`, with the entry file and manifest file names taken from the profile's artifact shape field; exit 0 passes, exit 1 (wrong shape) and exit 2 (cannot run) are both stops that return to step 1.
6. Public texts, written in the profile's texts folder, through the profile's text pipeline steps in order, cumulative since the previous public version, fix lines still open pasted in and re-linted before assembly. Each step's stamp goes in the sweep record.
7. Close docs commit: docs only, on top of the tested tip. Run `<skill-dir>/scripts/close-record-lint.sh <close docs folder> <skill-dir>/scripts/banned-words.txt` on the working copy, where the close docs folder is the profile field naming the repository folder the docs commit touches; a hit (draft marker, `{{...}}` or `<...>` placeholder, `Status: DRAFT`, or a banned word) means the commit is a draft and does not merge. The shipped `banned-words.txt` is a starter list; replace it with your own house style. The docs commit says "close sha: this commit" and points to the evidence store for hashes. Any fix found after this point starts a new tested tip at step 1; the prior docs commit is superseded by a new one, never amended.
8. Finalize once on the close sha: type check, build with the profile's build command, identity string per the profile, both archives named per the profile with sha256 sidecars, every pre-final pair (the last two texts in the pipeline order, run once more together after every other edit is in) deleted, determinism check, roll onto the profile's serve port and folder, confirm the served identity. Final channel line names the close sha, both files with hashes, the identity, and the evidence store path.
9. Pack assembly into the profile's pack folder. The pack owners field says who assembles which part. Assembly starts from the close sha and the upload bundle hash and does not start while any unfilled marker (any placeholder or draft marker the lint in step 7 catches) remains in the docs.

## Evidence fields
On both paths, every decision the close makes (a fork taken, a gate passed or failed, a revert, a blocker raised) is recorded in the channel line, classified list or sweep record that step already writes, with six one-line fields: ts, phase (the close step), decision, why (plain words), evidence, result. Evidence is a pointer that resolves, such as a sha, a path, `file:line` or a saved output, never a paragraph. Result is the observed outcome, such as `tests green`, `reverted`, `open` or `inconclusive`. An entry with no resolving pointer is marked unverified.

A wrong entry is superseded by a later entry that points back to it. No past entry is edited or deleted. This adds no log file, script or ledger, and the same six field names appear in the build-team report. The fields record the trail; the step gates still decide pass or stop.

## Rules from past wrongs
Never approve an early docs merge to save minutes. The release archive is whichever file the store consumes, not the source snapshot. Ceilings derive from measured step durations, not habit. The full classified list is saved, never summarised into the record.

## Checks
`<skill-dir>/scripts/close-record-lint.sh`, `<skill-dir>/scripts/artifact-shape-check.sh`, tests under `<skill-dir>/scripts/tests/run.sh`; `red-set-reconcile.sh` lives in the parallel-run-control-plane skill's `scripts/` (`<control-plane-dir>`). `<skill-dir>` and `<control-plane-dir>` are the folders that hold each skill's `SKILL.md`, resolved to absolute paths from where the skills are installed; run the helpers by those absolute paths. POSIX shell, no provider or host calls.

## Why these rules
Replaying the build by hand through a static file server finds defects that automated suites miss. Two-gate lifts with observed evidence catch drafts and mislabelled archives before they ship. Passing the close sha and the bundle hash into pack assembly makes the pack repeatable.

## Provenance
The evidence-fields section adapts the decision-trail format of the `show-me-your-work` skill in pstack by Lauren Tan (MIT). Credit and licence text are in `references/upstream-notice.md` and in the repository's `CREDITS.md`.
