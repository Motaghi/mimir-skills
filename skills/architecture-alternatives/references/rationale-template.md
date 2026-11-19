# Rationale template

This file is read together with `SKILL.md` after the owner has answered the review page. The rationale is a short record of why the chosen shape won. The orchestrator decides where it is filed; this package writes nothing to the project docs.

Sections, in this order:

1. Problem: the one-sentence problem and its sourced constraints.
2. Usage: the caller's view of the chosen shape, with its realistic call sites.
3. Shape: types and signatures with bodies marked not implemented, or the module map.
4. Alternatives considered: each other candidate, judged on what it exposes and what it hides.
5. Tradeoffs accepted: each one written as "we accept X in exchange for Y".
6. Challenge result: cycles run and the four buckets, with the Dismissed findings shown.
7. Open questions and risks, each phrased as a question.
8. Next implementation step, in one sentence. Planning and building start afterward under the orchestrator's routing.

A section whose evidence is missing says "unverified". Every claim about code names a file and a symbol.
