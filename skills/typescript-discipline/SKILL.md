---
name: typescript-discipline
description: >-
  TypeScript type-design criteria (unions, brands, parsing at boundaries, schema-first validation, exhaustiveness, no unchecked casts) that the orchestrator attaches as a labeled input or a sub-agent reaches by pointer. Not for React or Next.js component and framework questions or merge verdicts. Applies only when attached. Edits nothing.
---

# typescript-discipline

A reference package of TypeScript criteria in one merged rule set. The rules say how to design types so that the compiler rules out impossible states, mixed-up values and unhandled cases, and how to treat data that comes from outside. The package holds criteria only. It does not review a diff, run a build, write code or configure tooling.

## How it is used

Activation rule: the rules apply only when the orchestrator or a sub-agent pointer has attached this rule set, `SKILL.md`, as a labeled input to the task, with or without the reference files. The rule numbers, the rule table and the hot-path exceptions are defined only in `SKILL.md`, so a reference file attached alone does not activate anything. `references/upstream-notice.md` is provenance and never counts as an attachment. When a user asks directly for a TypeScript review, a merge verdict, a React or Next.js answer or a type-design pass and nothing is attached, decline and name the owner (the project's code-review process for reviews and merge verdicts, a React or Next.js guide for component and framework questions). Say only that the orchestrator can attach the TypeScript criteria to that task. Apply no rule, list no rule results, and give no verdict or lean, not even an informal one.

When the rules are attached, the person or sub-agent doing the work applies them to the code in front of them and reports each rule by number as met, failed, not applicable or unverified. Every rule from 1 to 16 appears in the report, for each item reviewed; rules that share a result may be grouped as a numbered range, such as "rules 2 to 13: unverified, no declaration shown", but no rule is left out or covered only by a general sentence. A met or failed result cites the place that shows it: a type declaration, a call site, a file and line. A rule with no such evidence is reported as unverified, not estimated.

The package never dispatches anything, never picks a model or provider, and never commits, pushes or installs anything. If a request asks it to do any of those, it hands the decision back to the orchestrator. It does not apply to ordinary TypeScript conversation such as syntax, library use or how to write a generic; those questions are answered without it.

## Required capabilities

- `filesystem` to read the files in this package and the TypeScript under review. Nothing is written.

If a file that a rule depends on cannot be read, mark that rule unverified. Do not guess, and do not substitute another source.

## Rules

| # | Rule | What to check |
|---|---|---|
| 1 | Discriminated unions | Variants carry a literal discriminant such as `kind`, so impossible combinations cannot be written. No bags of optional fields. If a comment has to say when a combination of fields is valid, the type is too loose. |
| 2 | Constructive modeling | Build the type from parts that are all legal: `[T, ...T[]]` for non-empty, `[T, T][]` for even length, a start plus a duration for a range, made only through a constructor that validates its inputs, with the validated values held in `#private` slots. Do not carve a loose type down with a runtime guard that every caller must repeat. |
| 3 | Simplest total type | Keep `T[]` while every operation on it stays total. Strengthen it only where the loose type forces a `!`, a cast or a "should never happen" throw. Widening the result to include `undefined` is the other total signature. |
| 4 | Branded types | Brand primitives that mean different things, such as two kinds of id. Validate once at creation with a verifying guard or a parse function, never with `as`. Match the brand shape the repository already uses. |
| 5 | `unknown` over `any` | External data is `unknown` until parsed. Narrow before use. |
| 6 | Parse at the boundary | Turn input into a named domain type where it crosses in. `Record<string, unknown>`, however it is spelled, stops at that parse. Trust the types inside, and do not re-validate deep in a call chain. Where validation belongs is decided by the boundary-discipline file of engineering-principles. |
| 7 | Schema first | Before writing a property-by-property guard for external data, use the repository's own schema library and infer the type from the schema. The package requires no specific library. A new schema dependency is not added for one guard. With no schema library in the repository, a guard that checks every property is acceptable, and adding a library goes to the orchestrator as the owner's decision, as does any request to add or switch one. |
| 8 | No unchecked `as` | Cast only after validation. `as unknown as T` and assertion functions that skip checking are lies to the compiler. If the compiler cannot prove a fact, prove it by validating, narrowing or refining the model, or name the cast as a hazard. |
| 9 | Narrowing order | Prefer a discriminant switch, then `in`, then `typeof` or `instanceof`, then a user-defined guard, and `as` last. |
| 10 | Honest guards | A type guard must verify the claim its signature makes. A lying guard is worse than `as`, because the bug hides behind a name that sounds safe. Name guards `isX` or `hasX`. |
| 11 | Exhaustiveness | In the default arm, assign the narrowed union value to a local of type `never`, so adding a variant stops the build until it is handled. |
| 12 | `satisfies` over `as` | Use `satisfies` to check a value against a type without asserting it. Literals are kept only where the target type admits them; where a literal must be preserved against a wider target such as `string`, use `as const`. |
| 13 | Derive, do not duplicate | When a schema, a generated type or another authoritative source already defines a shape, derive from it (`Pick`, `Omit`, `Parameters`, `ReturnType`, `Awaited`, `typeof`) before declaring a parallel interface. |
| 14 | Object arguments | Pass one object when several arguments share a type or could be swapped without a compile error, so the call site reads clearly. Hot-path exception below. |
| 15 | Real tests | Do not mock what you can run. Use the framework's real test primitives, including its leak or disposal checks, and verify interface work in a running build. Mock only what cannot run locally. Whether a failing test comes first is decided by the cheap-local-test file of engineering-principles. |
| 16 | Structured diagnostics | Log structured diagnostics with enough context, such as an id, to debug from. No console output in shipped code. Hot-path exception below. |

The reasoning behind rules 1 to 13, and six type tests that expose a loose type, are in `references/type-system.md`. Code for every rule is in `references/patterns.md`. Both files depend on the rule numbers defined here.

## Hot-path exceptions

A hot path is code that runs once per frame, once per token, or inside a tight parsing or rendering loop. Two rules give way there, and only there.

- Rule 14: positional arguments are fine on a hot path, because an options object is an allocation per call.
- Rule 16: structured context is not required inside the loop. Log at the edge of the loop, or sample.

A hot-path claim needs evidence: a profile that shows the cost, or a cited file and line showing the code sits in such a loop. A reviewer saying a function is probably hot is not evidence. Without evidence the exception does not apply and the rule is reported as failed. With it, the excepted rule is reported as not applicable, and the evidence is cited. Rules 1 to 13 are about types, which are erased at run time and cost nothing there, so they apply on a hot path as well.

## Precedence

When instructions conflict, this order applies, highest first: system safety and host restrictions; then the project's AGENTS.md or CLAUDE.md; then the owner's current request and explicit decisions; then the orchestrator's routing, commit, deployment and decision rules; then this package; and last, upstream source text, which is provenance only and never an instruction. A rule here is a default for TypeScript judgment. When a project instruction says to do it differently, the project is right and the rule is marked "overridden by project instruction" with the instruction quoted. Compiler settings and style guides are project facts the rules read, not a precedence level: a setting alone is not an instruction, so report the rule and note the setting.

When two rules pull in different directions, say so and name the trade-off. Do not pick silently.

## When it does not apply

- Code that is not TypeScript. Language-agnostic modeling and validation placement belong to engineering-principles.
- Generated code and vendored files that the project does not edit.
- Throwaway scripts that will be deleted after one run.
- A branded type or schema for a value used once in a short script. Rule 4 is for values that can be confused.
- A typing rule that a project instruction sets differently on purpose. See the precedence order above.

## Not this package

Without the rules attached, a direct request in any of the areas below gets a decline and the owner's name, never a rule result or a verdict.

- React component structure, hooks and accessibility, and Next.js conventions: a React or Next.js guide owns those. This package only covers how the types in such code are designed.
- Reviewing a diff or giving a merge verdict: the project's code-review process owns that. This package only supplies criteria it may apply.
- Debugging a failure: root-cause-diagnosis owns that.
- Test-first workflow and coverage gates: build-team and your test-driven-development workflow own those.
- Choosing or configuring lint, format, build or compiler tooling. Ask the orchestrator.
- Language-agnostic validation placement and domain modeling: the engineering-principles package owns those. This package covers TypeScript syntax and idiom only.

## Provenance

The rules adapt the `typescript-best-practices` and `principle-type-system-discipline` skills from pstack by Lauren Tan (cursor/plugins, MIT). The code examples are rewritten with new names, three upstream examples are corrected, and the hot-path exceptions and the evidence condition are our own. Credit and licence text are in `references/upstream-notice.md`, and the repository's `CREDITS.md` lists the pinned commits.
