# Exhaust the design space

This file is read together with `SKILL.md` when a design problem has no precedent and more than one viable answer. It is a rule applied to the way candidates are produced and compared. It dispatches nothing: where it needs contributors or a page, it asks the orchestrator.

## Rule

When the right answer is not obvious, produce two or three structurally different candidates, compare them side by side on the same criteria, and only then commit. Designing it twice is this rule by another name. A second flavor of the first shape does not count as a second candidate.

Candidates are bounded: never more than three unless the owner asks for more. By default a candidate is a written sketch, not a build. The comparison goes on one review page so the choice can be judged by eye when the answer depends on layout, flow or feel. The orchestrator builds the page and routes any contributor who drafts a candidate.

## Why

Building the wrong thing costs more than exploring three options. The first design that comes to mind is usually the one the current code makes easiest, and it sets the frame for everything after it. A second and third candidate show what the first one quietly assumes.

An open-ended panel of drafters has the opposite problem. Many drafts of the same shape add reading cost and no information, and the person choosing ends up judging volume. Bounding the set to two or three distinct shapes keeps the comparison readable. Putting it on one page keeps the owner's judgment on the thing that matters: how the candidates differ.

## Checks

For each check, cite the files, notes or page content that show the answer. A check with no citation is reported as unverified.

1. Precedent searched: did you look for an existing answer in the codebase before calling the problem novel? List where you searched (modules, tests, docs, earlier decision notes). If a precedent exists, follow it and mark checks 2 to 7 not applicable. An unsearched place leaves this check unverified.
2. More than one viable approach: is there a constraint that rules out all but one answer? Name each constraint you rely on and where it comes from. If a real constraint dictates a single approach, say so, mark checks 3 to 7 not applicable and do the one thing. A constraint you cannot cite is a preference.
3. Distinct shapes: do the candidates differ in the model itself, such as who owns the state, where the boundary sits, what the data looks like, or what runs when? Describe each in one sentence without using the others' names. If two candidates read the same after that, count them as one and produce another. Renaming, moving files or swapping a library inside one shape is not a second candidate.
4. Bounded and uniform: are there two or three candidates, and does each carry the same fields: the shape in a few lines, what it makes easy, what it makes hard, what it would change in the surrounding code (cite the files), and how costly it is to reverse? A candidate missing a field cannot be compared and counts as unverified.
5. Compared before commitment: were the candidates compared side by side on those fields before any one was chosen, with no implementation started for a favorite in the meantime? Where the answer depends on how something looks, moves or feels, or on a layout easier to see than to read, the comparison is on a review page with the candidates next to each other and one decision control. Say which page and what it shows.
6. Isolation, when contributors are used: if separate contributors draft candidates so the first does not anchor the rest, did each get the same brief and none of the other drafts? Ask the orchestrator to route them within its slot limits and with explicit ownership of what each writes. This file names no model, provider, reasoning level, speed or agent type; who drafts is the orchestrator's routing decision. A contributor that fails or times out is reported with a visible warning, not dropped.
7. Choice and reason: is the chosen candidate named with the reason it won on the comparison fields, and the reason the others lost? The recommendation is the skill's. The decision belongs to the owner. If an owner decision is pending, no state-changing probe or build starts until it is confirmed.

When a candidate needs a throwaway build to judge it (the question is whether it works, not what it is), hand that to the orchestrator as a separate request for the `prototype` package. Do not start it from here.

## Example

A scheduled job must remember which items it has already handled, and nothing in the codebase does this yet. Check 1: searched the other jobs' modules and their tests, no job keeps such memory. Check 2: no constraint forces one answer; the items are stored in a table the job can write to. Three candidates differ in who owns the memory:

- A: each item carries its own "handled" marker, so the item record owns it.
- B: the job stores one high-water timestamp, so the job owns it and items stay untouched.
- C: nothing is stored; an item counts as handled when its output already exists, so the output owns it.

A "handled" marker kept in a separate small table instead of on the item is still shape A, so it is not a fourth candidate. The comparison shows that A breaks when items are edited after handling, B breaks when items arrive out of order, and C breaks when output is deleted. The owner picks B and records the out-of-order risk. Nothing was built to reach that choice.

A second case: a team adds a "preferred language" field to a profile that already has eleven independent optional fields, each added the same way. Check 1 finds the precedent. Follow it, and stop.

## When it does not apply

- Mechanical implementation where the pattern is established.
- Bug fixes and refactors with a clear target state.
- Changes where constraints dictate a single viable approach (check 2).
- Choices that are cheap to reverse, where exploring costs more than being wrong. Take the smaller option and move on.
- Emergency fixes, where the smallest safe change comes first and any comparison waits.
- A project instruction that fixes the shape. Those win.
- Shaping a user interface or visual design. The skill that owns that work runs first. This file still applies to the comparison step if that work produces competing candidates.
- Ordinary design conversation with no structural fork. That belongs to the general brainstorming flow.
