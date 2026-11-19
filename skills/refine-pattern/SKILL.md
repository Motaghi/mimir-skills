---
name: refine-pattern
description: Tighten a draft plan, spec, or task list so that fan-out bounds match measured counts and every cross-task reference is unambiguous. Use after producing or reviewing any implementation plan that names parallel fan-out, counted sub-tasks, or inter-task dependencies.
---

# refine-pattern

You are reviewing a plan, spec, or task list for three specific failure modes that appear repeatedly: over- or under-stated fan-out counts, stale or ambiguous cross-task references (e.g. "Task 0.5" pointing at a renumbered task), and language that promises a measured quantity but carries no evidence for the number.

## Required capabilities

- `filesystem` for the target document and cited evidence files.
- `shell` only when a bounded repository command is needed to confirm a count.
- `user-decision` before editing the target document.

If evidence cannot be read with the available capabilities, mark the value
unverified. Do not guess or silently use a different source.

## Steps

1. **Read the target document in full.**  
   Identify every place a count or bound is stated: parallel fan-out (`N workers`, `N branches`, `fan-out bound N`), task cross-references (`Task X`, `Step Y`, `see §Z`), and measured-evidence claims (`~N records`, `N calls`, `≤ N retries`).

2. **Audit fan-out bounds against evidence.**  
   For each stated bound, locate the evidence: a log line, a config value, a measured result already in the document or reachable in the repo. If the document says "fan-out bound 8" but the measured count in the associated log or config is 5, flag it and propose the corrected value. If there is no evidence at all, flag the number as unverified.

3. **Audit cross-task references.**  
   For each `Task N`, `Step N`, `§N`, or similar pointer, verify the target exists in the current document at that label. If the target was renumbered, renamed, or removed, replace the pointer with the current label or rewrite the sentence to remove the dependency.

4. **Tighten language without changing scope.**  
   Replace hedging or vague bounds ("roughly", "about", "many") with the measured value where evidence exists. Do not add new tasks, expand scope, or rewrite sections that are not affected by the three failure modes above.

5. **Output a diff-style summary.**  
   List each change as:
   - `[fan-out]` line N: changed bound from X to Y; evidence: SOURCE
   - `[ref]` line N: updated "Task 0.5" to "Task 1.0 (renamed)"; reason: renumbered in §2
   - `[language]` line N: replaced "~N" with "N"; source: LOG_OR_CONFIG_PATH

   If no changes are needed, say so explicitly.

6. **Ask before editing the file.**
   Present the summary to the user. Apply changes only when the user confirms
   through `user-decision`, or when the user explicitly pre-authorized these
   exact edits. Never silently rewrite a plan.
