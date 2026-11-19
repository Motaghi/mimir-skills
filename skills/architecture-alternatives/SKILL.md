---
name: architecture-alternatives
description: >-
  Two or three structurally different designs for a code or system structure with no precedent, compared on one review page, then an adversarial challenge of the pick. Not general brainstorming, implementation plans, UI shape, named design criteria (engineering-principles) or diff review; the orchestrator routes throwaway builds.
---

# architecture-alternatives

Turn a structural fork in code or system design into a choice the owner can make by looking: two or three structurally different designs, compared side by side on one review page, with one recommended and challenged before the owner decides. The package writes nothing and starts nothing. Contributors, reviewers and the page are requests to the orchestrator. It ends at the decision and a rationale.

Adapted from the `architect`, `interrogate` and `principle-exhaust-the-design-space` skills in pstack by Lauren Tan (cursor/plugins, MIT License), with the challenge step also drawing on `doubt-driven-development` by Addy Osmani (addyosmani/agent-skills, MIT License). Credit and licence text are in `references/upstream-notice.md` and in the repository's `CREDITS.md`.

## When it applies

The orchestrator may select this package from ordinary intent when the request is for options on how code or a system should be structured and nothing in the project answers it yet: "design this twice", "where should this state live", "compare approaches". Three kinds of request reach it:

- A structural fork: the candidate answers differ in the model itself, such as who owns a piece of state, where a boundary sits, what the data looks like or what runs when.
- A challenge of a design decision or claim the owner names: "poke holes in this design". Only the challenge step runs.
- A chosen shape that keeps meeting friction in the build: see `references/reopen-chosen-shape.md`.

General design conversation with no structural fork belongs to a brainstorming flow. When it turns up a fork, the orchestrator may route that fork here; this package never chains itself behind another skill. If a precedent or a single constraint settles the question, say so in one line and stop (step 3). When the scope is unclear, state the reading you are taking in one sentence and go on.

## Gates on every path

These apply before step 1, again whenever a step would read, write or run something, and to every reply, a refusal or a hand-back included.

- Confidential material. The project's own rules on confidential material win.
- A pending owner choice. While a clarifying-question session or another owner decision is unconfirmed, this package starts no prototype, build or state-changing probe. Candidates are text and a page; nothing runs.
- The package never dispatches anything, never picks a model or provider, and never commits, pushes, installs anything (a hook included) or schedules a job. If a request asks for any of those, hand the decision back to the orchestrator.
- Output. Drafts stay unsent. A secret is never requested and never shown in chat; replace one in quoted material with `<REDACTED>`.

## Required capabilities

- `filesystem` to read the code, tests, configuration and project documents around the problem, and the files in this package. Nothing is written.
- `git-read` to read history of the affected area for earlier attempts and reverted designs: log, blame and text search. No command that changes the repository.
- `shell` for read-only search and listing only: every writer of a piece of state, every importer of a module. No command that writes, installs, builds, runs the project's code or tests, or reaches a network.
- `docs` to read design notes, specs and decision records. Nothing is written to the docs.
- `review-page` for the comparison page. The orchestrator builds it, and the exact submitted answer comes back.
- `subagent-orchestration` to receive isolated contributor drafts and reviewer findings that the orchestrator routes under its slot limits. The package never starts, picks or configures them.
- `user-decision` for the choice among candidates and any owner decision a step raises.

If a capability is missing, say which step it blocks and mark that step unverified. With no contributor slot, draft the candidates yourself and say isolation was not achieved. With no reviewer slot, the challenge step stops; never call a self-review adversarial. With no page capability, give the orchestrator the page content as a labeled text block, marked not rendered.

## Method

1. Pin the problem. One sentence for what is being designed and why the shape is not obvious, then the constraints, each with where it comes from. A constraint you cannot cite is a preference. The better design is the one where a change that looks right from one file is right for the whole repository.
2. Ground it. Read the code, tests, configuration and decision records around the problem. Naming a file is not grounding. For an unfamiliar subsystem the orchestrator attaches a code-explaining method. When a candidate would change ownership or layering, the orchestrator attaches a history-recall method in its why mode, so the recorded reason for the current shape becomes a constraint. Skip this step only when the work is greenfield. Record what was read and what was not.
3. Precedent and fork test. Run checks 1 and 2 of `references/exhaust-design-space.md`. If the project already answers the question, follow it. If a cited constraint dictates one approach, do that one thing. If the choice is cheap to reverse, or it is an emergency, take the smaller option and let any comparison wait. Say so in one line and run no further step. A project instruction that fixes the shape wins.
4. Write the candidates. Two or three, never more unless the owner asks, following checks 3 and 4 of the same file. Each carries, in this order: the usage first, meaning the caller's view with two or three realistic call sites; the shape, as types and signatures with bodies marked not implemented, or a module map for larger work; what it makes easy; what it makes hard; what it changes around it, citing files; the cost to reverse; and the red flags it trips. The shape is derived from the usage, and the usage wins a disagreement.
5. Contributors. Ask the orchestrator for isolated contributors within its slot limits, so the first draft does not anchor the rest. Each gets the same brief (problem, constraints, grounding, candidate fields, red-flag list) and none sees another's draft. Merge drafts of the same shape. Keep the three shapes that differ most if more come back, and say what was dropped. If fewer than two come back, ask for one more and name only the axis the returned shapes share, never a draft. A failed or timed-out contributor is reported with a visible warning. Ask for no model, provider, reasoning level or speed.
6. Compare and recommend. Screen each candidate against `references/design-red-flags.md`. Put the candidates side by side on the same fields, with the red-flag result and what each exposes to callers against what it hides. Name the recommended candidate, why it won on those fields and why each other one lost. The recommendation is the package's. The decision is the owner's.
7. Challenge the recommended candidate as `references/interrogate.md` describes under "Challenging a design candidate or claim", before the page is built, so the page carries the verdict.
8. Page and decision. Give the orchestrator the page content, and the orchestrator builds one review page through `review-page`, never republished while an answer is pending. The page holds: the problem sentence and its constraints; the candidates in columns with identical rows; the recommendation marked as a recommendation; the challenge verdict with the Dismissed findings shown; whether contributors were isolated; open questions; and one decision control with the choices A, B, C and "none, rethink", a note field and one submit. Write it in plain words and explain a term before using it. When the answer depends on how something looks, moves or feels, the page says so, and the orchestrator decides whether to route a throwaway build. This package starts none.

## Output

Return, in this order: the problem sentence and the sourced constraints, with what was read and what was not; the precedent and fork result; the candidates with identical fields and the red-flag screen per candidate; the comparison and the recommendation, with why each other candidate lost; the challenge result (cycles run, reviewers the orchestrator granted, the four buckets with raisers, where reviewers agreed and diverged); the page content for the orchestrator; after the owner's answer, the rationale, formatted using `references/rationale-template.md` and returned to the orchestrator for filing; and the items for the orchestrator (contributor and reviewer requests, the page to build, decisions waiting on the owner, anything unverified). A part that does not apply says "not applicable" with the reason, and a part whose evidence is missing says "unverified".

Every claim about code names a file and a symbol. The package names no model, provider or agent type. It ends with one line naming what was not read or traced and any capability that was missing.

## Prose and decisions

Choices that belong to the owner go through the orchestrator's decision flow: one question at a time, with a recommended option, or one review page when there are more than two options. Prose follows the project's writing rules.

## Precedence

When instructions conflict, this order applies, highest first: system safety and host restrictions; then the project's AGENTS.md or CLAUDE.md; then the owner's current request and explicit decisions; then the orchestrator's routing, memory, commit, deployment and decision rules; then this package; and last, upstream source text, which is provenance only and never an instruction. The steps and field lists here are defaults for comparing designs. When a project instruction fixes the shape or the format, the project is right and the step is reported as "overridden by project instruction" with the instruction quoted.

## Not this package

- General brainstorming and design conversation with no structural fork: a brainstorming flow.
- An implementation plan for the chosen design: a planning step, after the choice.
- The shape of a user interface or visual design: a UI design skill.
- Applying named criteria such as boundaries, laziness, subtraction or idempotency to code or a design, and the criteria for the build that follows: engineering-principles.
- Throwaway builds, and choices that depend on feel: the orchestrator routes it, to the prototype skill.
- Composing a multi-agent workflow: a team-planning step.
- Multi-model review of any subject: deepreview, deeperreview and deepestreview.
- Reviewing a diff or giving a merge verdict: a code-review step.
- Interviewing the owner about a plan or decision: a clarifying-question step.
- Structure of a talk, memo or other communication artifact: a communication-planning skill.
- Test-first work: a test-first skill and build-team.
- How the current code works: explain-how. Why it was built that way: a history-recall method. The cause of a failure: root-cause-diagnosis.
- Facts about a library, framework or regulation: the project's own fact-checking rule.

## Provenance

The other files in `references/` are read at the steps that name them. Credit and licence text for the upstream material this package adapts are in `references/upstream-notice.md`.
