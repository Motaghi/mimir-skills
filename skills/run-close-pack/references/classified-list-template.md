# <run> decisive suite on <tested-tip-sha>, classified failure list

Source: <suite log path> (<workers>, <start>-<end>): <passed> passed, <failed> failed, <flaky> flaky, <skipped> skipped.
Lone rerun: <rerun log path> (one worker, <start>-<end>, load <n>): <passed> passed, <failed> failed.
Cross-checks: <previous tip log paths>.

Write every red as `<spec-basename> :<line>`, one per reference, so red-set-reconcile.sh can key on it. Title-only reds (a failing test whose spec line is unknown) are keyed `<spec-basename> :0 <title>`.

When an item fits more than one category, the first listed category wins.

## A. Cleared on the lone rerun (<n>)
## B. Red alone but pre-existing on the base sha <sha> (<n>)
## C. Known and carried to the next run (<n>)
## D. Stale pin: a test that assumes a default or route this run moved (<n>)

## Verdict
No new regression, or: <named regression, spec and line>. The tested tip <sha> stands, or: does not stand.
