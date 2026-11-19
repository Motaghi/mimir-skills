# Interrogate: the adversarial challenge step

This file is read together with `SKILL.md` when a chosen candidate, a diff or a claim must be stress-tested before it is accepted. It is a procedure for the requester and the lead reviewer. It dispatches nothing: every reviewer is requested from the orchestrator, which is the only router.

## Rule

State the intent in one paragraph. Ask the orchestrator for independent, read-only reviewers within its slot limits, and give each the same packet. Each reviewer looks for real problems in how the work achieves the intent, and does not question the intent itself. Then act as lead reviewer: merge the findings, put each in exactly one of four buckets with who raised it, and report a short verdict. Apply no change. A proposed change is reported to the orchestrator; this step never creates a branch, pushes or opens a pull request.

## Why

The author of a design or a diff shares its blind spots, and so does a single reviewer. Independent reviewers have different blind spots, so a finding that two of them raise without seeing each other is strong evidence, and a finding from one is worth reading but weighs less.

Adversarial reviewers are useful because they are aggressive, and aggression without context produces noise. They see a slice of the code and a one-paragraph intent. They do not know what was already tried and rejected, which constraints sit outside the code, which parts are scaffolding and which are permanent, or what the next change will address. The lead reviewer has that context and uses it to filter.

## Checks

For each check, cite the paths, packet text or finding identifiers that show the answer. A check with no citation is reported as unverified.

1. Scope: does the packet hold the change under review plus the surrounding files the reviewers need (callers, callees, types, sibling modules)? List the paths. If the scope came from the requester's pointer, say so. If you had to guess it, ask the orchestrator before going further.
2. Intent: is there one paragraph stating what the work is trying to accomplish, drawn from the requester's message, commit messages, any change description and the code? If you cannot state it with confidence, ask the requester through the orchestrator. Reviewers are told to assume the goal is right and challenge the execution.
3. Request, not dispatch: did you ask the orchestrator for a number of isolated reviewers that its slot limits allow, labeled Reviewer A, B and so on, each read-only? Record how many the orchestrator granted. If it granted one, run with one and say that agreement cannot be measured. This file names no model, provider, reasoning level, speed or agent type, and no catch-all agent. Who reviews is the orchestrator's routing decision. A reviewer that fails or times out is reported with a visible warning, never dropped.
4. Same packet: did every reviewer receive the identical intent, material, review lenses and quality lens below, with no assigned personas? Quote the packet once. Different packets make agreement meaningless.
5. Finding shape: does every finding carry a severity, a location, evidence and an optional suggestion? A finding with no evidence of a reachable path or a concrete problem goes to Dismissed. "No findings" is a valid reviewer answer.
6. Synthesis: were duplicates merged with every raiser noted, consensus separated from lone findings, and disagreements listed? A flag from one reviewer that another explicitly contradicts is context for the verdict. Say which findings are which.
7. Lead judgment: is every finding in exactly one bucket, with its raisers and a one-line rationale? Apply the filters under Lead judgment. A finding placed without a rationale is unverified.
8. Verdict calibration (see the section below): more than five Act on items means re-sort, or state why each stands. Confirm Dismissed is shown.
9. Nothing applied: did the step edit nothing and ship nothing? State what was proposed and who must approve it.

## The packet

Fill this in for every reviewer and hand it to the orchestrator.

> You are an adversarial reviewer. Find real problems in the work below: bugs, design flaws, security issues and maintainability concerns. You are not here to be encouraging. You are here to stress-test.
>
> Intent: {the one-paragraph intent}. Review whether the work achieves it well. Do not question the intent. Assume the goal is correct and challenge the execution.
>
> Material: {the diff, files or decision text, with the surrounding files}.
>
> Lenses: {the review lenses below}. Use the ones that apply and do not force the rest.
>
> For each finding give: a severity (`critical` for bugs, data loss, security issues or broken behavior; `warning` for design or maintainability risk that will cause pain; `nit` for style, naming or a minor improvement); the location; the finding in concrete terms; the evidence, with the reasoning shown; and, only if you have a concrete alternative, a suggestion. Cite specific code, not vague concerns. Separate "this is broken" from "I would have done this differently". Do not restate what the code does, and do not praise it. If you find nothing wrong, say "no findings" and stop.

### Review lenses

- Correctness: edge cases (empty, absent, boundary), error handling that swallows or propagates, state and concurrency, and both the happy and sad path. Idempotency: if the operation runs twice or a previous run stopped halfway, does the outcome depend on leftover state? If so, a reconciliation step is missing. When you find a potential bug, trace the execution path: do not just flag "this could be nil", show the call chain that makes it nil.
- Root cause or symptom: guard clauses that hide an invariant violation, retries that hide a broken contract, casts that silence a modeling error, a fix in one module that belongs in another's contract. Read beyond the changed files to see why the code exists. A rule kept as a comment or a convention might be a type, a check or a lint rule instead.
- Structure: validation once where data enters, abstraction level, coupling, data shape against access pattern, and whether the change reads as bolted on or as if the design always allowed for it. A new interface kept beside the old one with no outside consumer should replace it in the same wave. Do not penalize simple code for lacking abstraction.
- Verification: whether tests exist and check behavior, whether a bug fix has a test for the bug, whether an integration boundary is tested end to end, whether the check reads the real thing and not a proxy such as a file's timestamp, and whether delegated work is verified by its output and not its own report.
- Complexity: code that could be simpler without losing correctness, abstractions with one call site, configuration for cases that do not exist, dead code, compatibility paths kept past their migration. Simpler is better unless simpler is wrong.
- Security: for each claim, show the input path from source to sink. Look at user input reaching dangerous sinks, gaps in authentication or authorization on new entry points, secrets in code, logs or errors, and check-then-use gaps on security-critical paths.

### Quality lens

Be direct and demanding about structure, and look for restructurings that keep behavior and delete complexity, not only local cleanup. Ask in turn:

- Does a simpler framing make whole branches, helpers or layers disappear?
- Does the change leave a file larger than a reader can hold, judged against the project's norm, without a strong reason?
- Does it add ad-hoc conditionals or scattered special cases to an unrelated flow?
- Does it keep working code that a cleaner design would replace, when the behavior could stay the same?
- Is it direct, boring code, or does it use magic, thin wrappers and pass-through helpers?
- Are types and boundaries clean, without needless optionality, `any` or casts?
- Is logic in its canonical layer, reusing existing helpers?
- Is independent work serialized for no reason, or are related updates left half-applied?

Presumptive blockers unless the author justifies them: large incidental complexity a restructuring would remove, a file that has outgrown what a reader can hold, tangled branching, scattered feature checks, an unnecessary wrapper or cast-heavy contract, and duplicated helpers or logic in the wrong layer. Do not approve merely because behavior seems correct.

## Lead judgment

You are the lead reviewer, a pragmatic senior engineer, not a neutral aggregator.
- Act on: real issues for correctness, security or maintainability given the actual goals. They would block a real change.
- Consider: legitimate, but unclear whether they outweigh the cost of addressing them now. Worth the requester's attention, with the tradeoff stated.
- Noted: technically valid but not actionable, context-dependent or low impact at this stage.
- Dismissed: wrong, nitpicky or missing context, with a brief reason.

Filters to apply before bucketing:

- Nitpick gravity: reviewers inflate nits to fill the space. If every finding is a nit or a preference, the work is probably fine. Say so.
- Hypothetical or actual: "what if this is null" counts only if a caller can pass null. Trace the call site. If upstream validation or the type system prevents it, dismiss it.
- Premature abstraction: does the code need to change in a second way? If not, simple inline code beats an extraction.
- "I would have done it differently": a preference with no concrete problem is not a finding. Dismiss it and say why.
- Missing context: changes to code the author did not touch, patterns consistent with the rest of the codebase, advice that conflicts with a constraint you know. Dismiss these plainly.

Do not dismiss a finding because it is uncomfortable. Weight these up: independent agreement, a concrete execution path, a gap in your own model of the code, and the thought "yes, actually". Security and correctness findings deserve extra scrutiny even from one reviewer.

## Verdict calibration

A good verdict is useful, not exhaustive. The requester should be able to read Act on, fix those items and proceed with confidence. If Act on holds more than five items, the filtering is probably too soft: re-sort, merging items with one cause and moving the weakest down.

Dismissed is not busywork. It is how the requester sees what was rejected and why, and so overrides the lead where they disagree. Show it, even when short. Hiding rejected findings costs more trust than it saves space.

## Challenging a design candidate or claim

When the subject is the recommended candidate of a design comparison, or a design decision or claim the owner names, run the checks above with these additions. This is the one place the design-specific mechanics are written; `SKILL.md` only points here.

It is for decisions that cross a boundary, rest on a property the type system cannot check (ordering, idempotence, who owns state), depend on context a later reader will not have, or cannot be undone. Skip it for a cheap, reversible choice, a mechanical change or a clear instruction. A diff as such goes to a code-review step.

1. Claim, before the packet. Write what stands in two or three lines, for example "Candidate B is the right structure for X", and why it matters. If it cannot be said that briefly it is still a hunch, so settle it first. The claim stays with the lead reviewer and is never handed on.
2. Extract the smallest unit a reviewer can hold in one read: the candidate (usage and shape) plus the contract, which is the problem sentence and the sourced constraints. Strip the reasoning: no account of why it won, no comparison, no recommendation. Split a unit that is too large first. In the packet, the Intent is the contract and the Material is the candidate.
3. Ask and reconcile as checks 3 to 7 say. Before bucketing, check whether a finding exists only because the contract was unclear or incomplete. If so, repair the contract and run the next cycle, and do not bucket it as a flaw. A fresh reviewer lacks context and can be wrong, so being fresh is not authority, and being uncomfortable is not grounds to dismiss. When the owner names the red-team reviewer, that persona is the adversary and this package supplies only the packet and the buckets. No question about a second provider is asked and none is named; if policy calls for one, the orchestrator arranges it.
4. Stop. A cycle is one round of reviewers on the current candidate. Stop when a cycle brings only trivial or already-weighed findings, after three cycles, or when the owner says to go ahead. If the third cycle still brings substantive findings, the candidate is not ready: report that to the owner through the orchestrator and run no fourth cycle alone. If three cycles clearly cannot cover it, the candidate is too big, so split it and never lift the bound. Do not rerun on an unchanged candidate. If two cycles of substantive findings produce no Act on item, the step is validating and not challenging: stop and say so.
5. Apply nothing. A proposed change to the candidate is reported to the orchestrator, and the revised candidate re-enters the comparison step in `SKILL.md`.

Facts about a library, a framework or a regulation are checked under the project's own fact-checking rule. This step tests reasoning about the artifact.

## Output

- Intent: the one-paragraph statement, quoted.
- Reviewers: each label and its finding count. No model or provider names.
- Act on, Consider, Noted, Dismissed: each finding with its raisers, location and rationale. For Act on, say why it matters. For Consider, the tradeoff. For Dismissed, the reason.
- Agreement map: where reviewers agreed and diverged, and what the pattern says.
- Proposed changes, if any, marked as unapplied and addressed to the orchestrator.

## Example

The intent: replace a polling loop with a file-change trigger so the job starts when the input lands. The orchestrator grants two reviewers. Both flag that the trigger can fire before the writer has finished the file; the call chain shows the writer creates the file in place. That is Act on, with both raisers, and it matters because the job would read a partial input. Reviewer B alone suggests extracting a watcher interface. There is one call site and no second use is planned, so it is Dismissed as premature abstraction. Reviewer A alone flags a possible null path result; the caller validates the path upstream, so it is Dismissed with that reason. Reviewer A also notes the old polling code is still present; with no outside consumer, that is Consider, since deleting it in the same wave is cheap. The verdict has one item to fix, one to weigh and two shown as rejected.

A review that returns seven Act on items is sent back for re-sorting under check 8. Merge the three that share the partial-read cause and move the two weakest to Consider.

## When it does not apply

- Trivial changes such as a typo, a rename or a comment, where a normal diff review is enough.
- A routine diff review. A code-review step handles that and owns the final verdict.
- Multi-model review of any subject. The deepreview family wins there. This step never selects a second provider or tool.
- When the owner asks for the red-team reviewer by name. That persona is the adversary, and this file then only supplies the packet and the bucket rules.
- When the question is whether the intent is right. That is a clarifying question or an owner decision, not an execution challenge.
- When the orchestrator grants no reviewer slot. Say so and stop; do not self-review and call it adversarial.
