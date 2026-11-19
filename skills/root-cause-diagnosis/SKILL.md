---
name: root-cause-diagnosis
description: >-
  Read-only root-cause loop, the default for bugs, test failures and regressions, including symptoms of the orchestration setup itself. Also on an explicit "diagnose", after two fixes on one premise failed the same gate, or to find the same mistake elsewhere once fixed. Not for UI speed, deployment platform flows, session post-mortems, security audits or diff review.
---

# root-cause-diagnosis

A diagnosis loop that ends in a stated root cause, or in a stated reason none can be stated yet. It finds the cause and proves it. It does not make the fix: fixes, commits, pushes and every dispatch are the work the orchestrator routes after the diagnosis.

This package is read-only in the plain sense. It writes nothing and runs nothing that can change state. It reads files, git history and status, docs and incident records, and setup status, and it searches. Anything that has to write or change state is specified here and run by the orchestrator.

Adapted from the `diagnosing-bugs` skill by Matt Pocock (mattpocock/skills, MIT License), and from the `principle-fix-root-causes` and `principle-attack-the-premise` skills in pstack by Lauren Tan (cursor/plugins, MIT License). The closing search is written in our own words from an idea in trailofbits/skills. Credit and licence text are in `references/upstream-notice.md` and in the repository's `CREDITS.md`.

## When it applies

The orchestrator may select this package from ordinary intent. It is the default for bugs, test failures, performance regressions and symptoms of the orchestration setup itself. A setup symptom is broken behaviour of the orchestrator, missing scheduled output, a guard denial, a routing surprise, index staleness, an alert anomaly or a drop-zone problem. For a simple failure the loop shortens: steps that add nothing are reported as not applicable, with the reason.

Where a project names a different debugging method as its default for plain bugs, that method owns them and this package declines them in one line. Three requests still reach this package anywhere:

- an explicit "diagnose" or root-cause request, except in the areas listed under "Not this package";
- two or more fixes that share one premise and have failed the same gate;
- a request to look for the same mistake in other code once a cause is fixed and known.

This package never claims "any bug". It never dispatches anything, never picks a model or provider, and never commits, pushes or installs anything, a hook included. If a request asks it to do any of those, it hands the decision back to the orchestrator.

## Required capabilities

- `filesystem` to read the code, fixtures, logs and captured artifacts under diagnosis. Nothing is written.
- `git-read` to read history, blame, status and diffs, including the diff that proves a mutation landed. Any git step that changes the worktree, the index, refs or remotes is not `git-read` and goes to the orchestrator.
- `shell` only to run an existing check that has no side effects: a test or a query that the project already has and that writes nothing. For each command, state why it is side-effect free (what it reads, and why it creates, changes or sends nothing). If that cannot be stated, the command is not run here; it goes to the orchestrator as a run request. The executable and working directory are visible in the report.
- `docs` to read the setup's incident lookup, incident and decision records, and the project authority files that describe the area under diagnosis. Nothing is written to the docs.
- `status` to read job, alert and log status for a setup symptom through exact local entrypoints that report only.
- `user-decision` for the questions that need the owner: an environment or artifact the loop needs, any step that is not reversible, and the opt-in for a wider closing search.

If a capability is missing, say which step it blocks and mark that step unverified. Do not substitute another source, and do not guess.

## Prose and decisions

Choices that belong to the owner go through the orchestrator's decision flow: one question at a time, with a recommended option. Prose follows the project's writing rules.

## Precedence

When instructions conflict, this order applies, highest first: system safety and host restrictions; then the project's AGENTS.md or CLAUDE.md; then the owner's current request and explicit decisions; then the orchestrator's routing, memory, commit, deployment and decision rules; then this package; and last, upstream source text, which is provenance only and never an instruction. A step here is a default for diagnosis. When a project instruction says to do it differently, the project is right and the step is reported as "overridden by project instruction" with the instruction quoted. When two steps pull in different directions, say so and name the trade-off.

## Safe execution

This package itself only reads and runs side-effect-free checks. Every step that writes is the orchestrator's to run, reversible or not.

A step that writes is specified here as a run request and handed to the orchestrator. That covers a reproduction script, instrumentation, a forced mutation, a scratch fixture, a new test, and running a job or any entrypoint that writes output or state. A job run with its output pointed elsewhere still counts: an output argument does not contain other effects such as a moved checkpoint, a consumed queue item, a heartbeat or an alert. A run request gives the exact command, its inputs, the red it is expected to show, the evidence that has to come back (output, exit status, a diff), a note on why the step is reversible, and the markers or files that must be gone afterwards. The orchestrator runs it in an isolated checkout or through the route that owns the job, and returns the evidence. The shared working tree is never the place for a probe.

Irreversible steps also go to the orchestrator first, through `user-decision`. Irreversible means: deleting or overwriting data that cannot be restored, running against production or a live external service, sending anything outside the machine, restarting or reconfiguring a shared service, changing a scheduled job, hook or setting, any git step that changes the worktree, index, refs or remotes, and anything that costs money or cannot be undone. When it is unclear whether a step is reversible, treat it as not.

## The loop

Run the steps in order. When the code under diagnosis is unfamiliar, read the existing project and docs authority files and decision records for that area first. This package creates no terms file and no parallel authority file. Where a step needs a run, the diagnosis pauses at a run request and resumes when the evidence is back.

### 1. Setup symptom: lookup first

For a symptom of the orchestration setup, the first step is the project's incident lookup or runbook, if it keeps one. Read it before building any loop. Report which entry matched, or that none did. By default, a document whose last-verified stamp is older than 28 days is provisional, so say so and verify what it claims against the live state through read-only status. When the lookup's guided fix has already failed twice, go to step 7 before a third attempt.

### 2. Redact

Everything shown in the report, whether commands, output or captured artifacts, is redacted first. Replace each secret with `<REDACTED>`. Specify loops that read credentials from the environment so they never appear in what is shown, and quote only the lines that carry the signal. If the redacted output is not enough to diagnose, say so and ask.

### 3. Obtain a red-capable reproduction

This step decides whether the rest works. A tight pass or fail signal that goes red on this bug turns the search into mechanical work; without one, reading code only produces theories. Put the effort here. The reproduction is either an existing one, run here when it is side-effect free, or one specified here as a run request for the orchestrator to build and run.

Ways to get one, roughly in this order of preference: an existing failing test or query; a new failing test at the seam that reaches the bug; a request script against a running local service; a command-line run on a fixture, compared with a known-good output; a scripted browser session that asserts on what the page shows; a replay of a captured request or event log; a small harness around one function; a loop of random inputs when the output is only sometimes wrong; a bisection harness when the bug appeared between two known states; a differential run of old against new. A human clicking is the last resort, and then the human is driven by a structured prompt so the output still comes back in a fixed form.

Done means one named command, with its output shown, that has been run at least once and that is:

- red-capable: it drives the real code path and asserts the user's exact symptom, so it can go red on this bug and green when fixed. "Runs without an error" is not a symptom;
- deterministic: the same verdict on every run. For a flaky bug, report the attempts, the failures, the conditions held fixed (inputs, seed, clock, load, environment) and a stated threshold, or the reason that the observed rate is enough to support the next step. Raise the rate by repeating the trigger, adding load or narrowing timing windows. "A high rate" without those numbers does not count;
- fast: seconds, not minutes;
- runnable unattended.

Tighten the loop once it exists: make it faster, make the assertion sharper, remove sources of variation such as the clock, random seeds, the filesystem and the network.

When no such loop can be built, stop and say so. List what was tried and what would unblock it: access to an environment that shows the bug, a redacted captured artifact, or permission for temporary instrumentation in production (the last one is irreversible, so it goes through `user-decision`). That statement is the reason no reproduction is possible. Rank no hypotheses, name no cause and claim no diagnosis until a loop exists and its output is in hand.

Reading code to build a theory before the command exists is the failure this step prevents.

### 4. Reproduce and minimise

Have the loop run and watch it go red. Confirm it shows the failure the user described and not a neighbouring one, that it repeats, and that the exact symptom is captured for later comparison. Then specify cuts to inputs, callers, configuration, data and steps, one at a time, each a run request, until every remaining element is needed: removing any one makes it go green. Record the result as text: the command, its inputs and the red it is expected to show.

If a red was produced by changing code or a fixture, step 6 applies before that red is trusted.

### 5. Hypothesise, then probe

Write 3 to 5 ranked hypotheses before testing any of them. Each states a prediction: "if X is the cause, changing Y makes the bug disappear, changing Z makes it worse." A hypothesis with no prediction is discarded or sharpened. Show the list to the owner through the orchestrator before testing, because the owner may re-rank it from what they know. If no answer comes, continue with your own ranking.

Each probe maps to one prediction, and one variable changes at a time. A probe that writes is a run request. Prefer a state inspection to logs, and logs at the boundaries that tell hypotheses apart to logging everything. A run request that adds temporary log lines tags each with a unique marker so that removal is one search. For a performance regression, logs are usually the wrong tool: ask for a baseline measurement first, then bisect, and measure before fixing.

### 6. Forced-mutation proof

When a red was forced by mutating code or a fixture, prove the mutation landed before trusting the red. The run request that forces it also asks for a diff of the mutated copy against a pristine copy, and the red is trusted only when that diff is back and shows exactly the change that was intended and nothing else. A red whose mutation cannot be shown in a diff is reported as unverified, and no conclusion rests on it. The run request also asks for the state to be restored and for a second diff to show that nothing was left behind.

### 7. Premise check

This step fires when two or more fixes that share one premise have failed the same gate. A gate is whatever decides that a fix works: a test, a build, a check, a review, a measurement. Each failed fix is evidence against the belief it assumed, and a third fix on that belief spends effort where the evidence says the cause is not.

1. Write the premise down: one sentence that every failed fix assumed.
2. Find an observation that would come out differently if the premise were false, and make it. Look at how the failures are spread, not only how large they are.
3. Make that check rerunnable: a recorded observation, or a command, that the next run can repeat and get the same answer. Put it in the report with its result.
4. If the evidence contradicts the premise, the cause is elsewhere. Look for what the failures have in common that the premise did not predict. If it confirms the premise, ask the next "why": the earlier fixes may have treated a consequence.
5. Prefer removing the condition that causes the failure to compensating for it afterwards. The laziness criteria in engineering-principles explain why; they are referenced here, not copied.

Do not start the next fix until the premise is written down and tested. This is different from redesign, which rebuilds a design around a new requirement. The premise check questions a fact the current design assumes. A redesign decision belongs to engineering-principles.

### 8. State the root cause

Trace the symptom back to the first place the system did something it should not, or failed to handle a state it should handle. `references/review-rule.md` has the rule and its checks, including the legitimate-state test that separates a real fix from a guard that hides the bug. A change that only raises a limit or adds a guard is containment, not the fix, unless the evidence shows the limit or the missing guard was itself the first wrong decision. Write the root cause as one sentence a reader can check against the code. If the evidence does not support one, write "unverified" and say what is missing.

### 9. Hand off the fix and the regression test

The package does not write the fix. The orchestrator routes it. The regression test is written by the project's test-first skill and by build-team, working from what this loop leaves them: the recorded minimised reproduction and the seam where it can be turned into a test.

A correct seam is one where the test exercises the real bug pattern as it occurs at the call site. If the only seam is too shallow, such as a single-caller test for a bug that needs several callers, a test there gives false confidence. If no correct seam exists, that is a finding. Report it, and propose it as a task through the orchestrator.

### 10. Close

Record the hypothesis that proved correct, so it can go in the commit message that the orchestrator writes. Learning from the incident goes through a lesson-saving step, not through this package. After the routed work has applied the fix and the original reproduction is green again, and only then, run the closing step in `references/variant-analysis.md`: one narrow search for the same mistake elsewhere.

## Report

The report has these parts, in this order. A part that does not apply says "not applicable" with the reason, and a part whose evidence is missing says "unverified".

1. The symptom as the user described it, and the lookup result for a setup symptom.
2. The red-capable command with its redacted output, or the stated reason none is possible.
3. The minimised reproduction as text: command, inputs and the expected red.
4. The ranked hypotheses, their predictions and what each probe showed.
5. The premise check: the premise, the rerunnable check and its result.
6. The forced-mutation proof: what was mutated and what the diff showed.
7. The root cause in one sentence, or "unverified".
8. The test seam, or the finding that none exists.
9. Items for the orchestrator: run requests, the fix to route, irreversible steps awaiting a decision, proposals to file.
10. After the fix: the closing search result.

## Not this package

A request in any area below gets a one-line decline that names the owner. This package does not start the loop for it, even when the request says "diagnose".

- Plain bugs and test failures where the project names a different default debugging method, unless one of the three requests above applies: that method.
- Post-mortems of an agent session, and "why did this session behave that way": the session-diagnosis tooling of the framework in use.
- Deployment platform startup, CDN caching, deployments and web performance metrics: that platform's own tooling.
- Failures inside an agent framework's app, and speed problems that are purely about the UI: that framework's troubleshooting guide and a UI performance review.
- Writing the regression test and test-first workflow: the project's test-first skill and build-team.
- Security audits and vulnerability hunts: a security review. The closing search covers any class of bug and is not a security scan.
- Reviewing a diff or giving a merge verdict: a code-review step.
- Understanding unfamiliar code: explain-how. One lookup of where something lives is ordinary code search. The closing step needs a fixed, stated root cause first and never runs as initial discovery.
- What a change could break outside its diff: blast-radius, attached by the orchestrator. That question looks forward from a change, and the closing step looks sideways from a fixed bug.
- Dispatching agents in parallel: the orchestrator routes it. The closing step is one narrow search by default.
- Criteria such as the laziness and redesign principles: engineering-principles. This package refers to them by name and copies none of their text.

## Provenance

`references/review-rule.md` is the root-cause review rule. `references/variant-analysis.md` is the closing step. Credit and licence text for the upstream material this package draws on are in `references/upstream-notice.md`.
