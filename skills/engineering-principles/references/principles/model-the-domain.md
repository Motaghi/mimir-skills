# Model the domain

## Rule

Encode the real domain in a data structure instead of scattering it across conditionals. A structure that matches the domain makes invalid states impossible to represent and removes branches.

## Why

Picking the right structure while writing the code is cheap. Recovering it later looks like a refactor, so it gets deferred, and meanwhile each new feature adds one more branch to the pile.

## Checks

Answer yes or no to each, and cite the fields, branches or call sites that justify the answer. A yes means a fitting structure is missing. A check with no citation is reported as unverified:

1. Are there two or more booleans, phase strings or lifecycle checks that must stay consistent with each other? A state machine fits.
2. Are loose parameters, or the same shape assumption, repeated across functions or files? A typed model fits.
3. Is branching on one concept spread over several files? A map, registry, lookup table or discriminated union fits.
4. Is state changed in many places by ad hoc mutation? A reducer or a command and event model fits.
5. Is a module organized as a sequence (load, validate, transform, save) instead of around one body of domain knowledge? Execution order is not ownership. Phase-named modules that repeat the same domain rules are the sign.
6. Is repeated behavior, ownership or an invariant spread across callers? A small module boundary that gathers it fits.
7. Does the access pattern call for a queue, cache, index, graph, tree or normalized collection that the code lacks? Cite the access pattern from the code or the workload, such as the query shapes, the call sites or measured sizes. Without that evidence, report the check as not established.
8. Did a new feature grow an existing if/else chain by one more branch?

When no listed structure fits, ask two questions. What must this code never allow? How will the data be read? Then find the structure that encodes exactly that.

When the answer to check 1 is yes, list the invalid combinations the current fields allow, by name, before proposing a structure.

Closing test, against over-reach: does the proposed structure remove branches, duplicated rules, invalid states or lifecycle risk? Name which of those it removes. If it only adds indirection, it fails.

## Example

An order carries `is_paid`, `is_shipped` and `is_cancelled`. Three booleans allow eight combinations and only a few are meaningful, so every function that touches an order re-checks which combinations it can see. A refund path quietly handles "shipped and cancelled" because nobody ruled it out.

Replace the booleans with one status value and a table of allowed transitions: placed, paid, shipped, cancelled, refunded. Invalid combinations cannot be written, the checks shrink to one lookup, and a new status is one new row.

## When it does not apply

- The current shape is already clear, local and unlikely to grow. Prefer boring code.
- The domain is not understood yet, as in an early prototype. A structure chosen now encodes a guess, and a wrong structure costs more than a few conditionals. Revisit once the rules settle.
- The framework or the data format fixes the shape and a custom structure would fight it.
- A one-off script or migration that will be deleted.
- When the real problem is that a word has two meanings, fix the language first (see domain-language.md). When the problem is data arriving in the wrong shape, see boundary-discipline.md.
