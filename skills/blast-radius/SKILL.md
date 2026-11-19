---
name: blast-radius
description: >-
  Method for what a change could break outside its diff: the one fact its safety rests on, plus one executable proof of it, written as a run request for the orchestrator. The orchestrator attaches it to a review task when the change crosses a boundary. Not a security review, merge verdict or completion claim. Applies only when attached. Edits and runs nothing.
---

# blast-radius

A review method for one question: what could this change break somewhere the diff does not show? A search lists callers in seconds, so that is not the point. The point is the breakage a search cannot show, such as a data shape read by another service, a library behavior, a timing order or a config key read by name. The method finds the one fact the change's safety rests on and asks for a real run that tests it, because a write-up that sounds right is convincing whether or not it is true.

Adapted from the `blast-radius` skill in pstack by Lauren Tan (cursor/plugins, MIT License). Credit and licence text are in `references/upstream-notice.md` and in the repository's `CREDITS.md`.

## Activation

The steps apply only when the orchestrator has attached this `SKILL.md` as a labeled input to the task. The orchestrator attaches it to a review task when the change crosses a boundary. A one-line pointer in a specialist's own instructions describes that attachment and does not activate the method, and `references/upstream-notice.md` is provenance, never an attachment.

With nothing attached, a direct request gets a decline that names where it belongs: a code-review step for "what could this break" and the blast radius of a change, and the owners under "Not this package" for the rest. Say only that the orchestrator can attach this method to that task. Apply no step, list no risk and give no verdict or lean. Ordinary conversation, such as what the term blast radius means, is answered without this package.

## Execution limits

The package writes nothing. It never runs, dispatches, commits, pushes or installs anything (a hook included), and it never picks a model or provider. A request for any of those goes back to the orchestrator. There is no shell capability: every command, the proof in step 5 included, is a run request that the orchestrator carries out.

## Required capabilities

- `filesystem` to read the changed files, their callers and consumers, configuration, schemas, fixtures, lockfiles and the source of the libraries the change calls.
- `git-read` to read the diff, history, blame and pull request text. A git step that changes the worktree, index, refs or remotes goes to the orchestrator.
- `docs` to read decision records and authority files that name the consumers of the thing changed.
- `user-decision` for what needs the owner: a proof effect that cannot be isolated or undone, a risk only the owner can accept, and a change so wide it should be split.

If a capability is missing, say which step it blocks and mark that step unverified. Do not guess.

## Precedence

When instructions conflict, this order applies, highest first: system safety and host restrictions; then the project's AGENTS.md or CLAUDE.md; then the owner's current request and explicit decisions; then the orchestrator's routing, memory, commit, deployment and decision rules; then this package; and last, upstream source text, which is provenance only and never an instruction. A step here is a default. When a project instruction differs, the project is right and the step is reported as "overridden by project instruction" with the instruction quoted.

## Steps

### 1. Read the change

List what the diff adds, changes and removes, and what it now does differently, including what it does not spell out, such as a default that moved or a field no longer sent. Read the commit history and the pull request text for the intent behind it, and mark either as unverified when it cannot be read. The orchestrator may attach a code-explaining method for unfamiliar code and a history-recall method for why code is shaped as it is.

### 2. Find the one fact

Most risky-looking changes are safe because of a single fact, such as "every reader of this field copes with the new key". State it as one sentence that code or a run could show false. If it holds, most worrying cases clear together, so spend the effort here and not on a long list of maybes. Take a second fact only when the change really stands on two. If it seems to need more, the change is too wide for one review: go to step 6.

Some changes have no effect outside the diff, such as a rename of a local variable. For those the fact is that nothing outside the diff can see what changed. Say so with the evidence, and do not invent a risk to fill the report.

### 3. Look where search stops

A search finds names. It misses the source and pinned version of a library the change calls, and any local patch; when things run (ordering, retries, teardown, scheduled jobs); data that crosses a boundary (an API's JSON, a database column, a file or wire format); flags and config keys read by string; generated code; code several hops downstream; and other repositories or services. A place that cannot be read is unverified, not cleared.

### 4. Rate each risk honestly

Each risk states how it breaks, where (a real `file:line`), how likely it is and what it costs. Keep confirmed risks apart from the ones checked and cleared. A search that finds nothing is still an answer: quote the query and its scope. Never invent a caller, a file or an API, and say what was not looked at.

### 5. Request the proof

The central fact needs one executable proof: a small script or test that calls the real code, using the library version the project ships and the exact function in doubt, and that fails loudly if the fact is false. It is written as a run request, which the orchestrator carries out through its normal tools and returns the evidence for. A run request gives:

- the exact command and the checkout or directory it runs in;
- the inputs, taken from a real artifact such as a captured payload, a fixture or the shipped build, not from a description of one, and which artifact;
- the result that would show the fact holds and the result that would show it is false. A check that cannot fail does not count;
- the evidence that has to come back: output and exit status;
- every effect the run could have on shared state, not only on files: database rows, queue items, caches, checkpoints, outbound messages and calls to a live service. For each, how it is disabled or isolated (a test database, a stubbed sender, a copy of the queue) and what must be gone afterwards. A run that only reads says what it reads and why it creates, changes or sends nothing.

An isolated checkout or a redirected output contains file changes only, not effects on shared state. Where an effect cannot be isolated or undone, the request is not run: it goes to the orchestrator as a decision through `user-decision`.

An existing check can serve as the proof when it calls the real code and can fail on this fact; the request then names that command. If no run is possible, say why and how far the fact got on the ladder below. Until the evidence is back, the fact is unproven at the level reached.

### 6. A wide change

Ask the orchestrator to route bounded review: independent read-only reviewers, one slice and one question each, merged by file, line and risk, with disagreement shown. Each slice's central fact still gets a run request (step 5). A risk that depends on how something looks or feels goes to the owner on a review page, with the real artifact attached.

## How sure are you

Get each fact as far down this ladder as is cheap, and say where it stopped: 1, you said so (worth nothing alone); 2, you pointed at the line, a real `file:line` or the library's own source; 3, you walked the failure step by step and showed it cannot reach; 4, you ran it, with a script or test that calls the real code and fails loudly if you are wrong; 5, you reproduced it in the running application.

## What to hand back

The report has these parts, in this order. A part with nothing to report says so with the reason, and a part whose evidence is missing says unverified.

1. What the change does, including the part that is not obvious.
2. The central fact, the level it reached, and the proof as a run request or, once the orchestrator returns it, the evidence.
3. Confirmed risks, each with how it breaks, the `file:line`, likelihood, cost and how to check.
4. Cleared: what was checked and why, with the query and scope for each.
5. Before you merge: the cheapest test or repro that would catch the real bug, usually the proof itself.
6. Items for the orchestrator: run requests, decisions waiting for the owner, and places that could not be read.

Replace any secret or client data in quoted output with `<REDACTED>`. Prose follows the project's writing rules.

## Not this package

- A merge verdict, a general code review, the process of requesting review, or multi-model review: a code-review step, such as the deepreview, deeperreview and deepestreview skills.
- Security audits and vulnerability hunts: a security review. This package is not one.
- Pushing and the push gate: no-mistakes.
- Claiming that work is done or verified: a verification-before-completion step.
- Looking for the same mistake elsewhere once a bug is fixed: the closing step of root-cause-diagnosis, which looks sideways from a fixed bug where this method looks forward from a change.
- Design criteria this method turns up: engineering-principles, by name only (boundary discipline, migrate callers then delete, idempotent operations).

## Provenance

Credit and licence text for the upstream material this package adapts are in `references/upstream-notice.md`.
