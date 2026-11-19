# Domain language

## Rule

When a design or review depends on what a domain word means, settle the word before designing around it. Challenge terms that conflict, pick one canonical word per concept, stress-test the meaning with concrete scenarios, and record a decision only when it clears the three-part threshold below.

This is the active discipline, for the moment the model is changing. Reading existing vocabulary while doing other work is a one-line habit and does not need this file.

## Term authority: no new files

The orchestrator never creates a term file under this principle. The upstream material this file was adapted from kept its vocabulary in a context file and a context map, and later renamed them to a glossary file and a glossary map. The orchestrator creates none of the four: `CONTEXT.md`, `CONTEXT-MAP.md`, `GLOSSARY.md`, `GLOSSARY-MAP.md`. It also creates no replacement under another name. A second file that defines the same words as the project's real authority becomes a competing authority within a month.

Term authority is whatever the project already has: its project instructions, a definitions section in its existing documentation, a note the project names as its authority (attached by the orchestrator if it lives outside the project), or its existing decision records. If a file with one of the four names above already exists in the project, it is that project's own file. Read it and respect it, and leave its format alone.

When no authority exists, say so. Put the settled terms in the reply as a short proposed list and let the orchestrator decide whether an existing authority file should absorb them, with the owner's go-ahead where that is required. Do not write the list into a new file on your own.

## Why

Most design arguments are two people using one word for two things. A structure built on an unsettled word encodes the disagreement, and the disagreement then shows up as branches and special cases (see model-the-domain.md).

## Checks

1. Conflict: does the word in use clash with a definition in the existing authority? Quote both meanings and ask which one is meant. For example: "The project defines 'cancellation' as X, but you seem to mean Y." Pass: every clash is named and resolved, or listed as open.
2. Overloaded or vague words: when one word covers two concepts, propose one canonical term for each concept and list the old word as a word to avoid. For example, Customer for the buyer and User for the login, with "account" listed as a word to avoid for both. Where several words exist for one concept, pick the best and name the rest as words to avoid. Pass: every contested word has one canonical term per concept and an avoid list.
3. Scenario test: write two or three concrete scenarios that probe the edges, such as a partial cancellation, a customer who belongs to two organizations, or a retry after a refund. Ask what the term does in each. If two people give different answers, the term is not settled. In a solo review, write the two readings yourself and mark the term unsettled when both fit the scenario.

## The decision-record threshold

Offer to record a decision only when all three are true:

- It is hard to reverse, so changing your mind later has a real cost.
- It is surprising without context, so a future reader will wonder why it was done this way.
- It is the result of a real trade-off, with genuine alternatives that were weighed.

If any one is missing, skip the record. An easy decision will simply be reversed, an unsurprising one raises no question, and a choice with no alternative needs no explanation beyond "we did the obvious thing".

Decisions that usually clear the bar: architectural shape, integration patterns between parts of a system, technology choices with lock-in (the ones that would take a long time to swap, not every library), boundary and scope decisions (the explicit "no" is worth as much as the "yes"), deliberate deviations from the obvious path, constraints that are invisible in the code, and rejected alternatives whose rejection is not obvious.

A record can be one short paragraph: what was decided, in what context, and why. It goes into the project's existing decision-record location. If the project has no such location, say so and leave the choice to the orchestrator; do not create one.

## Example

A team says "the customer cancels the order". Check 3 asks what happens when the customer cancels one of three lines after the warehouse has picked another. One person says the order is cancelled, another says it is partly cancelled, and the billing code only knows whole-order cancellation. That is a real gap, found before any code was written.

The settled terms might be Cancellation (applies to a whole order) and Line removal (applies to one line, allowed until picking starts). The proposed list goes to the orchestrator. Whether the choice becomes a decision record depends on the threshold: if billing would need a costly rework to support line removal later, it is hard to reverse, surprising and a trade-off, so it qualifies.

## When it does not apply

- The terms are already settled and the work only uses them. Read the authority and move on.
- General programming vocabulary. It is not domain language.
- Throwaway work and spikes, where the cost of an unsettled word is a few minutes.
- Confidential material. The project's own rules on confidential material win.
