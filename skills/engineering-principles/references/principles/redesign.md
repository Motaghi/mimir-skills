# Redesign from first principles

## Rule

When a new requirement lands in an existing design, work out what you would build if the requirement had been part of the design from the start, and compare that with the current shape. Redesign only after evidence that adding onto the current shape would preserve the wrong model. Without that evidence, make the smaller addition. With it, think through the whole redesign, carry it into every place that refers to the old shape, and deliver it in steps.

## Why

A requirement bolted onto a design that was built for other assumptions leaves a special case at every join: a flag that is meaningful in two of three states, the same branch repeated in several files, a comment that explains which field combinations are allowed. Each patch is small. Together they bury the model the code now needs, and the next requirement has to work around all of them.

Redesigning for every change is the opposite mistake. Most requirements fit the existing model, and reshaping a sound design costs review time and risks regressions for nothing. That is why the rule asks for evidence first. Thinking the full redesign through before delivering any of it keeps the option to stop after any step with the design still coherent.

## Checks

For each check, cite the files, types, branches or stored data that show the answer. A check with no citation is reported as unverified.

1. Reading: were all the affected files read before judging? List them: the files that define, store, branch on or document the shape the requirement touches. An unread file leaves checks 2 to 4 unverified for that part.
2. From scratch: is there a short statement of what you would build if the requirement had been a founding assumption, and does it say what differs from the current shape in the model itself (the entities, the states, who owns what), not only in names or file layout? No means unverified.
3. Wrong-model evidence: is there evidence that adding onto the current shape would preserve the wrong model? Typical evidence: a combination of fields that the code treats as valid and the new requirement makes contradictory or meaningless; the same branch on the same fields in several places, each of which the addition must extend; a new case the current model can only express as an exception; a comment or convention that exists only to say when fields may be combined. Cite what you found. If you found none, answer no, say the smaller addition is enough, and mark checks 4 to 6 not applicable.
4. Propagation: does the redesign reach every reference to the old shape, including types, stored data, docs, examples, tests and the text that explains why? Say where you searched. A place not searched is unverified. A half-carried redesign is worse than either end, because two models then live side by side.
5. Delivery: is the whole redesign thought through first and then delivered in steps, with each step stating what works after it? Where a step cannot leave the system working, apply outcome-execution.md. Where callers of a replaced interface remain, apply migrate-callers.md.
6. Outside contracts: does the redesign change a published interface, a client-facing output, regulated behavior or a data format that others read? If yes, mark the removal or change for that part not applicable, cite the source, and hand the decision to the orchestrator and the owner. The redesign can continue behind the unchanged surface.

When this pulls against laziness.md, which prefers the smallest change, say so and name the trade-off. The redesign is the larger change, and only check 3 justifies it.

## Example

A notifications module stores `sent: boolean` and `failed: boolean`. The new requirement is "snooze until a time". The nightly job, the inbox view and the export each branch on both flags, and 37 stored rows have both flags set with no known meaning. Adding `snoozed_until` would add a third combination to each of the three branches. Check 3 is yes: the combination evidence is in the stored rows and the repeated branches. From scratch, the record would carry one state with explicit variants (waiting, snoozed until a time, sent, failed), so the redesign replaces the two flags, updates the three branches, the stored rows, the docs and the tests (check 4), and ships in steps.

A team wants a "preferred language" field on a user profile. The profile is a flat record of eleven independent optional fields, each read in one place, and every earlier field was added the same way. Check 3 is no: nothing in the current shape is wrong for this requirement. Add the field.

## When it does not apply

- Check 3 finds no evidence. The addition is the right change.
- Emergency fixes, where the smallest safe change comes first and any redesign waits.
- Throwaway scripts and code already scheduled for deletion.
- A project instruction that fixes the shape. Those win.
- New work with no existing design to compare against.
- Visual or interface design. This file covers code and system design only.
