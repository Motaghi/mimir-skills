# Minimize reader load

## Rule

Judge maintainability by the work a reader must do to understand the code. Track two independent axes: the layers a reader has to trace between a question and its answer, and the hidden or mutable state the reader has to keep in their head. Cut both wherever they cost more than they save.

## Why

Line count, cyclomatic complexity and "clean architecture" are proxies. Reader load is the thing that matters, and the two axes do not move together. A flat file with fifty module-level variables can be as hard to reason about as a six-layer adapter stack, so guard against both. Working memory is finite for readers, and every extra hop and every piece of state they must remember spends it.

## Checks

Evidence protocol: every check that fails cites a concrete trace from the artifact, such as the chain of calls from question to answer, or the list of places that write a piece of state. A check with no such citation is reported as unverified.

1. Layers: is there a wrapper with a single caller, an adapter with no second implementation, or indirection added for a need that never came? Cite the layer and its single caller or implementation. Inline it.
2. Pass-through: does a layer repeat the same methods and arguments as the layer next to it? Then it adds load without compressing anything. Cite both signatures. Collapse it.
3. Interface compression: must callers understand the private representation or the internal decisions behind the interface in order to use it correctly? Cite one concrete example from the artifact, such as a caller that has to know which keys a returned dictionary holds. If yes, prefer a boundary that hides that decision.
4. State scope: can the state be narrower? Prefer pure functions (return values over mutation), locals over fields, fields over module state, and module state over globals. Derive a value instead of keeping a copy that must be synced. Cite where the state is written.
5. Invariants: is each invariant stated once, at the boundary, instead of re-explained in every consumer?
6. Cost of addition: before adding a layer or a piece of state, does it reduce reader load elsewhere by at least as much as it adds here? Name the reader load it removes and where. If none can be named, the answer is no.
7. The timed test: pick X, a named value or behavior in the artifact, and ask a reader who did not write the code "where does X come from?" and "what can change X?". Record the files opened and the time taken. The target is under 30 seconds. If no such observation is made, report this check as unverified and do not estimate a time.

## Example

A feature reads a setting through `SettingsFacade.get`, which calls `SettingsService.get`, which calls `SettingsRepository.get`, which reads a file. There is one implementation of each and one caller of each. A reader tracing a wrong value opens four files to find a single file read.

Collapse the three into one function that reads the file. If a second source of settings appears later, introduce the seam then, with two real implementations to shape it.

## When it does not apply

- A layer that has a second real implementation, or that exists because tests need a seam or an external contract needs a stable surface, is paying for itself.
- Collapsing is not always a win. Merging several short, clearly named functions into one long one can raise reader load. The measure is the reader's effort, not the number of files or lines.
- Cached or duplicated state is acceptable when a measured performance need requires it. Keep the sync point in one place and say where it is.
- Generated code and vendored code. Review the generator or the input, not the output.
- This principle is about people reading code. It says nothing about the end user's experience of the product.
