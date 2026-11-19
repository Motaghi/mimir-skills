# Design red flags

This file is read together with `SKILL.md` at the comparison step. Screen every candidate against the list. A trip is a reason to revise the candidate, or to count against it on the comparison page. The result goes into the candidate's "red flags it trips" field, with the file or call site that shows the trip. A flag with no such evidence is reported as unverified.

- Shallow module: a wide surface hiding little. Callers coordinate several methods to finish one operation, or options expose internal stages.
- Information leakage: one internal decision, such as a representation, a policy or a protocol detail, shows up in several modules, or transport and storage types are re-exported.
- Temporal decomposition: modules cut by order of execution (load, validate, transform, save) when one module should own what they all know.
- Pass-through method: forwards the same arguments to another method and adds nothing.
- Split ownership: more than one module writes the same state or keeps its own copy. Give it one owner; the others read it or ask the owner.
- Two ways to do one task: callers copy whichever they find first, so both keep gaining callers. Keep one, move callers, delete the other in the same change.
- Importable internals: any caller can reach inside a module. Make internals unreachable, so an import from outside fails the build.
- Hand-synced list: the same items kept in several places. Keep one list and derive the rest, or fail the build when they disagree.

The next contributor, a person or an agent, sees only the files they opened, copies the nearest example and takes the shortest path that works. Judge each candidate by that reader.

Prefer the candidate that hides more behind a smaller surface. A long chain of small calls is not a smaller surface: it scatters understanding across layers.
