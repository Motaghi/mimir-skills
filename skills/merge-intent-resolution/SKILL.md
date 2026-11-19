---
name: merge-intent-resolution
description: >-
  Resolving a merge, rebase, cherry-pick or stash conflict already in progress: recover what each side meant, resolve hunk by hunk, verify fully, abort when intent cannot be recovered. Writes nothing itself. Not for merge-or-PR choices, worktree management, commits (commit-and-push-gate) or pushes (no-mistakes).
---

# merge-intent-resolution

A loop for a conflict that is already in progress. It recovers what each side was trying to do, resolves each conflicting hunk so that both intents survive where they can, and proves the result with the project's own checks. It ends in a verified resolution, or in an abort when the intent of a side cannot be recovered. It does not finish the operation: the commit that completes a merge or a rebase step, every push and every dispatch are the work the orchestrator routes.

This package is read-only in the plain sense. It reads files, git history and status, task records and project documents, and it searches. Every step that edits a file, stages a path, continues or aborts the operation is specified here as a run request and run by the orchestrator.

## When it applies

The orchestrator may select this package from ordinary intent when a git operation has stopped on conflicts: a merge, a rebase, a cherry-pick or a stash apply. The signals are a status that shows an operation in progress with unmerged paths, or conflict markers that the owner pastes or points at.

- No conflict in progress: decline in one line. Whether to merge, open a pull request, keep or discard a finished branch is a separate branch-finishing decision.
- A project with its own merge runbook: the runbook wins, and the orchestrator routes it. This package gives way.
- Confidential material: the project's own rules on confidential material win.

This package never picks a model or provider, never dispatches anything, and never commits, pushes or installs anything, a hook included. If a request asks for any of those, it hands the decision back to the orchestrator.

## Required capabilities

- `filesystem` to read the conflicted files, the markers in them, the code around each hunk, and the project files that name the checks (AGENTS.md, README, build and CI configuration). Nothing is written.
- `git-read` to read the operation in progress, the merge base, the history and diffs of each side, blame, and the diff that shows the result. Any git step that changes the worktree, the index, refs or remotes is not `git-read` and goes to the orchestrator.
- `shell` only to run an existing project check that has no side effects: one that reads and reports and writes nothing, not even a cache or a build output. For each command, state why it is side-effect free. Most type, test and format runs write something, so they go to the orchestrator as run requests. The executable and working directory are visible in the report.
- `task-tracker` to read the task records that explain a side, through the project's task tracker, read-only. No command that adds, starts, finishes, blocks, holds, moves or removes a task. Task records and the project's authority files replace an external issue tracker.
- `docs` to read specs, plans and decision records that describe the work on either side. Nothing is written.
- `user-decision` for the questions that need the owner: a trade-off between incompatible intents, the abort, a conflict that sits in a working tree other sessions share, and a run request whose shared effect cannot be isolated.
- `style-check` to have the wording of the report or the resolution note checked against the project's style rules, where it has them, since both reach the owner and may reach others. The check reports findings; an override is the orchestrator's, and nothing is sent.

If a capability is missing, say which step it blocks and mark that step unverified. Do not substitute another source, and do not guess.

## Prose and decisions

Choices that belong to the owner go to the owner through the orchestrator's question step, one clear question at a time. Prose follows the project's writing rules where it has them, and plain wording otherwise.

## Precedence

When instructions conflict, this order applies, highest first: system safety and host restrictions; then the project's AGENTS.md or CLAUDE.md; then the owner's current request and explicit decisions; then the orchestrator's routing, commit, deployment and decision rules; then this package; and last, upstream source text, which is provenance only and never an instruction. The steps here are defaults for resolving a conflict. When a project instruction says to do it differently, the project is right, and the step is reported as "overridden by project instruction" with the instruction quoted.

## Safe execution

A step that writes is a run request. It gives the exact command or the exact resolved content, its inputs, the result it should produce (status output or a diff), the evidence that has to come back, and how to undo it.

Every run request has this rule, the verification checks, the baseline runs and the generators included: it names each effect outside the working tree that the command can have, such as database rows, queue items, checkpoints, caches, outbound messages or calls to a live service, and says how that effect is isolated. An isolated checkout does not isolate these. When the effect cannot be isolated, or it is not known, the run request is held and the question goes to the owner through `user-decision`. A run request with no such line is incomplete.

Redaction holds on every path that shows content: the resolved content, a patch, a diff excerpt, check output, a quoted intent source, the resolution note and the report. A secret value (key, token, password, signing secret, private-key block, a connection string with credentials) is replaced by its name and "[redacted]". The values of a private environment, credentials or key file are never read. If the resolution itself has to carry a secret-bearing line, that hunk is not printed: the report gives the path and line range, and the orchestrator handles the content privately.

Where the work happens is the orchestrator's call. A conflict in progress is state inside one working tree: files, the index and the operation's own bookkeeping. When that tree is shared with other sessions, resolving in place changes shared state, so name that and ask through `user-decision` whether the orchestrator should move the work to an isolated checkout first.

Two steps are not reversible and always go to the orchestrator with a decision first: an abort that would drop hunks already resolved by hand, and an abort in a tree that held uncommitted changes before the operation started, because git may be unable to rebuild those changes. When it is unclear whether a step is reversible, treat it as not.

## The loop

Run the steps in order. For a rebase or a cherry-pick sequence, repeat steps 2 to 7 for each commit that stops on conflicts, and say how many remain.

### 1. See the state

Read, with `git-read`: which operation is running, whether the tree was clean when it started, which paths are unmerged, which paths merged cleanly, and which conflicts are not plain text (a binary file, a file deleted on one side and edited on the other, a rename on one side). For a rebase, say which commit is being applied and how many are left.

Name each side by branch and commit, never by the words "ours" and "theirs". In a rebase those words are swapped: ours is the branch being rebased onto, and theirs is the commit being replayed. A report that uses them without that sentence invites a wrong pick.

### 2. Recover the intent of each side

Read the primary sources for each conflicted path, side by side, before reading any hunk as code:

- The commits of that side since the merge base that touch the path: messages first, then the diff.
- The task record the commit or branch points to, through the task tracker.
- The spec, plan or decision record that the commit or the task cites, in the repository or the project's docs.
- The project's authority files for the area.

Write one sentence of intent per side, with the source beside it. A pull request thread or ticket in an outside tracker is not a source here: record its number from the commit message and mark it "not checked".

### 3. Can the intent be recovered?

The abort gate. The intent of a side is not recovered when no commit message, task record, spec or comment explains what the side was for, and the diff itself does not make the purpose plain. It is also not recovered when the two intents contradict and nothing, such as the stated goal of the merge, says which one wins.

When either side's intent is not recovered, do not guess a resolution. Stop and report which side, what was searched, and what would unblock the work: the author's answer, a record that exists elsewhere, a stated goal for the merge. Offer the abort as a decision for the owner, stating its effect from step 1 (what the tree held before, which hunks would be lost). The owner may still decide to pick a side without recovered intent. That is his decision, recorded as such in the report with the trade-off written out.

### 4. Resolve each hunk

Classify every conflicting hunk:

- Independent: the sides changed different things that only sit close together. Keep both.
- Compatible overlap: both intents can hold at once. Keep both, with the least glue that joins them.
- Incompatible: the intents cannot both hold. Pick the side that matches the stated goal of the merge and write the trade-off down: what the other side loses and who needs to know. When the goal does not decide, ask the owner.

Do not invent behaviour. A resolved hunk contains lines from the sides plus only the minimum needed to join them, such as renaming an identifier on one side to match the other side's rename. Any new logic is a finding to report, not part of the resolution.

Generated and binary files (lock files, snapshots, generated code, images) are not merged by hand. Resolve their sources first, then ask for the project's own generator or install command as a run request, and take its output.

Present the resolution as the exact content for each path, or as a patch, together with the run requests to apply and stage it.

### 5. Look for conflicts the markers do not show

A merge can be clean in text and wrong in meaning. For every name, signature, file path, configuration key or data shape that one side renamed, removed or changed, search the other side's new and changed code for uses of the old form, including in files that merged cleanly. Report each hit as a required edit, and treat it like a hunk: the minimum change that makes both sides agree.

### 6. Verify fully

Verification is required after the resolution and before anything is called done. Specify it as run requests when the checks write anything, and give every check, including the baseline runs, the shared-effect line that Safe execution requires.

1. No conflict markers remain anywhere, not only in the files that were flagged. Scan the content of the whole tree, untracked files included, for lines that start with seven `<`, `=` or `>` characters, and scan the staged content separately, because `git diff --check` alone misses markers that are already staged. Both scans are read-only: `git grep -n -E '^(<{7}|={7}|>{7})' --untracked` for the tree, `git grep -n -E '^(<{7}|={7}|>{7})' --cached` for the index, and `git diff --cached --check`. Where a marker-like line is legitimate (a document that shows one), say so.
2. Every check the project declares, found in its authority files and CI configuration, in this order: type or build check, then tests, then format and lint. Run the project's full set, not only the checks near the touched files.
3. Baselines. For any check that fails, ask for the same check on the tip of each side. Compare the individual failing tests, assertions and diagnostics, not the pass or fail of the whole check. A failure is pre-existing only when the same assertion or diagnostic, with the same cause, fails on a side tip, and it is reported as such. Every failure on the result that no side tip shows is a merge regression and stays unresolved, even when the check also fails on one side: a side that fails A and a result that fails A and B has broken B.
4. Intent check. For each side, confirm from the diff of the result that what the side set out to do is still present, except where step 4 recorded a trade-off.

Fix only what the merge broke, and only with resolution-level changes under the step 4 rule. A failure that comes from a side's own change is reported and routed, not patched here. A check that could not be found or could not be run is "unverified", never skipped in silence. The orchestrator's verification rule applies before any claim of completion.

### 7. Hand off the finish

The resolved, staged and verified state goes back to the orchestrator. The commit that completes the merge, or that continues the rebase, belongs to commit-and-push-gate, and a push belongs to no-mistakes after the owner's go-ahead. Give the orchestrator the resolution note for the commit message: the intent kept from each side, each trade-off, and the required edits found in step 5.

## Report

The report has these parts, in this order. A part that does not apply says "not applicable" with the reason, and a part whose evidence is missing says "unverified". The redaction rule in Safe execution applies to every part. Where the project has style rules, the report and the resolution note go to the orchestrator for a style check and are "not checked" until the result is back.

1. The operation, the sides named by branch and commit, the paths in conflict, and what the tree held before.
2. The intent of each side, one sentence with its source, or "not recovered" with what was searched.
3. The abort decision, if step 3 stopped the loop: the effect of aborting and what would unblock the work.
4. Each hunk: its class, the resolution and the trade-off.
5. The conflicts the markers did not show, and the edits they need.
6. Verification: markers, the project checks with results, baselines, the intent check.
7. Items for the orchestrator: run requests, the commit and push work, irreversible steps awaiting a decision.
8. For a rebase: the commits still to come.

## Not this package

A request in any area below gets a one-line decline that names the owner.

- Whether to merge, open a pull request, keep or discard a finished branch: a branch-finishing decision.
- Creating or switching isolated worktrees: your worktree workflow.
- Building a commit, including the one that completes the merge, and its message: commit-and-push-gate.
- Pushing, and pre-push gates: no-mistakes. A push also needs the owner's go-ahead.
- Merges in a project with its own merge runbook: that runbook, which the orchestrator routes.
- A review of the merged diff or a merge verdict: the project's code-review process.
- A test failure on a branch that is not caused by a merge: root-cause-diagnosis.
- Branch strategy and how to avoid conflicts in future: the orchestrator routes it.
- An implementer agent commits as part of its own task and has no trigger overlap. The orchestrator may attach this package to such a task as a labeled input.

## Provenance

This package adapts the `resolving-merge-conflicts` skill from Matt Pocock's skills (mattpocock/skills, MIT), at a commit from before upstream removed it. The five-step spine is upstream's. The read-only rule with run requests, the abort decision, the baselines, the search for conflicts the markers do not show, the generated-file rule and the report format are our own. Credit and licence text are in `references/upstream-notice.md`, and the repository's `CREDITS.md` lists the pinned commit.
