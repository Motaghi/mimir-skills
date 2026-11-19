# Maintain mode

Read this file only when the owner has clearly asked to keep an existing proof map honest. A map goes stale the moment the app changes. The pass below checks every mapped feature against the source and against a live run, and it proposes corrections. The unit of rigor is the feature: every feature is covered from source and exercised live, without proving every sentence.

Maintain mode follows the rules in `SKILL.md`: the package reads and writes the map document only, every run is a run request for the orchestrator, and nothing is committed, pushed or dispatched by the package. Wording in a correction or the report goes to the orchestrator for a style check before delivery where the project has style rules, as `SKILL.md` requires, and nothing is sent.

## Outcomes

Pick one and say which.

- **clean:** every feature got source and live coverage and nothing needs changing. No edit is made.
- **changed:** proven corrections to the map are ready (applied or proposed, per the authority rule).
- **blocked:** coverage could not finish, or a proven correction could not be made safely. Say exactly what blocked it.

A product bug is a finding reported beside the outcome, never an outcome itself. For formal checks, sync status and verification result are reported separately (see the Formal checks pass).

## Authority and edit scope

Corrections to the map are applied only with the project's authority.

- For a map in the orchestrator's notes folder, the owner's request to maintain it is the authority to edit that one document and nothing else.
- For a map in a project repository, the authority is the project's AGENTS.md or CLAUDE.md, or the owner saying so in this request. Where the project keeps its own authority files for repository changes, a change there is prepared as text and handed to that project's own session.
- Without that authority, the corrections are reported as proposed text with the exact lines to change, and nothing is edited.

Whatever the authority, the map is not edited while the pass runs. Every correction, from the index hygiene step to triage, is kept as proposed text, and step 6 applies it only when the pass qualifies for `changed`: coverage finished with no `blocked` reason, and each correction is proven by a live drive. A recipe that was adjusted to get past a failure during the pass lives only in the isolated run inputs, as a copy outside the map, so a failed or blocked pass leaves the map untouched.

Only the map document, and the sibling feature files it owns, may be edited. Product code is never edited in this mode. A behavior the map describes that the app no longer has is one of two things: documentation drift, which is corrected in the map, or a product regression, which is reported and never papered over in the document. The package creates no branch, pushes nothing and opens no pull request. When a correction is applied, the orchestrator commits under its own commit rules, and a push stays behind the owner's approval.

## The pass

0. **Locate the target.** Find the map: the document whose body has launch and drive sections and a feature map. If several candidates exist, ask which one through `user-decision`. If none exists, stop and offer create mode instead of inventing a target.
1. **Index hygiene.** Read the feature index and list the sibling files. Note missing, extra, duplicate or dead entries as proposed corrections. This step is light and generates no inventory.
2. **Source readers.** Each feature needs a read of its source that answers "how does this user-facing feature work?", flags likely drift with citations, and returns one live-check recipe. For a small map, read them in turn yourself. For a large one, tell the orchestrator which slices divide the work and why; the orchestrator decides whether to route read-only readers, who they are and under which limits. Results come back as labeled inputs with the files read and the open questions. Readers never drive the app and never edit files. The package starts no worker and sets no model.
3. **Reconcile.** Every feature has a returned summary. Merge overlapping recipes into as few app states as is practical. Spot-check the cited drift, and do not re-prove claims that look clean. Sweep recent changes with `git-read` for user-facing surfaces the map lacks, and call one missing only with a concrete source path.
4. **Live pass.** Required even when the source looks clean. Specify it as run requests, and follow the map's own launch model: one long-lived instance driven one feature at a time for servers and UIs, or a fresh isolated session per drive for short-lived terminal programs. Exercise every feature at least once. Three invariants hold the whole pass, whatever fails:
   1. Do not drive an instance that has not been health-checked since it last did something surprising. Run the doctor before the first drive, on each fresh session where sessions are the unit, and after any failed drive. Where the doctor cannot see the failure, such as a wedged screen on a healthy process, reset to a known state or relaunch.
   2. Evidence captured so far survives every cleanup. Check it at its named location rather than assuming.
   3. Nothing a drive started outlives its usefulness. Clean up the residue of failed iterations whether the session is stuck, exited or shared. For a shared instance, clean the residue and leave the instance.
   A doctor failure caused by map drift is drift: record the correction as proposed text, put the adjusted recipe in the run request's isolated inputs, and retry once, restarting only what the adjustment invalidated, before calling the pass blocked. A feature that cannot be reached is `verified-unreachable` only with the concrete prerequisite (sign-in, entitlement, platform, external state) and the route attempted. If the map omits that prerequisite, that omission is drift. Any correction to a helper or recipe is re-driven live before it counts as proven. Final teardown comes after the last drive of the run, the re-drives included.
5. **Triage.** Sort every discrepancy.
   - A wrong or missing description from the user's point of view is documentation drift: propose the correction to the map.
   - Working behavior the recipe cannot drive is a harness gap: propose the corrected recipe, and file the missing helper for the orchestrator if one is needed.
   - App behavior that is actually broken is a product gap: record it for the owner and keep it out of the map's corrections.
6. **Apply or stop.** For `changed`, re-read every changed passage first, update the proof-status table and the `last_verified` date for what was re-driven, and apply the corrections or hand them over as text, per the authority rule above. For `clean` and `blocked`, make no edit, report the outcome and the coverage plainly, and list any proposed corrections as unapplied text.

Keep brief run notes (features covered, unreachable prerequisites, confirmed drift, outcome) in the report, not in a file.

## Formal checks pass

Run this next to the pass above whenever the map has a Formal checks section (see `references/formal-checks.md`). If it has none, say that and stop here. The authority rule, the rule that the map is not edited while the pass runs, and the run-request rules apply as written. The risk this pass guards against is a check that keeps passing after the code under it changed: it then vouches for code that is gone.

**Two results per check, reported separately.** Sync status, using the outcomes above: nothing the check describes has changed: clean. The check was brought up to date: changed. It could not be brought up to date, or could not run: blocked, with the reason. Verification result: pass, fail or not run. A check can be in sync and fail. An accurate updated check that finds a real counterexample is `changed`, in sync, with a failing result and a bug finding for the owner. Nothing is edited to hide the failure, and the property is never loosened to get a pass.

**Edit scope.** The map's formal entry follows the authority rule and the rule that the map is not edited while the pass runs. The model, harness and property files it names are proposed text only, never edited by the package. Each is handed to the orchestrator as a run request (exact path, exact content, inputs, expected result, evidence to return, and any effect outside the checkout named and isolated, or sent to the owner as a decision), and the proposed files reach a rerun only as isolated run inputs, never in the project. Product code is never touched. Reruns are run requests, and no tool is installed.

1. **Find the checks.** Read each entry in the map's Formal checks section: guarantee, covered code, bounds, assumptions, run command and sync commit. When no sync commit is recorded, fall back to the most recent commit that touched the verification files, and say so.
2. **Run it unchanged.** Request one run before anything is edited. A pass only shows that the old description is still self-consistent. A failure could be drift or a bug, which step 5 settles.
3. **Find the commits that touched covered code.** Using `git-read`, list the commits since the sync commit that changed covered files, and read their messages and diffs. Moved code stays covered: a renamed, split or relocated function, plus newly added code that writes the state the check protects. Put each change in one bucket. *No effect*: judge it against the model, not the commit message. *Check out of date*: a step became two, a branch appeared or vanished, a guard moved, a new path reaches the protected state, or a value's range changed. *Promise changed deliberately*: quote the evidence, such as a doc comment, a test, a changelog line or the message. *Promise possibly broken*: nothing says it changed, so a later failure is a bug candidate.
4. **Bring the entry in line with the code.** Draft the proposed update before any rerun, so every changed part again points at code a reviewer can open, and an atomic step in the code stays one step in the check. Propose a property change only where the promise changed deliberately, recording what it said before, what it says now and the evidence for the change. Keep the bounds unless the change invalidates them, and report any reduction.
5. **Rerun and sort.** Request another run. If it passes, also request a deliberate temporary break in an isolated checkout, with the evidence that the check notices it and the cleanup, since an updated description can pass while unable to fail. If it fails, walk the counterexample through the real code one step at a time. A step the code cannot take means the check was wrong, which is drift: correct the entry and note the error. If every step is possible, the code has a bug: name the commit that brought it in, narrate the counterexample in the code's own terms, and give the harm in a sentence. A cheap reproduction against the real code can be requested as evidence. It never goes into product code.
6. **Update the entry.** Covered code, command, bounds, assumptions, and the sync commit, set to the commit just checked, whether the result was a pass or a real counterexample. A blocked check keeps its old sync commit, and the report says so.

For each check, report the sync status, the verification result and the commits read; what changed in the entry and why (the code's structure changed, or the promise did, with evidence); the rerun result and the break used; any bug in plain terms; and what remains uncovered, including new code that deserves coverage. State plainly which failures were drift and which were bugs. When a check passed before the update and fails after it, say that the earlier pass rested on an outdated description. Propose verification updates as their own change, separate from any product fix.

## Report

1. Outcome and the authority used.
2. Coverage per feature: source read, live drive, evidence location, status.
3. Drift found, with the lines to correct, and whether each was applied or proposed.
4. Harness gaps and product gaps, kept apart.
5. Run requests still open and decisions waiting for the owner.
6. What was not read or not driven, and any capability that was missing.
