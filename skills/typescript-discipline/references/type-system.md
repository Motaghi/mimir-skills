# Type system discipline

This file explains the rules in `SKILL.md` and is read together with it. Rule numbers refer to the table there. It is not a rule set on its own.

## Rule

Treat the type checker as a proof tool. Use it to rule out impossible states, mixed-up primitives and unhandled variants at compile time, so that a case the types let you ignore does not turn into a failure at run time. Where a special case can be designed out of existence, prefer that to adding another handler. The tools for it are types that cannot hold an illegal state, total functions, and a redesigned interface.

## Why

A bug that the compiler could have caught is a bug someone finds in production. Loose types also push the burden onto every reader, who must remember which field combinations are real. The goal is not the most precise type possible. It is a type that tracks the cases each use site has to handle, no more and no less.

## The reasoning behind rules 1 to 13

- Illegal states (rules 1 to 3). Model variants as a union with a literal discriminant, not as a bag of optional fields where contradictory combinations compile. `{ completed: boolean; completedAt?: Date }` allows `completed: true` with no date, which means nothing. Either derive the boolean from the single source (`completedAt !== null`) or write the variants out: `{ kind: "open" } | { kind: "done"; at: Date }`. If a bug makes someone ask "can this combination actually happen?", the type is too loose.
- Types are constructions. Build the type up from the values you want instead of carving them out of a looser type with checks. A non-empty list is a head plus a rest, not a list plus a length check. A valid time range is a start plus a duration that only a validating constructor can create, with the validated fields held in `#private` slots, not two timestamps that must stay ordered. No representation is privileged, so pick the one that cannot build the illegal value and put the interface callers need on top of it.
- Strengthen only where partiality appears (rule 3). A runtime assertion, a null check or a "this should never happen" throw marks a place where a type is too weak. Move that check into the type, then stop. Prefer total functions: the sum of an empty list is 0, so `sum` takes a plain array, while the first element of an empty list has no answer, so `first` either demands a non-empty array or returns `undefined`. Extra precision costs reuse and ceremony and buys no safety where nothing would otherwise fail.
- Brands (rule 4). Two ids are both strings underneath and should not be interchangeable. Brand each one, validate once where it is created, and trust the type from then on.
- Outside data (rules 5 to 7). Request bodies, parsed JSON, messages between processes, command-line arguments, configuration files, environment variables and database rows have no type until something parses them. Put one parse step at every boundary that turns the input into the typed model. Let the repository's schema library own both the check and the type, so a hand-written guard, a duplicate interface and a schema cannot drift apart.
- Honesty (rules 8 to 10). Casts and assertion functions that skip checking turn a compile error into a crash. If the compiler cannot prove a fact, prove it by validating, narrowing or changing the model. Otherwise accept the cast as a hazard and say so. When removing an `as`, find out why inference failed. The usual reasons: a missing discriminant (add one), an over-wide source type (narrow it), an untyped boundary (parse it), or a case that is genuinely inexpressible (use a brand or `satisfies`).
- Exhaustiveness (rule 11). When code matches on a union, the build must fail when a new variant is added without a branch. A `never`-typed local in the default arm does that.
- Derivation (rule 13). When a generated type, a schema or a migration already defines a shape, derive from it. A hand-copied duplicate drifts the first time the source changes.

## Type tests

Report these as type test 1 to 6, so they are not confused with the rule numbers in `SKILL.md`. For each test, cite the declaration, call site or file and line that shows the answer. A test with no citation is reported as unverified.

1. Can you write a comment that explains when a combination of fields is valid? If yes, the type is too loose. Split it into a union.
2. Do two arguments of the same function share a primitive type but mean different things? If yes, brand them.
3. Is every `any`, `as` or non-null assertion traced to the boundary where the data should have been validated? An untraced one is unverified. One that traces to an unvalidated boundary fails; validate there instead of at the use site.
4. If a new variant is added next month, will the compiler say where a branch is needed? If not, the match is not exhaustive.
5. Does this type duplicate a shape that another file or a schema owns? If yes, derive it.
6. Is this type being strengthened to keep an operation total, or only to be more precise? If nothing would otherwise fail, keep the plain type.

## Example

A client library models an upload as `{ done: boolean; url?: string; error?: string }`. One stored record has `done: true` and neither `url` nor `error`. Type test 1 is yes: the type allows a state that means nothing. The union `{ kind: "uploading" } | { kind: "done"; url: string } | { kind: "failed"; error: string }` makes that record impossible to write, and a switch with a `never` default (type test 4) makes a fourth variant a compile error.

A function `newest(sessions: Session[])` returns `sessions.at(0)!`. The `!` marks partiality (rule 3, type test 3). The call sites always pass at least one session, so the input becomes a non-empty tuple and the assertion disappears. Had the callers sometimes passed an empty list, the better fix would be returning `Session | undefined`.

A `sum(xs: number[])` that returns 0 for an empty list is already total. Type test 6 says leave it alone.

## When it does not apply

- Code outside TypeScript. This package covers TypeScript idiom only; language-agnostic modeling belongs to engineering-principles.
- A stricter type that would cost more than it prevents, for example a branded type for a value used once in a short script. Rule 4 is for values that can be confused, not for every primitive.
- Generated code and vendored files that the project does not edit.
- Throwaway scripts that will be deleted after one run.
- A project instruction that sets a different typing rule, for example a lower strictness level that the project has chosen on purpose. Those win.
