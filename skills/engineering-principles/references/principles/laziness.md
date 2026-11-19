# Laziness

## Rule

Aim for the most result with the least code and complexity. Writing code is cheap, which makes over-engineering easy. Counter it by borrowing a maintainer's fatigue: look for removal before addition, keep decisions in one place, and make the smallest change that solves the problem.

This rule is about the size and shape of a design or a diff. It never allows leaving out work the task requires, shortening a requested output, or replacing complete content with placeholders. Completeness of what was asked for is a separate rule and wins.

## Why

Each extra layer, copy of a decision or piece of plumbing is something a maintainer has to understand and keep consistent. Small leaks compound into permanent coordination costs.

## Checks

For each check, cite the code, the diff lines or the call path that shows the answer. A check with no citation is reported as unverified.

1. Removal first: when the task is to refactor or improve, was removal considered before addition? Name what could be deleted. No fails.
2. One source of truth: is the same choice made in several places? Put it behind one source and pass the result on as a simple value.
3. Smallest diff: is every changed line needed to solve the stated problem? Name any hunk that is not. Fewer lines beat boilerplate that only looks elegant.
4. Flat call hierarchy: to answer a question about a value, must a reader pass through layers that make no decision? A rich interface that hides real work is not a deep chain. Judge the layers by whether they add anything, not by how many files they span.
5. Threading: does the task pass a new signal through types, schemas, pipelines or similar layers? Yes fails, unless a more direct path was looked for and shown to be unavailable. Name the direct path or say why none exists.
6. Small leaks: are there tiny pass-throughs, representation leaks or duplicated choices that would spread if left alone? Remove them while they are small.
7. Maintainer test: would a maintainer find this exhausting to work on? Name the specific burden (a copy to keep in sync, a layer to trace, a signal to thread). If none can be named, the answer is no.

## Example

A request adds a "dry run" option to a deployment command. The first design adds a field to the config schema, the parser, the planner, the executor and the logger, so each can branch on it.

Check 5 asks for a more direct path. The planner already produces a list of actions, and the executor is the only place that applies them. Add the flag where actions are applied, and skip the apply step when it is set. One decision, one place, a diff of a few lines.

## When it does not apply

- Requested output must be complete. Do not shorten a document, a data file or a code listing because a shorter one would be lazier.
- Required safety, compliance or contract behavior. A check, log or guard that the spec or a regulation demands is not a leak to remove (see subtract.md for the named exceptions).
- A new layer or flag that is the stated goal of the task, such as an extension point the owner asked for.
- Hot paths where a measured performance need justifies extra structure. Cite the measurement.
- When the issue is the cost to the reader of tracing the code, see minimize-reader-load.md. This file is about diff size and where decisions live; the reader-load file is about tracing cost, and deep-modules.md is about interface shape.
