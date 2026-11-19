# Quality-bar guard

## Rule

A change can turn a check green by lowering the bar instead of meeting it. When reviewing a diff, look for the five moves that make a check pass without the code getting better: a threshold moved, a test made easier, a checker silenced, work left unfinished, and a new waiver. Tightening a bar can be silent. Loosening one must be loud: it needs a stated reason and the owner's agreement, and a diff that loosens a bar without either is reported as a finding.

The guard is a reading of the diff. It sets no numbers for the project, installs nothing, adds no hook or pipeline job, edits no threshold and writes no constraints file. A check the project lacks is reported to the orchestrator as a gap to file in the task tracker.

## Why

An agent that meets a red check takes the cheapest road to green. That road is rarely a clever exploit. It is usually a skipped test, a comment that turns a warning off, or a number edited down by a few points, and each one looks harmless in a long diff. The person who wrote the code used to know from reading it whether it was good. When far more is written than anyone reads, that judgment has to move into checks, and the checks only help if nobody quietly weakens them.

## Checks

For each check, cite the file and line of the hit, with the before and after text where a value changed. "No hits" is valid only if the whole diff was read; if part of it was not, say which part and report the check as unverified.

1. Threshold moved: does the diff lower a budget, drop a severity, raise an allowed count, relax a required percentage or remove a check from the stage where it ran? Compare the project's configuration and check definitions against the base of the diff, and quote the old and new values.
2. Test made easier: does the diff add a skip or disable marker to a test, delete a test file, or remove assertions from a test that stays? A test deleted together with the code it covered, and explained in the commit, is not a hit. Name the test and the commit text that explains the removal.
3. Checker silenced: does the diff add a comment or marker that turns a check off for new code: ignoring a type error, disabling a lint rule, excluding lines from coverage, disabling mutation testing, or allowing a finding from a security or secret scanner? Markers that exclude code from coverage or that allow a security or secret finding deserve extra attention, because they switch off something the project relies on for confidence.
4. Work unfinished: does new code contain a stub that throws a not-implemented error, an empty error handler that turns a failure into silence, or a placeholder note standing where the implementation should be? Quote the line. This check reviews a diff and never rewrites it.
5. New waiver: does the diff add an entry to the project's list of waived rules, wherever it keeps one, that nobody discussed? Each waiver needs a reason, an owner and an end date. Quote the entry and name what is missing.
6. Reason and owner: for each hit from checks 1 to 5, is there a stated reason in the commit message, the task or the review thread, and an owner who agreed? A stated and agreed loosening is reported as "lowered, with reason" for the owner to confirm. An unexplained loosening is a finding. A loosening in the same commit as the feature whose failing check it silences is the pattern this guard exists to catch.
7. Outside opinion: of the checks that gate this change, is at least one judged by something other than the test suite written by the same author, such as a published standard, a database of known issues or a measurement in a real browser or runtime? A project-owned rule file maintained by a human counts as a middle case. If every gating check is the author's own suite, report it as a gap for the orchestrator to file in the task tracker. Do not add a tool.

## Example

A diff makes a flaky export test pass. It adds a skip marker to that test (check 2), lowers the coverage requirement in the project's test configuration from 80 to 70 percent (check 1), and adds a lint-disable comment above a new function (check 3). That function's body is a single throw of a not-implemented error (check 4). The commit message reads "get CI green" and gives no reason for any of the four changes (check 6), so each one is a finding with its file and line.

In the same diff, a test file for a removed legacy report is deleted. The commit message says the report was retired in this change and the tests went with it. That is not a hit under check 2, and the review says why. Check 7 notes that the only gate is the project's own test suite, and reports a gap.

## When it does not apply

- Tests and checks removed together with the behavior they covered, with the reason given.
- A change that raises a bar or adds a check. Say so and move on.
- A waiver that already has a reason, an owner and an end date, recorded before the change. Cite it.
- Throwaway spikes that the owner has marked as such. Mark the checks not applicable and say that the owner's marking is the reason.
- Deciding what the project's bar should be, or choosing thresholds. That is the owner's call, and this file only checks that the bar held.
- Generated or vendored code. Review the generator or its input.
- Judging whether a completion claim is true. Your verification step owns that; this guard reviews a diff for a lowered bar and gates no claim.
