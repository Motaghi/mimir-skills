# Migrate callers, then delete the old API

## Rule

When a new internal API replaces an old one, move every caller to the new API and delete the old one in the same change set, instead of keeping a compatibility layer. Do not keep a legacy path alive only because internal callers still use it. Take an inventory of the callers, migrate them, and delete the old API right away. A temporary adapter is the exception: it needs a reason from check 4, an owner, a removal condition and a dated expiry or dated checkpoint. This rule does not reach external, public, client, data, legal or compatibility contracts. See the exceptions below.

## Why

Two APIs for one job double the paths to read, test and keep consistent, and the old one tends to outlive its reason. Callers that never move leave the code base append-only, and tests that protect the old shape keep pinning internals nobody wants. Moving the callers is the cost of the change, so pay it once and finish the job.

## Checks

For each check, cite the search, call site, document or contract that shows the answer. A check with no citation is reported as unverified.

1. Exceptions first: is the old API an external, public, client, data, legal or compatibility contract? That covers published interfaces and documented fields, file and wire formats, URLs, outputs agreed with a client, data that others read or depend on, regulated behavior such as audit and retention, and promises such as supported versions or a deprecation notice. Yes means mark checks 2 to 7 not applicable for that API, cite the source, and hand the decision to the orchestrator and the owner. An agreed deprecation schedule governs the timing. Having no callers in the repository does not show having no consumers. Apply this check before checks 2 to 7.
2. Caller inventory: is the full set of callers listed? State what was searched (source, tests, scripts, configuration, docs, examples) and how dynamic or generated use was covered. A caller set that cannot be established is reported as not established, and check 4 then applies.
3. Same change set: are the callers migrated and the old API deleted together? Cite the change that does both. Leaving the old API in place "for now" with no removal step fails this check. If check 4 holds, this check is met by a written removal step with an owner, a condition and a date (check 5).
4. Safe intermediate state: is one required? A safe intermediate state is a point where the system still works for whoever uses it and the change can be undone. It is required when any of these holds:
   - the callers cannot all change in the same release, because they sit in more than one deployable, repository or release train, so old and new code run together during rollout;
   - results or inputs of the old API are stored or queued in the old shape and must stay readable;
   - the complete caller set cannot be established.

   If none holds, none is required: migrate and delete in one change. If one holds, a temporary adapter is justified, and checks 5 and 6 apply.
5. Adapter discipline: where an adapter exists, does it forward to the new API (never the reverse), have a named owner, a removal condition and a dated expiry or dated checkpoint, and have the step that deletes it written into the plan? When the date passes, the adapter is removed or the orchestrator records an explicit decision to extend it with a new date. An adapter with no date fails this check. Do new callers use it? New callers must not.
6. Tests: do the tests assert the new contract, and are tests that only protect old internal details deleted? Cite the tests kept and removed.
7. Leftovers: are comments, docs and examples that name the old API removed or updated? Cite the search.

## Exceptions

Do not delete, and do not recommend deleting, any of these without the owner's decision:

- Published interfaces, documented fields, file formats and URLs that outside parties may use.
- Outputs, formats or service levels promised to a client.
- Data that others read or depend on, such as exports and shared stores.
- Legal or regulated behavior, and any compatibility promise such as a supported-version window.

## Example

A helper `formatPrice(amount, currency)` is replaced by `Money.format()`. A repository-wide search lists 14 call sites in source, tests and docs, all in one deployable that ships as one release, and the helper is not exported from any published package. Check 1 is clear, check 4 finds none of its conditions, so the change migrates all 14 sites and deletes `formatPrice` together, which meets check 3. A proposed wrapper "in case something needs it" has no reason behind it and is not added.

A response field `total_cents` is being replaced by `total` in a documented public API with two known partner integrations. Check 1 applies: the removal checks are marked not applicable, the API reference and the partners are cited, and the decision goes to the orchestrator and the owner. The new field can be added, and the old one stays until a deprecation is agreed.

An internal queue holds messages in the old payload shape, and workers on the old and new versions will run together for a day. Check 1 is clear because no outside party reads the queue. Check 4 is met through the stored shape and the mixed rollout. A short-lived adapter that reads the old payload is justified. Check 3 is met by the written removal step that gives the adapter an owner, a removal condition and an expiry date two weeks after the rollout starts. If that date passes with the adapter still in place, it is removed or the orchestrator records a decision with a new date.

## When it does not apply

- Anything under the exceptions above.
- API changes that are not replacements, where the old API keeps a purpose.
- Throwaway scripts that will be deleted after one run.
- A project instruction that sets a different migration rule. Those win.
- Emergency fixes, where the smallest safe change comes first and the migration waits.
