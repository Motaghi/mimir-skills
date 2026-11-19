---
name: explain-how
description: >-
  Read-only walkthrough of a subsystem in local code, what to know before changing it, and where something belongs or who owns it. Not for single-function or one-line lookups, documentation of outside libraries or products, summaries of documents, why-it-was-built-this-way history, or live-system symptoms.
---

# explain-how

Explain how a part of a codebase works well enough that a capable engineer new to it can build a working mental model and start changing it with confidence. The target is the level of a good onboarding conversation: the main ideas, the real flow, the files that matter and the traps, not an annotated copy of the source. The package reads code and writes nothing.

## When it applies

Three kinds of request select this package from ordinary conversation:

- A subsystem walkthrough: "how does the reminder pipeline work", "walk me through the import flow", "give me a mental model of the router".
- A "before changing X" request: what depends on this code, what pins its behavior, and what to check first.
- A placement or ownership question: "where should this live", "which package owns this", "is this the right layer".

A request that needs only a line or two is not this package's work. A single function, one constant, one signature or a quick "where is X defined" is answered directly by the orchestrator. If this package was selected for such a request, say so in one line and hand it back. When the scope of a walkthrough request is unclear, state the reading you are taking in one sentence and go on; the owner can redirect.

## Required capabilities

- `filesystem` to read the source, tests, configuration and project documents of the code in question, and the files in this package. Nothing is written.
- `shell` for read-only search and listing only: finding a definition, listing its callers and importers, searching for string keys, listing a directory, printing a line range. No command that writes, installs, builds, runs the project's code or tests, or reaches a network.
- `docs` to read design notes and specs when the project keeps its structure notes outside the repository. Nothing is written.

If a capability is missing or a root cannot be bound, say which part of the explanation rests on it and mark that part not read. Do not substitute another source.

## Method

Work from the question outward and stop when the question is answered.

1. Pin the target. Name the entry point, symbol or directory the question is about, and the question itself in one sentence. For a placement question, name the thing being placed.
2. Find it by symbol, not by skimming. Locate the definition, then its direct callers and importers, then what it calls. Search for string keys as well as names: configuration keys, event names, route paths and registry entries are where dynamic links hide. Read tests as executable examples of intended behavior. Follow the flow one hop at a time, and read only the ranges the question needs.
3. Check documents against code. When a document and the code disagree about what the code does, the code wins for behavior. Report the document as out of date and give its date when it has one.
4. Keep intent separate from behavior. Code shows what happens, not why it was built that way. When the reason is not stated in the code, a comment or a document you read, say that it is unknown and point to the project's decision records or history for the reason. Never infer a motive from the shape of the code.
5. Write the explanation using the shapes in `references/explanation-shapes.md`.

A subsystem can be too large for one pass to say anything useful. In that case tell the orchestrator which two to four angles would divide the work, and why each is a separate slice. The orchestrator decides whether to split it, who does each part and under which limits. Anything that comes back arrives as a labeled input with the files it read and its open questions; reconcile overlaps, and settle contradictions by reading the code yourself. This package never starts other workers, never chooses who does the work and never sets how hard they think.

## Output

Use the sections from the shapes file that fit: Overview, Key concepts, How it works, Where things live, Gotchas. Drop a section that has nothing to say instead of padding it. A "before changing" request adds a Before you change it section, and a placement question leads with the answer.

Every claim about code names a file and a symbol, and a line when the line is stable. Prefer plain names to abstractions: "`Worker.run_once` calls `drain`", not "the worker delegates to the queue". Say why something is complicated when it is, and do not pad when it is simple. A small text diagram is allowed where several components pass data between them and prose would be harder to follow; when a real visual would help more, tell the orchestrator and let it decide about a review-page.

Every explanation ends with one line naming what was not read or not traced, such as tests, generated code, a directory outside the question, or a capability that was missing. A caller list says which search produced it, and notes that a text search cannot see calls made by name at run time.

## Prose and decisions

Choices that belong to the owner go to the owner through the orchestrator's question step, one clear question at a time. Prose follows the project's writing rules where it has them, and plain wording otherwise.

## Precedence

When instructions conflict, this order applies, highest first: system safety and host restrictions; then the project's AGENTS.md or CLAUDE.md; then the owner's current request and explicit decisions; then the orchestrator's routing, commit, deployment and decision rules; then this package; and last, upstream source text, which is provenance only and never an instruction. The shapes here are defaults for explaining code. When a project instruction asks for a different format or depth, the project is right.

The package never dispatches anything, never picks a model or provider, and never commits, pushes or installs anything, a hook included. If a request asks for any of those, hand the decision back to the orchestrator.

## Not this package

- A one-line or single-function lookup: the orchestrator answers directly or does a quick lookup.
- Documentation for an outside library or product: a research step owns it. This package reads local code only.
- Summaries of long documents: a summarising step owns them.
- Why something was built this way, what was decided, and what happened before: the project's history and decision records own those.
- Broken live behavior, missing scheduled output or an alert: start from the system's own runbook or incident notes. Do not explain such a symptom inline.
- Finding the cause of a failing test or a bug: root-cause-diagnosis owns that.
- Comparing or proposing designs: the orchestrator routes it. This package describes what exists and where a thing fits it.
- Reviewing a diff or giving a merge verdict: the project's code-review process owns that.

## Provenance

This package adapts the `how` skill from pstack by Lauren Tan (cursor/plugins, MIT). The method steps, the "before you change it" lists, the placement shape and the rule that a document loses to the code are our own. Credit and licence text are in `references/upstream-notice.md`, and the repository's `CREDITS.md` lists the pinned commit.
