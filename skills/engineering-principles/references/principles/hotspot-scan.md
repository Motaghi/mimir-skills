# Hotspot scan

## Rule

When someone asks where architectural effort should go and names no module, subsystem or pain point, read the project's commit history first and let the places that keep changing pull attention before anything else. Deepening a module pays off by making future changes to it cheaper, so recent and repeated change is the best cheap evidence of where that payoff is. The scan is a one-time read of history on request. It produces a short ranked list of places to look, each with its evidence, and it proposes no new interfaces.

## Why

Without a direction, a search of the whole codebase turns up friction everywhere, and most of it sits in code nobody touches. Effort spent there buys nothing. History is already written down, costs one read, and shows which areas people keep returning to. A file edited in forty commits and a file untouched for two years do not deserve equal attention, even if the second one is uglier.

## Checks

For each check, cite the commits, the counts or the subjects behind the answer. A check with no citation is reported as unverified. The scan runs only because it was asked for in this task, and only once for that request.

1. Direction: did the requester name a module, subsystem or pain point? Yes means take that direction, mark checks 2 to 5 not applicable using that label, and skip the history scan; checks 6 and 7 still apply to the named direction. No means go on.
2. Window: is the part of history that was read stated, as a range and a commit count? Walk back a good stretch, such as the commits since the last release or the last few months of work. A scan that does not say what it read cannot be checked.
3. Recurrence: which files or directories come up again and again across those commits? Name each with the number of commits that touch it. Set aside churn that carries no signal about design: generated files, lock files, version bumps, vendored code and repository-wide formatting sweeps. Say what was set aside.
4. Why it changes: does the history say why each hotspot keeps changing? Cite commit subjects. Repeated fixes in one area, a rename that keeps coming back, and steady feature growth point to different causes, and only the first two suggest a shallow module. Steady growth in a feature area is not by itself a problem.
5. No clear hotspot: if the changes are scattered and no area stands out, say so and widen the window once, stating the new range. Do not name a hotspot the counts do not support.
6. Recorded decisions: does a decision record already cover a hotspot's area? Cite it. Looking into the area in a way that keeps the decision intact needs no justification. Work that would contradict the record is surfaced only when the friction is real enough to justify reopening it, and the entry says plainly that it contradicts that record and why. Do not list refactors a record already rules out.
7. Hand-off: is the output a short ranked list of places to look, with the evidence for each, and nothing more? It names no new interface and writes no file. Judging whether a hotspot is shallow is done afterwards with deep-modules.md, and term questions go to domain-language.md. If a visual comparison is wanted, the orchestrator builds a decision page.

## Example

A requester asks where to spend a week of cleanup in the billing service and names nothing. Check 1 finds no direction. Check 2 records the last 300 commits, about four months. Check 3 finds `invoice/rounding.py` in 38 commits, `invoice/templates/` in 31, and `db/migrations/` in 44; it sets the migrations aside as expected churn and says so. Check 4 reads the subjects: 14 of the rounding commits start with "fix", across 9 different bugs, while the templates commits are mostly new document types added one by one.

Check 6 finds a decision record that settled the rounding rule two years ago. Looking at the code that applies the rule keeps that decision intact, so the area stays on the list with no reopening justification; a proposal to change the rule itself would contradict the record and would need one. The result is two places to look: the rounding module first (repeated fixes), the templates directory second (steady growth, weaker signal), each with its counts. No refactor is proposed.

## When it does not apply

- The requester named a direction. Take it and skip the scan.
- The history is too short to show recurrence, such as a young repository or a squashed import. Report the checks as unverified instead of ranking noise.
- Squash merges that collapse many files into one commit hide how often an area changed. Say so and lower the weight of the counts.
- A recurring or scheduled survey. This file never sets one up; a standing review is the orchestrator's call, not part of the scan.
- Deciding what to do about a hotspot, or designing the interface that replaces it. Use deep-modules.md and redesign.md for that.
- Generated or vendored code. Scan the generator or its input instead.
