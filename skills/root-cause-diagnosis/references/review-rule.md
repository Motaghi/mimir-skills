# Root-cause review rule

This file is read together with `SKILL.md` when a fix is proposed or a cause is stated. It is a rule a reviewer applies to the diagnosis and to the proposed fix. It does not run anything.

## Rule

Fix the fault, not the place where it surfaced. The symptom is where a wrong state became visible. The root cause is the first place the system did something it should not have done, or failed to handle a state it should handle.

## Why

A fix at the symptom hides the evidence and leaves the fault free to surface somewhere else. Each one also makes the system harder to reason about, because the code now carries a workaround for a bug that nobody named.

## Checks

1. Reproduced first. A fix that was never checked against a red reproduction cannot be verified. Without one, mark the cause unverified.
2. Traced to a decision. Ask "why" at each step until the answer is a wrong decision in the code, and not a consequence of an earlier one. State where the chain stopped.
3. Read, not guessed. When the trace stalls, instrument and read the actual error and the actual state. A theory that no observation supports is not a cause.
4. Legitimate-state test. Ask whether the state that triggered the symptom is one the system is allowed to be in.
   - If the system may be in that state, the code that broke on it is the root cause, and handling the state there is the fix.
   - If the state should never exist, a check at the place it broke hides the bug. Find what produced the state.
   - Guards, retries, swallowed errors, clamped values and discarded state are the usual ways a bug gets hidden. A guard is a fix only when the state it handles is legitimate.
5. Persisted state on a restart. When something fails only after a restart, suspect persisted state first: configuration files, caches, lock files and serialized state. If clearing that state restores behaviour, it implicates the state but does not yet show where the fix belongs. Trace its producer, the contract it is meant to keep and its reader before choosing. Checking the state at the reader alone may hide a producer that writes bad records, which check 4 warns about.
6. The workaround test. A workaround that needs a paragraph of comment to justify it means the code is wrong. Fix the code, not the comment.
7. Pattern, not only instance. After the cause is fixed and stated, look for the same mistake elsewhere with the closing step in `variant-analysis.md`. Do not widen the fix to those places until that step has run and the orchestrator has routed the work.
8. A signal that would have shortened the dig. If the deciding fact took a deep search to find, name the cheap, always-on signal that would have shown it at first look: a log line, a counter, a status field, an alert. Report it as a proposal with what it would show and where. The orchestrator files it as a task or adds it to the incident record. This package writes neither, and builds and installs no hook, alert, scheduled job or check.

## When it does not apply

- The state is legitimate and the guard is the correct handling of it. Check 4 then says the guard is the fix.
- The fault is in a system outside the project's control, such as a third-party service. The root cause is then the project's failure to handle that fault, and that is where the fix belongs.
- Containment while the root cause is out of reach, for example during an outage. A temporary guard is allowed if it is labelled as temporary, has a stated removal condition, and a task for the root-cause fix exists before the guard goes in. This exception is a judgment call added here and is not upstream wording.
- Throwaway code that will be deleted after one run.
