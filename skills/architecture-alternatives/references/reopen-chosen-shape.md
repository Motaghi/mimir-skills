# Reopening a chosen shape

This file is read together with `SKILL.md` when work against a chosen shape keeps hitting friction the shape cannot absorb. The orchestrator may reopen the package for it.

## The signal

The signal is a pattern, not one instance:

- the same kind of workaround repeating across unrelated code;
- several unrelated edge cases each needing a special-case branch;
- types that need escape hatches to compile;
- a lock added to state the shape said was not shared;
- callers who must know the abstraction's internal rules;
- two or more independent deviations from the sketch with the same shape.

A few edge cases do not condemn a design, and complexity in the data is not complexity in the design.

## What to do

Treat the friction as new grounding. Read what has been built (method step 2), redesign as if the new constraint had been a day-one assumption, then write the candidates again (step 4) with a candidate smaller than the old one. The orchestrator attaches the redesign and subtract criteria from engineering-principles, and root-cause-diagnosis for a defect whose cause is unclear. The gates in `SKILL.md` still apply.
