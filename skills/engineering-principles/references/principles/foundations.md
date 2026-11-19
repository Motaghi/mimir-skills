# Foundations

## Rule

Settle the data shape and the shared foundations before writing logic. Structural decisions protect option value, because they are expensive to change later. Code-level decisions protect simplicity.

## Why

When the core types and the dominant access paths are right, the code that follows is close to obvious. When they are wrong, every later feature pays for it. Work that helps every later phase should come first, so later phases do not each rebuild it.

## Checks

For each check, cite the type, the access path, the actors or the work items it concerns. A check with no citation is reported as unverified.

1. Data shape first: are the core types and data models defined before the logic that uses them, with every access path traced? Name the dominant paths.
2. Fit: does the chosen structure match the dominant access paths, not the rare ones?
3. Convergence: do types and data models converge instead of repeating the same shape in several places? Do not merge three similar statements into an abstraction too early, and do not repeat a whole structure either. Prefer explicit over clever. Tests should cover behavior and edge cases, not line counts (see cheap-local-test.md).
4. Concurrency: before state is shared between actors, what happens if another actor changes it at the same time? If the honest answer is not "nothing", isolate the state. Name the actors.
5. Scaffold first: does every later phase benefit from this piece existing? Test setup, linting, build checks and shared types are scaffold. Is it sequenced before the features, and are tests sequenced before the fixes they cover?
6. Coherent increments: does each increment land a coherent abstraction or deepen an existing one, instead of spreading a new capability across callers as special-case coordination? Are commits small and single-purpose?
7. Subtraction before scaffold: is dead code removed before the foundations are laid on top of it?

## Example

A team plans a notifications feature. The plan starts with email templates and a sending function, and leaves the shape of a notification for later. Three channels later, each channel has its own record layout and its own retry rules.

Applying the principle: define one notification record and the two access paths that dominate (look up by recipient, scan for unsent), decide that sending state lives in that record, and set up the shared test fixture for it. The channels then become small adapters on one structure.

## When it does not apply

- An exploratory prototype whose purpose is to find out what the data looks like. Build the thinnest slice, and settle the structure once the shape is known.
- A small change inside an established structure that already fits. There is nothing foundational to decide.
- Scaffold that only one later phase uses is part of that phase, not a foundation. Do not build it ahead of need.
- When the real question is how to encode domain rules in a structure, see model-the-domain.md.
