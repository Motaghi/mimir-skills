# Idempotent operations

## Rule

A state-changing operation should reach the same correct end state however many times it runs and wherever an earlier run stopped. Build each step from the state that exists now, not from what the previous run meant to do.

## Why

Commands, lifecycle steps and processing loops run where crashes, restarts and retries are normal. When leftovers from a half-finished run change what the next run does, every restart turns into a debugging session.

The working method is simple. Read the current state, compare it with the goal, and apply only the difference. A step written this way is safe to repeat, because a repeat finds nothing left to do.

Anything a run leaves behind (a lock, a temporary file, a half-written record, a claimed job) has to be recognizable as stale by the next run. The evidence for staleness must hold wherever the earlier run could have stopped, not only in the common case. A marker the next run cannot judge turns every crash into manual cleanup.

## Checks

The three rerun questions. Ask all three of every state-changing operation under review:

1. What happens if this runs twice in a row? The honest answer is usually "nothing changes the second time".
2. What happens if the previous run crashed at each possible point, between the first write and the last? Name each crash point by the step it follows in the code, and say what the next run finds there.
3. Does running it again converge on the same end state, whatever was left behind?

If any answer is "it depends on what state was left behind", the operation needs a reconciliation step. Then apply these narrower checks, each of which can be answered yes or no:

4. Startup: does the operation first look at existing state, clean up stale artifacts and adopt work that is still live, instead of assuming a clean start?
5. Cleanup: does it decide what is redundant by comparing content equivalence, not creation order?
6. Locks: does stale-lock detection check that the owning process is actually gone, not only that the lock file exists? (This check assumes the owner is a local process.)
7. Scheduling: can failed work be picked up again cleanly?
8. Input: is the input regenerated for each cycle, not carried over from the previous one?
9. Writes: is output written to a temporary path in the same location and moved into place in one step, so a reader never sees half a file?

## Example

A nightly export writes `report.csv` straight to its final path and skips today's run if a `report.csv` dated today already exists. If the process dies halfway, the truncated file carries today's date, and every rerun skips the export because the file is there. Question 3 fails: the end state depends on what the crash left behind.

The fix has two parts. Write to `report.csv.tmp` and rename it into place only when complete, and at startup delete any leftover `.tmp` file. Now question 2 has a good answer at every crash point: before the rename the dated file is absent, after the rename it is complete. The skip is safe because a dated file exists only when it was moved into place whole, and tomorrow's run proceeds because the date differs.

## When it does not apply

- One-off scripts that a person runs once, watches, and discards.
- Records that are meant to accumulate, such as an append-only log or an event stream, where one entry per attempt is the intended output.
- External effects that cannot be undone and cannot be detected from state, such as sending a message or charging a payment. State comparison alone does not help there. The check becomes narrower: is there a durable request key or record that makes a second attempt a no-op? If none can exist, state the residual risk plainly instead of claiming the operation is safe to repeat.
- Operations that are meant to differ per run, such as a counter increment or a timestamped snapshot, as long as the difference is the purpose and not an accident.
