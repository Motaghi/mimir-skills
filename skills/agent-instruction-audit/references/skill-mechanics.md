# Skill mechanics

The skill-specific part of the instruction audit in `SKILL.md`: what to check when the document under audit is a skill package. Everything else about grading a document is in `SKILL.md`. This file is a checklist for the audit. It does not tell the auditor how to write or edit a skill; that belongs to the owners named in "Not this package".

## The description is the pointer

A skill's description sits in the agent's context at all times, so it is the most expensive pointer in the system and the one that most needs pruning. Check that it:

- opens with the leading word of the job, so the trigger does its work in the first few words;
- names each distinct case the skill handles once, and merges synonyms that rename one case;
- names the owners of nearby cases it does not handle, since a clear exclusion stops a wrong pick as well as a clear trigger causes a right one;
- leaves out anything the body already says.

## Activation mode

Each package has one of three activation modes, and the audit checks that the description says which one it is.

- **Natural.** The description is the trigger. The orchestrator may select the package from ordinary intent. This is permanent context load in exchange for discoverability, so the description must earn its place by being narrow and by carrying the exclusions.
- **Explicit-natural.** The package applies only when the owner clearly asks for that mode in ordinary language, and the description says so. There is no trigger list to read as inference, so check that none was written. This spends the owner's attention, since the owner must remember the mode exists, and no context for inference.
- **Internal.** The package applies only when the orchestrator attaches it to a task as a labeled input. A direct request with nothing attached is declined with the owner's name. Check that the description says "applies only when attached".

Pick natural only when the agent must reach the package without being asked, or when another package must reach it. A package that is only ever used on request does not need a description that competes for attention on every turn.

## Shared reference

Reference that two packages both need can live in a package that is natural or internal, because the orchestrator can attach it to either. It cannot live inside an explicit-natural package that the other package has no way to reach. When the audit finds the same rule written out in two packages, report it as duplication and name the one place that should hold it, so a change is a one-place edit.

## Splitting by activation

Split a package into two when one half needs its own distinct leading word that the owner actually uses, or when another package must reach it. The new description then costs context on every turn, so the independent reach has to be worth that cost. Do not split to hide the later steps of a sequence unless the split falls on a real hand-off, since an inline call leaves them visible.

## Routing

The orchestrator is the only router. When there are many packages and the owner cannot remember them all, the cure is the orchestrator's own skill discovery and routing, not an extra package whose job is to list the others. An audit finding that proposes a package-of-pointers is reported as a duplicate of the orchestrator's routing.

## Package files

- `SKILL.md` carries the steps and the rules every path needs. Material that only some paths reach goes in `references/`, behind a pointer in `SKILL.md` that says when to read it.
- `references/upstream-notice.md` is provenance. It is never an instruction and never counts as an attachment.
- A package holds no host tool name, provider or model, because the same bytes must work on every host. Capabilities are named as in the README's Vocabulary section, each one justified by the files that use it.
