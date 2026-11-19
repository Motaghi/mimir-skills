# Acceptance checks

build-team relies on four small checks and one file format. The skill does not ship them. This file specifies each as a plain contract, so you can write them in any language or use your test runner's own features. All of them are read-only: they report, and the PM decides.

Conventions used below:

- A criterion ID is `AC-` plus digits, for example `AC-07`. A criterion is defined wherever a line of the spec starts with its ID, optionally after markdown emphasis (`**AC-07. ...**`), and that includes amendment sections.
- Every check prints one problem per line on stderr, prints nothing on stdout when it passes, and uses these exit codes: 0 pass, 1 one or more problems found, 2 bad usage or an unreadable input. An unreadable input is never a pass.
- "The suite" means the frozen acceptance test files, the driver and the stub that the test author wrote. "The test command" is the project's own command that runs them.

## Run manifest (the format the other checks read)

A run manifest is a JSON file written by the test run itself, never assembled from the test source. Its purpose is that tags and outcomes come from what ran.

Input: nothing but the test run. A small plugin or reporter for your test runner writes the file when the run ends. The PM deletes the manifest path before every run, so a leftover file from an earlier run can never be read as a result.

Output, one JSON object:

```json
{
  "schema": 1,
  "runner_exit": 0,
  "complete": true,
  "tests": [
    {
      "name": "tests/test_export.py::test_exit_code_on_empty_input",
      "tags": ["AC-03"],
      "outcome": "passed",
      "failure_kind": null
    }
  ]
}
```

- `name`: the test name exactly as the runner's own report writes it.
- `tags`: the criterion IDs the test carries. In Python with pytest, a marker such as `@pytest.mark.ac("AC-03")` with one or more IDs. In any other language, the literal text `[AC-03]` in the test title, which the reporter extracts. Two forms only.
- `outcome`: one of `passed`, `failed`, `skipped`, `error`. `error` means the test did not complete its body (setup failure, collection failure).
- `failure_kind`: for a failed test, `assertion` when the failure came from an assertion inside the test body, and `other` for anything else (an exception raised by the code under test, a setup error, a helper that forces a failure). `null` for tests that did not fail.
- `complete`: true only when the runner reached the end of the whole selection. Run the test command directly, with no stop-at-first-failure option, or this will be false.
- `runner_exit`: the test runner's own process exit code. A non-zero runner exit is a failed gate whatever the manifest says, because a crash can leave a tidy-looking manifest.

Exit codes of the reporter: it does not change the runner's exit code.

## 1. Spec readiness check

Question: is the spec ready for a test author?

Input: the path of the spec file.

It passes (exit 0) when all of these hold:

1. The spec has a section headed `Acceptance criteria` (any heading level).
2. The spec has a `stakes` field, in the frontmatter or as a line `stakes: high` or `stakes: low`, with exactly one of those two values.
3. At least one criterion is defined (see conventions).
4. Every criterion has at least one example row: a table row or list item with a Given, a When and a Then.
5. No criterion ID is defined twice.

Each failure prints one line such as `spec: AC-04 has no example row`. Exit 1 on any failure.

## 2. Stub-fail check

Question: does the suite fail for the right reason when nothing is implemented?

Input: a run manifest from a run of the whole suite against the stub (the driver reads an environment variable such as `ACCEPTANCE_TARGET=stub` and sends every call into the implementation to the stub, which returns empty results), and the allowed-pass file.

It passes (exit 0) when:

1. `complete` is true and `runner_exit` is non-zero (the suite as a whole fails against the stub).
2. Every test with outcome `failed` has `failure_kind` equal to `assertion`. A test that failed for another reason, or has outcome `error`, does not count as failing for the right reason and is reported.
3. Every test with outcome `passed` or `skipped` appears in the allowed-pass file. A skipped test is not a failing test.

Allowed-pass file format: plain text, one line per test, the test name exactly as the runner's report writes it, one tab character, then a reason. A single test may pass against the stub only when its signed example expects exactly the empty result the stub gives (for example exit code 0 with empty output). The file may be empty, and an empty file means no test is allowed to pass. A line without a tab or with an empty reason is a problem. A listed name that did not pass is also reported, so the file cannot go stale.

Anything else that passes goes back to the test author to gain a control drawn from another example of the same criterion. Nobody changes an expected value to make a test fail.

## 3. Assertion-diff check

Question: did anyone change the frozen suite after the freeze?

Input: the freeze commit (or tag) and the list of frozen suite paths, plus an optional list of paths that may change (the driver file).

It compares the working tree, including uncommitted and untracked files, against the freeze commit. It passes when no frozen suite file was modified, deleted or added, apart from the allowed paths. The driver may change because it holds the boundary calls that the implementation renames. Changing an expected value in a test, an assertion, a tag or the allowed-pass file is always a failure. It prints one line per offending path. Exit 1 when any is found, 2 when the freeze commit does not exist.

## 4. Criterion-tag check

Question: is every criterion covered by a test that actually ran?

Input: the spec, one or more run manifests (from the real run, and if you want, a second run), and an optional parked list (a text file, one criterion ID per line, each with a reason after a tab).

It passes when every criterion defined in the spec is either parked, or tagged on at least one test with outcome `passed`, `failed` or `error` in some manifest, that is, a test that was collected and executed. A criterion with no tagged test, or whose only tagged tests were skipped, is reported. A tag that names an ID the spec does not define is also reported. A parked criterion must have no tagged test, so a weaker stand-in test cannot make it look covered. Every manifest must have `complete: true`, otherwise the check exits 2.

## 5. Putting the checks into the loop

- The PM runs the spec readiness check before any work starts.
- The test author runs the suite against the stub and the PM runs the stub-fail check before the freeze.
- On every diff the PM runs the assertion-diff check and the criterion-tag check. The manifest path is deleted first, the suite runs with the manifest reporter, and a non-zero runner exit is a failed gate.
- Parked criteria (spec gaps found by the test author, or an owner ruling) go into the parked list and into the build report.
