# Cheap local test

## Rule

Write the failing test first only when a cheap, local way to check the behavior exists. When it does not, use the closest useful check and say why. This file decides whether a test-first step is worth taking. It does not describe how to run one. The method belongs to build-team and your test-driven-development workflow, and this file adds no workflow, gate or report format to either.

## Why

A test that fails before a fix and passes after it is strong evidence, and it is cheap when the code path already has a test harness. When the only available test needs broad setup, heavy mocking or production data, the effort goes into the scaffolding and the result proves little. A bad test costs more than no test: it mostly tests mocks, depends on timing or global state, or would be deleted right after it proves the fix.

## Checks

For each check, cite the test file, harness or command that shows the answer. A check with no such citation is reported as unverified.

The trigger is met only when check 3 is yes, check 4 is no, and either check 1 or check 2 is yes. Checks 3 and 4 are vetoes: a request for a test does not override either of them. If a veto applies, say which one, state why, and use the closest useful check. When the trigger is met, report that it is met, say which checks showed it, and name build-team and your test-driven-development workflow as the owners of the method; this file does not say how to run the test.

1. Was a test, a failing test or a regression test asked for? Yes satisfies the "asked or already testable" condition by itself, but never overrides check 3 or check 4.
2. Is there an obvious cheap local test path? That means either an existing test of the same kind (unit, component or integration) for this code path that runs locally, or a working local runner where one plain assertion reproduces the bug using only what the runner already provides, including a small fixture or setup such as a temporary file. Large setup, brittle mocks and large unrelated fixture changes are rejected in check 4, not here. Name it. Yes satisfies the "asked or already testable" condition, and no existing test for the exact code path is needed. No means no practical path is obvious; unless check 1 is yes, a new test from scratch is not worth it.
3. Can the broken behavior be reproduced with one narrow input, in a short, repeatable run? No is a veto, even on an explicit request: a vague reproduction cannot be turned into a trustworthy failing test.
4. Would the test need any of these: broad harness setup, brittle mocks, slow end-to-end infrastructure, production-only state, or large unrelated fixture changes? Yes is a veto, even on an explicit request. Name the closest useful check instead (a targeted script, a reproduction command, a log assertion, a focused integration check).
5. Does correctness depend on a whole range of inputs rather than a few chosen examples? If yes, is the rule stated once as a property and checked with the property-testing library the project already uses? Cite the test or the library. If the project has none, report that to the orchestrator as the owner's decision; do not pick or install one. When recommending a property, state whether it says something about the result: yes is required. A property that only says the code does not crash is too weak, and the report says so. No on the first question means this check is not applicable.

## Test the behavior, not the implementation

A test is a claim about what the code does for its users: a caller, an end user, or another service. Behavior is what they can observe through the interface they use: return values, errors, state they can read back, and effects on systems outside the code, such as a request sent or a row written. Implementation is what they cannot observe: private helpers, internal call order, intermediate data, and which internal part did the work.

Judge each test against two imagined edits:

6. Break the behavior. Imagine the code returns a wrong value, skips an effect, or does the effect twice. Would this test fail? If it still passes, it proves nothing. Common causes are an assertion looser than the contract, an expected value computed by the code under test, a restated constant that never runs the code that reads it, and an assertion on data the test built itself. Cite the assertion.
7. Change the internals. Imagine the observable results stay the same while the code underneath is restructured. Would this test fail? If yes, it is pinned to the implementation and will need a rewrite at every refactor without catching a bug. Cite the line that depends on the internals.

Keep a test that fails under the first edit and survives the second. Rewrite or delete the rest. Take the expected value from the requirement, not from a run of the code, and assert what the contract promises, no less and no more.

The contract decides what counts as behavior, not the shape of the assertion:

- A payload sent to an external service is behavior, because that service observes it. A call to an internal helper is not.
- A claim that something did not happen, such as "an empty cart never charges", is behavior. Pair it with a case where the charge does happen, so the test shows it can see a call.
- An empty result is the exact answer when nothing matches, and a hollow check when any result would pass.
- An exact error message pins wording that no caller reads. The error type that callers branch on is the contract.
- A test can pin an invariant instead of a call, such as a key that must exist in two tables or a compile-time type check. The invariant is the behavior.

## Example

A report says the month-end date formatter prints the wrong day. A test file for the formatter already exists and runs in a second, and one input reproduces the bug. Check 1 is no, but check 2 is yes, check 3 is yes and check 4 is no: the trigger is met. Write the failing test with the single input that breaks, then fix.

A function `clamp(x)` has no tests and returns -1 for an input of -1, where the requirement says 0. The project has a working local test runner, and one plain assertion reproduces the bug with no setup. Nobody asked for a test, but check 2 is yes through the obvious cheap path, check 3 is yes and check 4 is no: the trigger is met.

A second report says an export fails only on a customer's production data that nobody can copy. Check 4 is yes (production-only state), so the trigger fails even if a test was requested. A third report asks for a regression test but gives no input that reproduces the failure: check 3 is no, so the trigger also fails despite the request and the existing harness. Report that a new test is not worth it, and use the closest useful check, such as a targeted reproduction on a synthetic file with the same shape.

## When it does not apply

- The work is not a bug fix with a clear target, such as an exploratory spike, and nobody asked for a test.
- The change is configuration, documentation or copy, where a test would only restate the text.
- The project's own instructions set a different testing rule. Those win.
- Check 5 applies only when the input range matters. For a function with three meaningful cases, three examples are clearer.
- Throwaway scripts that will be deleted after one run.
