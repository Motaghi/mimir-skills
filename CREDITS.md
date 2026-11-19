# Credits

Several skills in this repository adapt text from other open-source skill collections, all under the MIT License. Each entry below names the upstream skill, its author, the repository, the exact commit our copy is based on, the upstream copyright line, and what we changed. The full MIT permission text is in each skill's own notice file and in LICENSE.

## Adapted skills

### build-team from show-me-your-work
Upstream skill: pstack/skills/show-me-your-work
Author: Lauren Tan
Repository: https://github.com/cursor/plugins
Pinned commit: 88d47514b82e7c44f00f2b2a72ff6dd12158038c
Licence: MIT License, Copyright (c) 2026 Lauren Tan
Our change: build-team is an original skill. Only its report-field section borrows from this skill (the six decision fields, evidence as a pointer, superseded entries) and its cheap-local-test trigger borrows the idea from pstack's tdd skill at the same commit; the log script, the separate decision log, the transcript audit and the cross-model trail review are not adopted.

### typescript-discipline from typescript-best-practices
Upstream skill: pstack/skills/typescript-best-practices
Author: Lauren Tan
Repository: https://github.com/cursor/plugins
Pinned commit: 88d47514b82e7c44f00f2b2a72ff6dd12158038c
Licence: MIT License, Copyright (c) 2026 Lauren Tan
Our change: Merged with the second pstack skill into one numbered rule set with a report form, rewrote the code examples with new names, corrected three upstream examples so they type-check under strict settings, and added the hot-path exceptions, the evidence condition for claiming a hot path and the attach-only activation rule.

### typescript-discipline from principle-type-system-discipline
Upstream skill: pstack/skills/principle-type-system-discipline
Author: Lauren Tan
Repository: https://github.com/cursor/plugins
Pinned commit: 195d9359bdc2890f83745df69927528ad4538406
Licence: MIT License, Copyright (c) 2026 Lauren Tan
Our change: Merged with typescript-best-practices into one rule set, keeping the type-system reasoning in references/type-system.md and rewording the rules as numbered checks with met, failed, not applicable or unverified results.

### engineering-principles from principle-foundational-thinking
Upstream skill: pstack/skills/principle-foundational-thinking
Author: Lauren Tan
Repository: https://github.com/cursor/plugins
Pinned commit: 88d47514b82e7c44f00f2b2a72ff6dd12158038c
Licence: MIT License, Copyright (c) 2026 Lauren Tan
Our change: Turned the pstack principle skills into one index of short principle files with numbered checks, evidence rules and explicit "when it does not apply" lists. The same pin also feeds the idempotent-operations, boundary-discipline, reader-load, model-the-domain, laziness, subtract, redesign, migrate-callers, outcome-execution and explain-the-number files, the test rule from principle-test-behavior-not-implementation and the cheap-local-test trigger from tdd; four of those (idempotent operations, laziness, migrate callers, subtract) also draw on commit 195d9359bdc2890f83745df69927528ad4538406. Added an evidence condition before any redesign and the external-contract exceptions.

### engineering-principles from domain-modeling
Upstream skill: skills/engineering/domain-modeling
Author: Matt Pocock
Repository: https://github.com/mattpocock/skills
Pinned commit: 5beb35b040e3de97e54fa9e386d7e42d15c295c2
Licence: MIT License, Copyright (c) 2026 Matt Pocock
Our change: Drew on this skill for term disambiguation, scenario tests and the decision-record threshold in domain-language.md, and on codebase-design, code-review and improve-codebase-architecture at the same commit for deep-modules.md, review-fixed-point-traceability.md and hotspot-scan.md. Dropped the context and glossary files, the separate reviewers, the issue-tracker step, the fixed smell list and the architecture report loop.

### engineering-principles from constraint-driven-development
Upstream skill: skills/constraint-driven-development
Author: Addy Osmani
Repository: https://github.com/addyosmani/agent-skills
Pinned commit: aeac41d4d005999432bb7312f7ff06383a91d59d
Licence: MIT License, Copyright (c) 2025 Addy Osmani
Our change: Kept only the list of moves that quietly lower a quality bar and the ranking of checks into external, project-owned and the author's own suite, as quality-bar-guard.md, with a reason-and-owner check. Dropped the intake questions, the constraints file, the default numbers, the tool installs and the instruction-file edits.

### prototype from principle-experience-first
Upstream skill: pstack/skills/principle-experience-first
Author: Lauren Tan
Repository: https://github.com/cursor/plugins
Pinned commit: 88d47514b82e7c44f00f2b2a72ff6dd12158038c
Licence: MIT License, Copyright (c) 2026 Lauren Tan
Our change: Used the five rules and the idea that the user is whoever consumes the work as references/experience-first.md, and added the questions for judging a prototype, the link to the foundations principle and the rule that a project's own gate wins.

### prototype from prototype
Upstream skill: skills/engineering/prototype
Author: Matt Pocock
Repository: https://github.com/mattpocock/skills
Pinned commit: 5beb35b040e3de97e54fa9e386d7e42d15c295c2
Licence: MIT License, Copyright (c) 2026 Matt Pocock
Our change: Kept the split between a logic demo and UI variants, and wrote both as build requests with a start gate, service isolation, an evidence-to-return list, a hidden variant switcher and an answer note, so the skill itself writes and runs nothing.

### proof-map from create-verification-skill
Upstream skill: pstack/skills/create-verification-skill
Author: Lauren Tan
Repository: https://github.com/cursor/plugins
Pinned commit: 88d47514b82e7c44f00f2b2a72ff6dd12158038c
Licence: MIT License, Copyright (c) 2026 Lauren Tan
Our change: Changed the output from a project-local skill folder with generated helper scripts to one proof-map document, and added the launch-from-empty-data rule, the rule that a missing seed precondition reports a failure and is never weakened, the stand-in gap list and run requests in place of running anything.

### proof-map from maintain-verification-skill
Upstream skill: pstack/skills/maintain-verification-skill
Author: Lauren Tan
Repository: https://github.com/cursor/plugins
Pinned commit: 88d47514b82e7c44f00f2b2a72ff6dd12158038c
Licence: MIT License, Copyright (c) 2026 Lauren Tan
Our change: Became maintain mode in references/maintain-mode.md, which edits only the map document, turns every run into a run request and replaces the parallel readers and the correction pull request with an authority rule and a report.

### proof-map from create-formal-verification-skill
Upstream skill: pstack/skills/create-formal-verification-skill
Author: Lauren Tan
Repository: https://github.com/cursor/plugins
Pinned commit: 88d47514b82e7c44f00f2b2a72ff6dd12158038c
Licence: MIT License, Copyright (c) 2026 Lauren Tan
Our change: Kept only the method in references/formal-checks.md (how to pick the target and approach, what a check must record, how to sort failures into drift and bugs); tool installs, tool runs and the scratch break on real code became proposed text and run requests.

### proof-map from maintain-formal-verification-skill
Upstream skill: pstack/skills/maintain-formal-verification-skill
Author: Lauren Tan
Repository: https://github.com/cursor/plugins
Pinned commit: 88d47514b82e7c44f00f2b2a72ff6dd12158038c
Licence: MIT License, Copyright (c) 2026 Lauren Tan
Our change: Kept the upkeep method as the formal checks pass inside maintain mode, with two separate results per check (sync status and verification result) and edits to model, harness and property files handed back as proposed text.

### explain-how from how
Upstream skill: pstack/skills/how
Author: Lauren Tan
Repository: https://github.com/cursor/plugins
Pinned commit: 88d47514b82e7c44f00f2b2a72ff6dd12158038c
Licence: MIT License, Copyright (c) 2026 Lauren Tan
Our change: Kept the explanation layout, the rule to reconcile overlapping findings by reading the code and the concrete-names guidance; dropped the fixed worker prompts and roles, and added the method steps, the "before you change it" lists, the placement shape and the rule that a document loses to the code.

### merge-intent-resolution from resolving-merge-conflicts
Upstream skill: skills/engineering/resolving-merge-conflicts
Author: Matt Pocock
Repository: https://github.com/mattpocock/skills
Pinned commit: 6654f6b60cd9d5be8b54c6fafe44346dabeb3b76
Licence: MIT License, Copyright (c) 2026 Matt Pocock
Our change: Kept the five steps (look at the state, find primary sources, resolve each hunk without inventing behaviour, run the project's checks, finish), allowed an abort when a side's intent cannot be recovered, never commits, reads task records instead of outside tickets, and added the read-only rule with run requests, baselines, the search for conflicts the markers do not show, the generated-file rule and the report format.

### internal-technical-writing from technical-writing
Upstream skill: pstack/skills/technical-writing
Author: Lauren Tan
Repository: https://github.com/cursor/plugins
Pinned commit: 88d47514b82e7c44f00f2b2a72ff6dd12158038c
Licence: MIT License, Copyright (c) 2026 Lauren Tan
Our change: Kept the four kinds of page, the sentence rules and the rule that a stated count must be true at the commit that lands it; rewrote the layers and worked example, dropped the review checklist, and added the activation rule, execution limits, review report form, reader test and PR and commit section. The upstream skill builds on Diataxis, the Google developer documentation style guide, ASD-STE100 and Global English, which our SKILL.md credits.

### internal-technical-writing from pr
Upstream skill: skills/engineering/pr
Author: Matt Pocock
Repository: https://github.com/mattpocock/skills
Pinned commit: 5beb35b040e3de97e54fa9e386d7e42d15c295c2
Licence: MIT License, Copyright (c) 2026 Matt Pocock
Our change: A source for the PR and commit text section, which we rewrote in our own words and extended with a merge-danger line, a before and after evidence pair and the limit that the skill makes no branch, commit, push or pull request.

### run-close-pack from show-me-your-work
Upstream skill: pstack/skills/show-me-your-work
Author: Lauren Tan
Repository: https://github.com/cursor/plugins
Pinned commit: 88d47514b82e7c44f00f2b2a72ff6dd12158038c
Licence: MIT License, Copyright (c) 2026 Lauren Tan
Our change: Adapts the decision-trail format as the evidence-fields section of the close sequence: the six fields (ts, phase, decision, why, evidence, result), evidence as a pointer that resolves, and a wrong entry superseded by a later one, never edited. The fields are recorded in the channel line, classified list or sweep record each close step already writes, with no log file or script; an entry with no resolving pointer is marked unverified; the step gates still decide pass or stop. The upstream log script, transcript audit and cross-model review of the trail are not adopted.

### blast-radius from blast-radius
Upstream skill: pstack/skills/blast-radius
Author: Lauren Tan
Repository: https://github.com/cursor/plugins
Pinned commit: 88d47514b82e7c44f00f2b2a72ff6dd12158038c
Licence: MIT License, Copyright (c) 2026 Lauren Tan
Our change: Replaced the multi-model comparison step with bounded review routed by an orchestrator, wrote the proof as a run request the orchestrator carries out, added the rule for a change with no effect outside its diff, the containment rule for effects on shared state and the wide-change step, and generalised every platform-specific step to a neutral orchestrator.

### agent-instruction-audit from correct
Upstream skill: pstack/skills/correct
Author: Lauren Tan
Repository: https://github.com/cursor/plugins
Pinned commit: 88d47514b82e7c44f00f2b2a72ff6dd12158038c
Licence: MIT License, Copyright (c) 2026 Lauren Tan
Our change: Made the audit report-only: it proposes edits, checks and run requests and an orchestrator files and routes them, instead of fixing each class in a commit or keeping a rule table. Kept the fix ladder, the failing-on-a-real-past-mistake proof and the same-command-locally-and-in-CI rule in new wording, and generalised every platform-specific step to a neutral orchestrator.

### agent-instruction-audit from retro
Upstream skill: skills/engineering/retro
Author: Matt Pocock
Repository: https://github.com/mattpocock/skills
Pinned commit: 5beb35b040e3de97e54fa9e386d7e42d15c295c2
Licence: MIT License, Copyright (c) 2026 Matt Pocock
Our change: Kept the rule that the retro runs only when asked and replaced the steering toward building hooks, lint rules, CI jobs and a standards file with proposals that an orchestrator files and never applies. Generalised every platform-specific step to a neutral orchestrator.

### agent-instruction-audit from writing-for-agents
Upstream skill: skills/productivity/writing-for-agents
Author: Matt Pocock
Repository: https://github.com/mattpocock/skills
Pinned commit: 5beb35b040e3de97e54fa9e386d7e42d15c295c2
Licence: MIT License, Copyright (c) 2026 Matt Pocock
Our change: Turned the writing guide and its skill mechanics file into an audit checklist, mapped the model-invoked and user-invoked choice onto three activation modes, and replaced the upstream router skill with the orchestrator's own routing.

### architecture-alternatives from architect
Upstream skill: pstack/skills/architect
Author: Lauren Tan
Repository: https://github.com/cursor/plugins
Pinned commit: 88d47514b82e7c44f00f2b2a72ff6dd12158038c
Licence: MIT License, Copyright (c) 2026 Lauren Tan
Our change: Bounded the design comparison to two or three structurally different candidates on one review page, added the precedent and fork test, the isolation rule for contributors and the no-slot stops, replaced the multi-model synthesis step and named reviewers with requests to an orchestrator, and ended the package at the decision and a rationale.

### architecture-alternatives from interrogate
Upstream skill: pstack/skills/interrogate
Author: Lauren Tan
Repository: https://github.com/cursor/plugins
Pinned commit: 88d47514b82e7c44f00f2b2a72ff6dd12158038c
Licence: MIT License, Copyright (c) 2026 Lauren Tan
Our change: Turned the adversarial review into a challenge step for the recommended design, with one packet for every reviewer, four buckets with raisers and a stop rule, and replaced model choice with requests to an orchestrator. The verdict-calibration section also follows the same skill at commit 195d9359bdc2890f83745df69927528ad4538406.

### architecture-alternatives from principle-exhaust-the-design-space
Upstream skill: pstack/skills/principle-exhaust-the-design-space
Author: Lauren Tan
Repository: https://github.com/cursor/plugins
Pinned commit: 195d9359bdc2890f83745df69927528ad4538406
Licence: MIT License, Copyright (c) 2026 Lauren Tan
Our change: Expanded the principle into nine checks with uniform candidate fields, an isolation check and two worked examples, and kept the rule, its rationale and the lists of when it applies from this earlier commit, where the later upstream commit had shortened them. Reference text that follows the later commit 88d47514b82e7c44f00f2b2a72ff6dd12158038c is noted in the skill's upstream notice.

### architecture-alternatives from principle-exhaust-the-design-space
Upstream skill: pstack/skills/principle-exhaust-the-design-space
Author: Lauren Tan
Repository: https://github.com/cursor/plugins
Pinned commit: 88d47514b82e7c44f00f2b2a72ff6dd12158038c
Licence: MIT License, Copyright (c) 2026 Lauren Tan
Our change: Used the principle's shorter form at this later commit for the opening sentence about decisions that depend on feel, and expanded it into the nine checks with uniform candidate fields, an isolation check and two worked examples. Most of the rule text follows the same skill at commit 195d9359bdc2890f83745df69927528ad4538406, listed in the entry above.

### architecture-alternatives from interrogate
Upstream skill: pstack/skills/interrogate
Author: Lauren Tan
Repository: https://github.com/cursor/plugins
Pinned commit: 195d9359bdc2890f83745df69927528ad4538406
Licence: MIT License, Copyright (c) 2026 Lauren Tan
Our change: Restored the verdict-calibration guidance (a verdict is useful and not exhaustive, rejected findings are always shown, more than five items to act on means re-sort) from this earlier commit, where the later upstream commit had removed it. The packet, lenses and lead-judgment filters follow the entry above.

### architecture-alternatives from doubt-driven-development
Upstream skill: skills/doubt-driven-development
Author: Addy Osmani
Repository: https://github.com/addyosmani/agent-skills
Pinned commit: aeac41d4d005999432bb7312f7ff06383a91d59d
Licence: MIT License, Copyright (c) 2025 Addy Osmani
Our change: Kept the claim-first, smallest-reviewable-unit and three-cycle stop rules for the challenge step and merged the four finding classes into four buckets, and dropped the steps that pick or call outside reviewers so that provider choice stays with an orchestrator.

### root-cause-diagnosis from principle-fix-root-causes
Upstream skill: pstack/skills/principle-fix-root-causes
Author: Lauren Tan
Repository: https://github.com/cursor/plugins
Pinned commit: 88d47514b82e7c44f00f2b2a72ff6dd12158038c
Licence: MIT License, Copyright (c) 2026 Lauren Tan
Our change: Turned the principle into a review rule with eight checks, added a containment exception for outages, and rerouted the fix of every instance of a pattern through an orchestrator after a closing search instead of fixing all instances at once.

### root-cause-diagnosis from principle-attack-the-premise
Upstream skill: pstack/skills/principle-attack-the-premise
Author: Lauren Tan
Repository: https://github.com/cursor/plugins
Pinned commit: 88d47514b82e7c44f00f2b2a72ff6dd12158038c
Licence: MIT License, Copyright (c) 2026 Lauren Tan
Our change: Used the principle as the premise check that fires after two fixes on one premise fail the same gate, and replaced the link to a tool-building principle with a plain rerunnable-check rule.

### root-cause-diagnosis from diagnosing-bugs
Upstream skill: skills/engineering/diagnosing-bugs
Author: Matt Pocock
Repository: https://github.com/mattpocock/skills
Pinned commit: 5beb35b040e3de97e54fa9e386d7e42d15c295c2
Licence: MIT License, Copyright (c) 2026 Matt Pocock
Our change: Made the loop read-only with every write specified as a run request for an orchestrator, added the setup-incident lookup step, the shared-worktree rule, the closing search for the same mistake elsewhere and a fixed report format, and dropped the project terms file and the bundled prompt script.

### wayfinder from wayfinder
Upstream skill: skills/engineering/wayfinder
Author: Matt Pocock
Repository: https://github.com/mattpocock/skills
Pinned commit: 5beb35b040e3de97e54fa9e386d7e42d15c295c2
Licence: MIT License, Copyright (c) 2026 Matt Pocock
Our change: Added source authorities, freshness and conflicts and a per-assertion status to the map, a claiming step so concurrent sessions skip a ticket in hand, run requests for every write, and generalised the map home and the task tracker steps to a neutral task tracker.

### wayfinder from to-tickets
Upstream skill: skills/engineering/to-tickets
Author: Matt Pocock
Repository: https://github.com/mattpocock/skills
Pinned commit: 5beb35b040e3de97e54fa9e386d7e42d15c295c2
Licence: MIT License, Copyright (c) 2026 Matt Pocock
Our change: Kept tracer-bullet slices, blocking edges, the expand-migrate-contract sequence and the approval round, and limited tickets mode to adding queued tasks and recording blockers in a task tracker through run requests, with a read-back and a clash rule for ids.

### wayfinder from triage
Upstream skill: skills/engineering/triage
Author: Matt Pocock
Repository: https://github.com/mattpocock/skills
Pinned commit: 5beb35b040e3de97e54fa9e386d7e42d15c295c2
Licence: MIT License, Copyright (c) 2026 Matt Pocock
Our change: Replaced the label scheme with one ticket state at a time read from the map, kept the check of the claim before grilling, the existing-implementation and earlier-ruling checks, the note for a waiting ticket and the durable brief, and dropped outside pull requests as a request surface.

### no-mistakes from no-mistakes
Upstream skill: skills/no-mistakes
Author: Kun Chen
Repository: https://github.com/kunchenguid/no-mistakes
Pinned commit: 1aaa31d5d171c542f09acd6d506881447fc9f177
Licence: MIT License, Copyright (c) 2026 Kun Chen
Our change: Copied the upstream skill file unchanged and added only two sections. The Local contract section adds these rules: explicit request only; one gated push of the current branch and nothing beyond it; start with an intent and a default skip of document, pr and ci; document skipped by default because it edits documentation and applies its own fixes; no init or update; no branch moves in shared trees; pr and ci only on request; task-first mode that commits exact paths before the run; and --yes only when the user asked for an unattended run. The final Credit section names Kun Chen and the upstream repository.

## Ideas drawn on

These projects gave us ideas. No text was copied from any of them, so no licence text is reproduced and none of them is a fork. They are credited because the ideas are theirs.

- Trail of Bits, `trailofbits/skills`, plugin `property-based-testing` (CC BY-SA 4.0). The idea that a rule over a whole range of inputs is better stated once as a property than as a few chosen examples. It informed the property-test check in the `engineering-principles` cheap-local-test file. We read the plugin at commit 5c99c03fb8a9ea568432ecbcba5d86e9f4ac2bf0 and wrote our wording from scratch.
- Trail of Bits, `trailofbits/skills`, plugin `variant-analysis` (CC BY-SA 4.0). The idea of searching for the same mistake elsewhere once one instance is found. It informed the review rule in `root-cause-diagnosis`. Same commit, wording written from scratch.
- Anthropic, `anthropics/skills`, skill `doc-coauthoring` (no licence file at the commit we read, dbd4588f9e1033efb41dad4bef2f7947c8993d44). An idea source for the document-writing method in `internal-technical-writing`, recorded in that skill's notice. Wording written from scratch.
