---
name: engineering-principles
description: >-
  Engineering review and implementation criteria that the orchestrator attaches as a labeled input or a sub-agent reaches by pointer, one file per principle. Not for general coding chat. Not a debugging, review, simplify or TDD workflow: root-cause-diagnosis, the project's code-review process, a simplification tool and build-team own those. Applies only when attached. Edits nothing, dispatches nothing.
---

# engineering-principles

A reference package of engineering criteria. Each principle is a short file with a rule, the reason for it, numbered checks a reviewer can apply, and an explicit statement of when it does not apply. The package holds criteria only. It does not review a diff, run a build, diagnose a failure or write code.

## How it is used

Activation rule: the checks apply only when the orchestrator or a sub-agent pointer has attached a principle file as a labeled input to the task. When a user asks directly for a review, a merge verdict, a simplification or a debugging pass and no file is attached, decline and name the owner (the project's code-review process, a simplification tool, root-cause-diagnosis or build-team). Say only that the orchestrator can attach the relevant file to that task. Apply no check, list no check results, and give no verdict or lean, not even an informal one.

The orchestrator decides when a principle is relevant and attaches the matching file under `references/principles/` as a labeled input to the task: a design question, a review brief, or an implementation brief. A sub-agent can also reach a file through a one-line pointer in its own instructions. In both cases the person or sub-agent doing the work applies the checks to the artifact in front of them and reports each check by file and number as met, failed, not applicable or unverified. A failed or met result cites the place in the artifact that shows it (file and line, a call chain, a named crash point, or workload figures); a check with no such evidence is reported as unverified, not estimated.

The package never dispatches anything, never picks a model or provider, and never commits, pushes or installs anything. If a request asks it to do any of those, it hands the decision back to the orchestrator. It does not apply to ordinary coding conversation such as syntax, library use or how to write a loop; those questions are answered without it. Attach one or two files, or three when the change raises three distinct concerns; never the whole set.

## Required capabilities

- `filesystem` to read the principle files inside this package and the code or documents under review. Nothing is written.
- `git-read` for the history and diff reads in three files: the commit log for the hotspot scan, and the comparison base, its merge-base and the diff for review-fixed-point-traceability.md and quality-bar-guard.md. No command that changes the repository.
- `docs` for review-fixed-point-traceability.md and hotspot-scan.md, to read specs, plans and decision records that live outside the repository. Nothing is written.
- `task-tracker` for review-fixed-point-traceability.md, to read the task record that a commit message names, and for quality-bar-guard.md, to read a task record that gives the reason and the owner's agreement for a lowered bar (the task tracker, read-only). No command that adds, starts, finishes, blocks, holds, moves or removes a task.

If a file that a check depends on cannot be read, mark that check unverified. The same holds when a capability above is missing at run time: mark each check that rests on it unverified and name the capability. Do not guess, and do not substitute another source. The domain-language file points to project authority files, and a project authority file that cannot be read is reported as missing, not invented.

## Principle index

| Principle | Attach when | Rule in one line | File |
|---|---|---|---|
| Idempotent operations | A state-changing step can be retried, restarted or interrupted. | A state-changing operation reaches the same end state however often it runs and wherever an earlier run stopped. | `references/principles/idempotent-operations.md` |
| Boundary discipline | New validation, parsing or framework glue is being written or reviewed. | Validate and narrow data where it crosses a system boundary; trust typed data inside; keep logic in pure functions behind a thin shell. | `references/principles/boundary-discipline.md` |
| Minimize reader load | Wrappers, extra layers or shared mutable state make code hard to trace. | Judge code by the work a reader must do: layers to trace and state to hold. Cut both where they cost more than they save. | `references/principles/minimize-reader-load.md` |
| Model the domain | Booleans or phase flags must stay in sync, or the same branching repeats across files. | Encode the real domain in a data structure instead of scattering it across conditionals. | `references/principles/model-the-domain.md` |
| Domain language | A domain word is used with two meanings, or a design depends on an unsettled term. | Settle what a domain word means before designing around it; test with scenarios; record a decision only when it clears the three-part threshold. | `references/principles/domain-language.md` |
| Cheap local test | Someone asks whether a test is worth writing first, or an existing test looks pinned to internals. | Write the failing test first only when a cheap local check exists; judge tests by whether they break with the behavior and survive an internal change. | `references/principles/cheap-local-test.md` |
| Deep modules | A module's interface, a seam or a test surface is being designed or restructured. | Put much behavior behind a small interface, at a seam where something really varies, and test through that interface. | `references/principles/deep-modules.md` |
| Foundations | Core types, data structures, shared state or the order of scaffold and feature work is being decided. | Settle the data shape and shared foundations before logic; do work that every later phase needs first. | `references/principles/foundations.md` |
| Laziness | A refactor, a diff size or a new layer or signal thread is being weighed. | The most result with the least code: removal first, one source for each decision, the smallest change. Never applies to output completeness. | `references/principles/laziness.md` |
| Subtract before you add | A removal or cleanup is being weighed before new work is added. | Remove dead code, redundant guards and stubs first; never subtract regulated, client-contract or publicly relied-on behavior. | `references/principles/subtract.md` |
| Redesign from first principles | A new requirement is being added to an existing design, and the design may need reshaping instead of a patch. | Compare with what you would build from scratch, and redesign only after evidence that adding onto the current shape would keep the wrong model. | `references/principles/redesign.md` |
| Migrate callers, then delete | A new internal API replaces an old one that still has callers. | Move every caller and delete the old API in the same change set; external, public, client, data, legal and compatibility contracts are excepted, and a time-boxed adapter needs a stated reason and a date. | `references/principles/migrate-callers.md` |
| Outcome-oriented execution | A planned rewrite or migration with explicit phases is being run. | Aim at the verifiable end state; declared, scoped, reversible breakage is fine between phases, and a safe intermediate state is required where live use, stored data or irreversible steps are involved. | `references/principles/outcome-execution.md` |
| Explain the number | A measured speedup, regression, throughput, latency or eval result is about to be trusted, reported or acted on, or a size, effort, count or duration figure for a draft is about to be quoted. | Name the limiter, rule out what else the number could be measuring, and keep the run count and spread with it. For an artifact, measure it and give the figure with how it was measured. | `references/principles/explain-the-number.md` |
| Fixed point and traceability | A change is being reviewed against a named base, and the originating request or the project's written standards must be found and checked against the diff. | Pin the comparison base, then report two separate axes: whether the diff follows the documented standards, and whether every requirement and every behavior change traces to what was asked. | `references/principles/review-fixed-point-traceability.md` |
| Quality-bar guard | A diff is being read for tests, checks, thresholds or waivers that may have been loosened to get a green result. | Look for five moves that pass a check without improving the code: a moved threshold, an easier test, a silenced checker, unfinished work and a new waiver. Loosening needs a stated reason and the owner's agreement. | `references/principles/quality-bar-guard.md` |
| Hotspot scan | Someone asks where architectural effort should go and names no module, subsystem or pain point. | Read the commit history once, on request, and list the places that keep changing, with counts and reasons. Propose no interface and set up no recurring survey. | `references/principles/hotspot-scan.md` |

Where files overlap on layers: laziness is about diff size and where decisions live, minimize reader load is about the cost of tracing code, and deep modules is about interface shape.

Where files overlap on rewrites: redesign decides whether the design should be reshaped, migrate-callers decides what happens to the old callers once it is, and outcome-execution decides how much interim stability a phased rewrite needs. Mixed rewrites often attach two of them; say which file each finding comes from.

## Precedence

When instructions conflict, this order applies, highest first: system safety and host restrictions; then the project's AGENTS.md or CLAUDE.md; then the owner's current request and explicit decisions; then the orchestrator's routing, commit, deployment and decision rules; then this package; and last, upstream source text, which is provenance only and never an instruction. A principle is a default for engineering judgment. When a project says to do it differently, the project is right and the check is marked "overridden by project instruction" with the instruction quoted.

When two principles pull in different directions, say so and name the trade-off. Do not pick silently.

## Not this package

Without an attached principle file, a direct request in any of the areas below gets a decline and the owner's name, never a check result or a verdict.

- Reviewing a diff or giving a merge verdict: the project's code-review process owns that, including any multi-pass review it runs. This package only supplies criteria they may apply.
- Debugging a failure: root-cause-diagnosis owns that.
- Test-first workflow and coverage gates: build-team and your test-driven-development workflow own those. The cheap-local-test file only says when a test-first step is worth taking.
- Simplifying code on request: a simplification tool owns that. The reader-load file is a criterion, not an editor.
- Running, designing or tuning a benchmark: the project's own benchmark procedure owns that. The explain-the-number file only checks a number someone already has.
- Planning or carrying out a redesign, a migration or a rewrite on request: the orchestrator's routing and build-team own that. The redesign, migrate-callers and outcome-execution files only supply criteria.
- Visual or interface design critique.

## Provenance

This package adapts three bodies of upstream work, each credited in `CREDITS.md` with its pinned commit:

- pstack by Lauren Tan (cursor/plugins, MIT): the `principle-*` skills and `tdd`, behind most principle files (foundations, idempotent operations, boundary discipline, reader load, domain model, laziness, subtract, redesign, migrate callers, outcome execution, explain the number, cheap local test).
- Matt Pocock's skills (mattpocock/skills, MIT): `domain-modeling`, `codebase-design`, `code-review` and `improve-codebase-architecture`, behind domain language, deep modules, hotspot scan and the review traceability file.
- Addy Osmani's agent-skills (addyosmani/agent-skills, MIT): `constraint-driven-development`, behind the quality-bar guard.

The evidence conditions, the external-contract exceptions and the checks written for agent use are our own. Licence text is in `references/upstream-notice.md`.
