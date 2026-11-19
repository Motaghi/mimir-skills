# Subtract before you add

## Rule

When evolving a system, remove complexity first, then build on the simpler base. Treat simplification as a continuing investment: leave the design a little simpler and more capable, behind the same or a smaller surface, than you found it. Subtraction does not apply to behavior that is regulated, promised to a client or relied on publicly. See the exceptions below.

## Why

Building on dead code, redundant checks and stub files means every new piece has to work around things nobody needs. Cutting first keeps the base small enough to understand, and the new work lands on something that fits.

## Checks

For each check, cite the usage evidence (callers, logs, tests, the spec) behind the answer. A check with no citation is reported as unverified.

1. Exceptions first: does the thing you are about to remove fall under one of the exceptions below? Yes means mark the removal checks "not applicable" for it, using that label. Cite the source (the regulation or control, the contract clause, or the published interface and its known consumers), and hand the decision to the orchestrator and the owner. Apply this check before checks 2 to 7.
2. Order: is removal sequenced before construction? Name the dead code, redundant validators and stub references that go first.
3. Minimum first: is the minimum working version reached before effort goes into polish?
4. Observed usage: is the design based on how the system is actually used, shown by callers or logs, rather than on speculative edge cases?
5. Speculative guards: are there validators, parsers or guards beyond what the spec demands? Cite the spec line that demands each one. Without one, it is a candidate for removal. A feature outside the spec also drags guards in behind it (storage, retry on startup or migration code each need checks on their inputs), so removing the feature removes those guards too.
6. Redundant instructions: where the system includes prompts, templates or instruction text, are there repeated instructions or heavy templates that can be cut without changing results?
7. Empty references: does a reference or stub file hold nothing that is not stated elsewhere? Delete it instead of leaving a stub.

## Exceptions

Do not subtract, and do not recommend subtracting, any of these without the owner's decision:

- Regulated or compliance-bound behavior, such as audit logs, retention, consent records, access checks and evidence a control depends on. A check or record that looks unused may be what a regulation or audit requires.
- Client-facing contracts, such as agreed outputs, formats, service levels or reports promised in an engagement.
- Public compatibility, such as published interfaces, documented fields, file formats and URLs that outside parties may still use. Absence of callers in the repository does not show absence of consumers.

## Example

A cleanup touches a service. Checks 2 and 4 find an export function with no callers in the repository or the last year of logs, and a validator for a field the spec never mentions (check 5). Exception check 1 finds that neither is a published interface, neither has an outside consumer, and neither is tied to a regulation or a contract. Only then do both go first, with the evidence quoted. Observed non-use alone would not have approved the removal.

The same pass also finds a write to an audit table on every settings change, and a response field that the code never reads. The audit write is bound by a compliance control, so check 1 applies: the removal checks are marked "not applicable", the control is cited, and the decision goes to the orchestrator and the owner. Meanwhile it stays. The response field is part of a published interface with outside consumers, so check 1 applies to it too: the removal checks are marked "not applicable", the consumers are cited, and the decision goes to the orchestrator and the owner. It stays until a deprecation is agreed.

## When it does not apply

- Anything under the three exceptions above.
- Visual or interface design simplification. This file covers code and system design only.
- Work where the only evidence of non-use is a guess. Keep it, and mark the check unverified.
- Emergency fixes, where the smallest safe change comes first and the cleanup waits.
- Subtraction would break an agreed deprecation schedule. Follow the schedule.
- For validation at system boundaries, boundary-discipline.md decides what to keep.
