# Outcome-oriented execution

## Rule

In a planned rewrite or migration with explicit phase boundaries, aim at the intended end state and prove it at the boundaries, instead of keeping every intermediate step fully working with throwaway compatibility code. Breakage between phases is acceptable only when it is planned, scoped and reversible. Where something that real people or systems depend on runs during the work, a safe intermediate state is required, and operations such as deploys, data migrations and cutovers often need one.

## Why

Keeping each step fully stable usually means writing temporary compatibility code, and temporary code tends to become permanent debt. Converging on the target and checking correctness at named points is cheaper and leaves a cleaner result. The price is that the breakage must be chosen on purpose. Breakage that nobody declared is just a broken system.

## Checks

For each check, cite the plan, the phase list, the deployment facts or the verification commands that show the answer. A check with no citation is reported as unverified.

1. Applicability: is this a planned rewrite or migration with explicit phase boundaries? Cite the plan. If it is a single ordinary change, mark the other checks not applicable: each ordinary change keeps the system working.
2. Safe intermediate state: is one required for any phase? A safe intermediate state is a point where the system still works for whoever uses it and the phase can be undone. It is required when any of these holds during that phase:
   - production traffic, a scheduled run or a person at work depends on the area being changed;
   - data in the old shape is stored or queued and must stay readable and writable;
   - a step cannot be undone, or its failure would leave the system unusable (a drop, a delete, a format change);
   - old and new code or data run together during a rollout.

   Name the phase and the condition. Where one holds, plan the phase so that new and old coexist until the next phase proves the new, and keep the compatibility code only for that span. Where none holds, no intermediate stability is needed.
3. Declared breakage: for each phase that is allowed to break something, does the plan say what may break, where, and for how long? A blanket statement such as "breakage is fine between phases" fails this check.
4. Scoped: is the breakage confined to the area being migrated, and does the plan keep high-signal checks running on the areas it touches?
5. Reversible: for each breaking phase, how is it undone (a revert, a restore, a switch back)? Cite the method. No stated method means the check is unverified, and an irreversible step with no stated method is raised to the orchestrator before it runs.
6. Throwaway compatibility code: is there compatibility code whose only purpose is to make a step feel smooth, when check 2 shows no step needs it? Cite it. That code is a candidate for removal. Compatibility code that check 2 justifies is kept for its span.
7. End-state verification: does the plan name the full static and runtime checks that run when the last phase is done? Cite them. The claim that the work is complete belongs to your verification-before-completion step; this file only says when an intermediate state may be rough.

## Exceptions

Where the work touches an external, public, client, data, legal or compatibility contract, a safe intermediate state is required whatever the plan says, because the breakage would land on parties who did not agree to it. Cite the contract and hand the decision to the orchestrator and the owner.

## Example

A branch rewrites the report renderer. Nobody deploys the branch. The plan says the renderer tests may fail between phases 1 and 3, only on that branch, restorable by reverting it, and names the full test suite plus a rendered sample as the end checks. Check 2 finds none of its conditions, checks 3 to 5 are met, and the rough middle is acceptable.

A four-phase move from `jobs_v1` to `jobs_v2` runs while the production scheduler claims jobs from `jobs_v1` every minute. Rows are copied in phase 2, readers switch in phase 3 and `jobs_v1` is dropped in phase 4. Check 2 is met through live use and through the drop. The plan says only "accept breakage between phases" and gives no scope or rollback for any phase, so check 3 fails on its own words. Phases 2 and 3 need both tables to coexist, and phase 4 needs a stated way back before it runs.

## When it does not apply

- Work that is not a planned multi-phase rewrite or migration.
- Anything under the exception above.
- Emergency fixes, where the smallest safe change comes first.
- A project instruction that sets a different rollout rule. Those win.
- Throwaway scripts and branches that nobody depends on and that will be deleted.
