---
name: build-team
description: >-
  Run a significant development build with a PM, an isolated test author who
  freezes an acceptance suite from signed spec examples, two senior developer
  roles, and independent QA. Use for milestones, implementation plans, feature
  sets, pair-review requests, and work where independent review matters. Adapts
  to the live agent capabilities of the current host without assuming provider
  or model names.
---

# Build Team

Run a build through explicit roles, an acceptance suite the implementers did not
write, independent review, and a PM-owned gate. The method adapts to the tools
exposed in the current session. Do not infer capabilities from the host name.

The reason for the method: agents must not own the test oracle. An agent that
writes the code and its tests restates its own reading of the intent, so the
suite can pass while the build does the wrong thing. Authority enters once, when
the owner signs the acceptance examples in the spec. An isolated test author
transcribes those examples into a frozen suite, and the build is judged against
that suite.

## Authority order

Apply these sources in order:

1. The user's current instructions and approval boundaries.
2. Project instructions, accepted plans and specs, task contracts, and repository rules.
3. Tool permissions, sandbox limits, and terminal or stop-state rules.
4. This skill's workflow.

A project hard stop, no-retry rule, fixed command list, or terminal state outranks
the frozen-suite loop, debugging, review retries, and completion pressure. Do not
install tools, change configuration, write logs, update plans, commit, push,
deploy, or widen scope unless the higher authority permits it.

## Capability preflight

Before claiming a build-team run, inspect the live tool catalog and current
routing policy. Determine whether the session can:

- create isolated agent contexts and identify when each one is terminal;
- send a later task or review response to an existing context;
- run the required contexts concurrently or in separate waves;
- restrict reviewer writes, or at least detect reviewer mutations;
- expose provider or model selection, if any;
- start a separate agent context for the test author with a workspace that holds
  only the spec, the criteria and the public interface names;
- run the project's authorized checks and source-control workflow.

Use the live schemas. Hosts expose different agent tools, and extensions can
change any host's capabilities. In the vocabulary of this repository's README
the run needs `subagent-orchestration`, `filesystem`, `git-read`, `shell` and
`user-decision`.

Choose one mode and state it before implementation:

- **Full team:** PM plus isolated test author, dev #1, dev #2, and QA contexts.
  dev #2 and QA are fresh reviewer contexts, independent from dev #1 and from
  each other. The test author is independent from all of them.
- **Full team, verified read-only:** the same contexts, but write denial is not
  mechanical. The PM fingerprints repository state before and after each review.
- **Solo guarded:** isolated contexts are unavailable. Keep the useful check and
  gate disciplines, but state that build-team independence is unavailable.
  Offer external review handoffs or explicit solo execution. Never describe a
  self-review, or tests written by the implementer, as independent.

Provider diversity is optional for most roles, not a fixed split. If the current
routing policy can choose providers or models, prefer useful diversity without
overriding that policy. One exception is required: for a high-stakes build the
test author runs on a different model family from the implementers, and QA
should too. If the policy cannot provide one, stop and ask the user rather than
let the implementers' model family write the suite. Record provider or model
metadata only when the dispatch or result makes it observable. Do not guess, and
do not ask the user to choose a provider unless the governing policy requires
that decision.

Lane declaration. The run declares single-lane or multi-lane at kickoff. The
moment a second lane opens, at kickoff or later, load the
`parallel-run-control-plane` skill from this repository and post the change on the
run channel. Any run whose output reaches an end user, a store page, or a public
post loads `run-close-pack` with the project's profile once the last feature
lane has a verdict. A single lane with an outer watch does not load the control
plane.

## Roles and authority

- **PM:** owns plan interpretation, task briefs, authority checks, reviewer
  independence, gates, task state, and source-control actions. The PM does not
  write feature code. The PM is the sole committer.
- **Test author:** writes the acceptance suite from the spec before any
  implementation exists, using the kickoff brief in `references/test-author-brief.md`
  with its placeholders filled in. The test author never sees implementation
  code. It reads only a workspace holding the spec, the acceptance criteria with
  their examples, and the public interface names. For a high-stakes build it runs
  as a separate agent context on a different model family from the implementers,
  chosen by the routing policy. For a low-stakes build it is an isolated
  subagent with the same brief. If the host cannot confine the workspace, the
  brief's isolation rule is a rule and not a sandbox, and the build report says so.
- **dev #1, implementer:** is the only feature-code writer. Builds against the
  frozen suite, refactors within scope, runs the authorized task checks, and
  returns the diff and evidence. Never edits the suite, except that the driver
  file may change for a boundary rename. dev #1 never commits.
- **dev #2, reviewer:** read-only. Reviews the completed diff in its own context
  for behavior, scope, design, and project invariants before anything lands.
  Returns concrete findings to the PM.
- **QA, adversary:** read-only and separate from both developer contexts.
  Receives the original intent and the acceptance criteria, not just the diff.
  Looks for inputs, states, and user-visible outcomes that still fail despite the
  passing suite. Returns reproducible evidence, not general approval.
- **Arbiter, high stakes only:** a fresh context that rules on literal
  contradictions between the spec and the suite. Anything ambiguous goes to the
  owner, not to the arbiter.

If reviewer read-only access cannot be enforced, fingerprint `HEAD`, index, and
worktree before and after the review using project-authorized read-only commands.
Any reviewer mutation invalidates that review. Stop, disclose it, and route any
needed change through dev #1.

## Before you start

The spec must carry an Acceptance criteria section and a `stakes` field with the
value high or low. Check it with the spec readiness check (the contract is in
`references/acceptance-checks.md`). A spec that fails goes back for sign-off before
any work starts. Name the stakes in the build log. High stakes get the separate
test author context and the arbiter. Low stakes get the isolated subagent and no
arbiter.

Build on a branch or a worktree. The frozen suite is red until the build is done,
and a red suite on the shared tree blocks every other session's gate.

## Per-task loop

1. The test author writes the suite from the spec into an isolated workspace,
   including the driver, the stub, and a gap log if anything is unclear.
2. PM copies the suite into the repository.
3. Stub-fail check (see `references/acceptance-checks.md`): the PM runs the suite against the stub and
   requires every test to fail there by an assertion. A failure caused by any
   other error, or by an error outside the test body such as setup, does not
   count. A single test may pass against the stub only when its signed example
   expects exactly the empty result the stub gives; the test author lists each
   such test with that reason in the suite's frozen allowed-pass file, and the
   PM passes that file to the check. Any other passing test goes back to the
   test author to gain a control drawn from another example of the same
   criterion. Nobody changes an expected value to make a test fail. The check
   also confirms the run was complete, so run the test command directly with no
   stop-at-first-failure options.
4. The suite is committed and frozen. The PM records the freeze commit.
5. PM selects the next authorized unfinished task and briefs dev #1 with its
   acceptance criteria, constraints, invariants, and allowed checks.
6. dev #1 builds against the frozen suite and returns the diff and evidence
   without committing. A behavior change is a spec change and goes back to the
   owner.
7. dev #2 reviews the diff in its independent context. Findings return to dev #1
   through the PM.
8. On every diff the PM runs the assertion-diff check, which rejects any change
   to the frozen suite outside the driver, and the criterion-tag check, which
   requires every criterion ID to be tagged on at least one test that ran. Tags
   and outcomes come from the test run, never from source: delete the manifest
   path first, run the suite with the run-manifest reporter, treat a failing
   test-runner exit code as a failed gate whatever the manifest says, and pass
   every manifest to the tag check. A criterion is defined wherever a spec line
   starts with its ID, including amendment sections. The format and the checks
   are specified in `references/acceptance-checks.md`.
9. QA performs an independent pass against intent and criteria. Reproducible
   defects return to dev #1 unless a higher-priority terminal rule requires an
   immediate stop.
10. PM runs the gate, confirms reviewer contexts did not mutate the tree, and is
    the only role allowed to commit.
11. PM updates a plan checkbox or build log only when the project authorizes that
    write. Then move to the next task.

Spec gaps found by the test author park the affected criterion and the build
continues on the rest. A criterion can also be parked by an owner ruling. Parked
criteria are listed in the build report; where the project keeps a parked-criteria
list for its acceptance suites, the PM adds the criterion there so its frozen
tests are deselected. The frozen test files themselves are never edited to park
a criterion. The PM batches parked criteria and puts them to the
owner through the host's question tool.

Implementer scratch tests are allowed, never requested, never gated, and never
counted as proof.

Do not let dev #1 spawn or nominate its own reviewers. Do not reuse dev #1 as a
reviewer after a prompt reset. Context independence is part of the evidence.

## Execution economy

The task brief declares focused, affected, or gate validation. This selects work;
it does not create another approval step. A focused correction uses the smallest
relevant slice of the frozen suite and directly affected runtime observation. An
affected change adds its integration checks. Shared invariants and integrated
candidates run the required project gate. Do not repeat unrelated suites or
browser journeys for a small correction.

Reuse completed evidence when the relevant source, executable, configuration and
inputs match. Batch independent source changes behind one integration artifact
when ownership permits. In multi-lane work, each isolated lane can have its own
implementer; one integrator owns shared candidate writes. Reviewers remain
independent of the source they assess.

Independent acceptance lanes use separate immutable artifacts, profiles and
owned resources concurrently when capacity is available. Do not make one lane
wait for another lane's verdict or cleanup unless they actually share a required
resource or source dependency. Reassign released reservations promptly. A local
case failure must retain its evidence and allow unrelated admitted cases to run;
shared identity or ownership failure still stops the affected runtime.

Reuse an established runtime harness instead of rewriting launch and cleanup for
each behavior. A changed runner gets a cheap known-pass/known-fail child check,
including timeout and cleanup paths it changes. Syntax checking alone does not
exercise shell semantics. Resolve fixture routes, selected cases and input owners
before consuming a browser slot. Setup failures and zero-case runs are not
product verdicts. After two setup failures, repair the common runner contract
before another product attempt; inspect the correction, not the entire unchanged
packet. Preserve existing stop and retry authority.

Generate evidence references from files rather than transcribing hashes. Write
covered files first and the manifest last. Consumers verify the exact binding;
prose points to that record instead of creating another metadata copy.

Progress percentages require a fixed, defensible scope denominator. Without one,
report accepted, source-approved and open behavior separately. Dispatches, elapsed
time, worker counts and test counts are not completion. Read targeted evidence
fields; do not dump full runtime state into every coordinator context.

The kickoff authorizes the routine loop. Send a start with a bounded output, then
only a material blocker, reviewable artifact, verdict, accepted behavior or
requested scheduled report. Omit routine ACKs, repeated identities and unchanged
ETAs. Liveness belongs in the monitor; it is not a progress event.

## Test and review discipline

Name tests as observable behavior at the system boundary. The frozen suite is
black box and contains no unit tests. The stub-fail check, not a developer review,
shows that a test can fail. Write QA prompts in neutral wording: ask for inputs
that produce incorrect results or crashes, and for cases the suite would still
pass under a broken implementation. Do not frame the work as attacking anything.

Review must be independent. The PM runs dev #2 and QA as their own passes and
disregards any reviewer an implementer spawned for itself.

Scale the ceremony to risk. Stakes high or low is the main lever and is named in
the build log. Within a build, drop to dev #1 plus QA on small mechanical tasks.

Line and branch coverage is printed in the build report as information only. It
never decides the gate. Do not install a measuring tool or edit project
configuration without authority, and claim only coverage that an executed
command measured.

A green suite is not a shipped feature. For visual or interactive work, QA must
inspect the actual running result with an available authorized browser,
screenshot, simulator, or equivalent. If that inspection is unavailable, report
the missing evidence and do not claim visual completion.

## PM gate

Before a commit, the PM verifies:

- the frozen suite is green with the project's test command;
- the assertion-diff check and the criterion-tag check both pass, with parked
  criteria listed in the build report exempt from the tag check;
- every other required authorized lint, type, build, and runtime check passed;
- dev #2 and QA completed independent reviews with no unresolved real defect;
- repository invariants changed only where the task allowed;
- the diff is scoped and the working tree contains no reviewer-authored changes;
- the commit method and task-state writes are authorized by project instructions.

If any item cannot be verified, say exactly what is missing. Never convert an
unavailable check, reviewer, provider identity, or runtime observation into a pass.

## Build report

The PM writes a build report at the project's designated report location, with
this frontmatter: date, type `build-report`, status, description, tags, the spec
path, stakes, the suite directory, the list of parked criteria, the count of
escaped defects, the count of rework tasks, and line coverage as a number marked
information only. The body holds an Acceptance criteria table with the columns ID,
Criterion, Examples and Tests, one row per criterion with its test names, and an
Escaped defects section. Count rework tasks from QA round-trips. State plainly
when test-author isolation was rule-based and not sandboxed. A defect found after
landing is appended to the same report and the count is bumped, so later builds
can be compared on escaped defects and rework.

## Report fields

The PM's report for a task records each decision that shaped it with six one-line
fields: ts, phase, decision, why (plain words), evidence, result. Evidence is a
pointer that resolves, such as a commit sha, a path, `file:line` or a saved
output, never a paragraph. Result is the observed outcome, such as `tests green`,
`reverted`, `open` or `inconclusive`; an entry with no resolving pointer is marked
unverified. A wrong entry is superseded by a later one that points back to it, and
no past entry is edited. Write them in the build log only when the project
authorizes that write; no new file, script or ledger is added. The fields record
the trail and do not replace the PM gate. They match the run-close-pack fields.

## Pull requests and CI

When project rules require pull requests, dev #1 leaves the working diff, dev #2
and QA review through their independent contexts, and the PM alone performs the
authorized commit, PR, or merge actions. CI adds evidence but does not replace
the two independent reviewer contexts.

## Provenance

The report fields (the six decision fields, evidence as a pointer, superseded entries) and the cheap-local-test trigger adapt ideas from the `show-me-your-work` and `tdd` skills in pstack by Lauren Tan (cursor/plugins, MIT). The rest of this skill is original. Credit and licence text are in `references/upstream-notice.md`, and the repository's `CREDITS.md` lists the pinned commit.
