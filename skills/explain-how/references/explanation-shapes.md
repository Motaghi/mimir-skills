# Explanation shapes

Three shapes cover the requests that select explain-how. Pick the one that matches the request, drop sections that have nothing to say, and keep every claim tied to a file and a symbol. The rules for method, evidence and what the package will not do are in `SKILL.md`; this file only fixes the layout.

## Walkthrough of a subsystem

Write for a senior engineer who has not seen this area. After reading it they should be able to say what the subsystem is for, follow one request or event through it, and know where to open the code first.

- **Overview.** One or two short paragraphs: what the thing is, what it does and what it is for. A reader should be able to stop here and decide whether the rest matters to them.
- **Key concepts.** The types, services and ideas needed to follow the flow, each with a short definition. Not a full inventory.
- **How it works.** The longest section. Start from what triggers the flow, then go step by step: what runs, in which file, what it calls next, what data moves between the steps and where the decisions are. Use prose with named files and functions. Quote code only where a few lines carry the point. When several components pass data between them, a small text diagram can help; skip it when prose already covers the flow.
- **Where things live.** A short map of files and directories, only those someone would need to start working here.
- **Gotchas.** Behavior that surprises, steps that are easy to get wrong, and places where a document no longer matches the code. Leave the section out when there is nothing to report.

## Before you change it

Use this when the request is "I am about to change X, what should I know". Give the short walkthrough first when the reader does not know the area, then add:

- **Before you change it.** Four short lists. Touch points: the callers, importers, config keys and registrations that depend on the code, each with a file and symbol, and the search that found them. Pins: the tests, schemas, fixtures or documented contracts that fix today's behavior. Neighbors: other modules whose own code or owners would feel the change. Open checks: what could not be established from reading, so the reader knows what to verify by running something.

Keep this section about facts in the code. A recommendation about whether to make the change, or how to design it, belongs to the design and review owners named in `SKILL.md`.

## Placement and ownership

Use this for "where should this live", "which package owns this", "is this the right layer".

- **Answer.** One or two sentences naming the place, or saying that no clear owner exists.
- **Evidence.** What supports it: the direction of imports between the modules, where sibling code of the same kind already sits, a project document that assigns the responsibility, a test that sits beside the neighbor.
- **Other candidates.** Any other place that could fit, with the reason it fits less well.
- **Open points.** Anything that would change the answer, such as a layering rule that is documented but not enforced, or an owner named in a document that the code no longer follows.

A placement answer describes the structure that exists. When the question turns into "what structure should we have", hand it to the orchestrator for the design owner.

## Angle brief for a split walkthrough

When the orchestrator agrees that a large subsystem is split into slices, each slice is described to the orchestrator in this form so it can route it:

- The question, quoted.
- The angle: one slice of the subsystem, such as "what triggers the flow and how input is validated" or "how results are stored and read back".
- What the contribution returns: the key components with file and one-line purpose, the flow step by step, every file read, the boundaries with other parts, anything non-obvious, and open questions. A contribution lists the files it read so that gaps can be named in the final explanation.
