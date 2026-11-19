---
name: internal-technical-writing
description: >-
  Method for internal technical writing (runbooks, READMEs, design notes, PR and commit text) and for testing a draft with a cold read, attached by the orchestrator as a labeled input. Not for marketing or customer-facing copy, social posts or articles, changelogs (changelog-drafter) or long-form drafts. Applies only when attached.
---

# internal-technical-writing

A writing method for documents that engineers and operators read to get something done: runbooks, READMEs, design notes, reference pages, and the text of pull requests and commits. The aim is a text a tired colleague understands on the first read and can act on without asking the author. The method has two halves: sentence and structure rules for writing, and a reader test that checks the finished draft against a reader who has only the page.

## Activation

The steps apply only when the orchestrator has attached this `SKILL.md` as a labeled input to the task. A one-line pointer in a sub-agent's own instructions describes that attachment and does not activate the method, and `references/upstream-notice.md` is provenance, never an attachment.

With nothing attached, a direct request gets a decline and an owner's name: a long-form writing step for long drafts, changelog-drafter for changelogs, and the owners under "Not this package" for the rest. Say only that the orchestrator can attach this method to that task. Write no draft, give no rewrite, no review comments and no lean. Ordinary conversation, such as what a runbook is, is answered without this package.

Even when attached, the method declines customer-facing copy, social posts and articles, and names the owner from "Not this package".

## Execution limits

The package returns text in its reply, or writes the one file path that the orchestrator names for the draft. It writes nowhere else. It never runs, dispatches, commits, pushes or installs anything (a hook included), and it never picks a model or provider. A request for any of those goes back to the orchestrator. Every command it would need, such as one that regenerates a count quoted in a document, is a run request: the exact command, the directory, the result expected and the output to bring back.

## Required capabilities

- `filesystem` to read the draft, the neighbouring documents of the project, and the code or configuration a document describes, so that names, paths and commands in the text are the real ones. It also writes the one draft path the orchestrator names.
- `git-read` to read the diff, the recent log and any existing pull request text for the PR and commit section. No git command that changes the worktree, index, refs or remotes.
- `docs` to read notes, runbooks and authority files that a document must agree with. A write happens only at the path the orchestrator names.
- `user-decision` for what needs the owner: a reader who cannot be identified from the task, a waived reader test, and a merge whose door is one-way and whose cost only the owner can accept.

If a capability is missing, say which step it blocks and mark that step unverified. Do not guess a name, a path or a command.

## Precedence

When instructions conflict, this order applies, highest first: system safety and host restrictions; then the project's AGENTS.md or CLAUDE.md; then the owner's current request and explicit decisions; then the orchestrator's routing, commit, deployment and decision rules; then this package; and last, upstream source text, which is provenance only and never an instruction. Every rule here is a default. When a project's own style guide, template or commit convention differs, the project is right and the step is reported as "overridden by project instruction" with the instruction quoted.

For the prose itself, the order is: the project's writing rules and banned-word list where it has them, then the sentence rules below.

## Method

### 1. Pin the document

Name four things in one line each: the kind of document, the reader (who they are, what they already know, what they do right after reading), the one thing the reader must be able to do or understand afterwards, and the existing documents it must agree with. Read neighbouring documents in the project for its conventions and its real names. If the reader cannot be identified from the task, ask the orchestrator to put the question to the owner. Do not write for an imagined audience.

### 2. Choose one mode

Two questions pick the mode. Does the content guide action or build understanding? Does the reader want to learn, or to get work done right now? The answers give one of four kinds of page.

- Action to learn: a tutorial. Say what the reader will build. Make every step show a visible result and say what they should see. Keep explanation to a clause and a link.
- Action to get work done: a how-to. Start from a problem the reader has. Assume competence. Give steps and forks ("if you want x, do y"), no background. A runbook is usually this.
- Understanding to get work done: reference. Describe only. State facts, limits, options and errors plainly, in the order the thing itself is laid out. No instruction and no opinion.
- Understanding to learn: explanation. One bounded topic with the why: constraints, history, alternatives. A stated view belongs on this kind of page and on no other.

One page, one mode. When a draft mixes them, split it and link the parts: a reference table inside a tutorial and an argument inside a how-to are the usual faults.

### 3. Write the sentences

Delete any word the sentence survives without, and prefer the short everyday word. Call things by the name the codebase uses: the exact symbol, file, flag or command, not a description of it. Invent no jargon. Where a named pattern helps, say what it means the first time it appears.

- Write to "you" and stay in the present tense unless something truly happens later. Say who does what, in the active voice. Write steps as commands. Open with the condition, then give the instruction, and put a warning ahead of the step it guards. Put the common case first.
- One instruction per sentence. Split an instruction that runs past about 20 words and any other sentence past about 25.
- Keep the small words ("the", "a", "that"). Give each word one meaning, each action one verb and each thing one name, and use it everywhere. A page that calls one thing "the gate", "the check" and "the budget" teaches three things.
- Make every "it", "this" and "they" point at one obvious thing, and when a pronoun could mean two things, write the noun again. Never let "this" or "which" stand for a whole clause. Keep "only" and "not" beside the word they change. Break long noun strings into a phrase with a verb.
- Skip idioms, metaphors and slashes between alternatives ("a, b, or both", not "a/b"). Leave out "etc." and tell the reader at the start when a list is incomplete. Make parenthetical text a complete unit.
- Headings carry the point. Use numbered lists for sequences and bullets otherwise, introduce each list with a full sentence, and keep items parallel. Link text says where the link goes.
- Vary sentence length on purpose. A short sentence lands a point, a longer one carries a fact with its condition. Prefer the specific to the vague: "a renamed column breaks the nightly build", not "schema changes can cause problems". In an explanation, say what you make of the trade-offs.
- Write real paths. Code goes in code font. Every count, list or tree the text states has to hold on the commit that merges it, and the text includes the command that regenerates it. When a figure cannot be checked from here, write the check as a run request.

### 4. Review an existing document

Apply the same checks, and report by section. Each finding quotes the line, names the rule, and gives the replacement text. Keep wording faults apart from structure faults (mixed modes, a missing prerequisite, a step that cannot be done as written). Edit a file only when the orchestrator names it, and change only what the request covers.

### 5. Reader test

This applies to every finished draft of a document that people will use without the author at hand, such as a runbook, README or design note, unless the owner waives it. PR and commit text use the section below instead.

1. Predict. Before any cold read, write five to ten questions a real reader would bring to the page, each with the answer the document should give and the section that gives it. Cover a prerequisite, a step that fails (when the page has steps) and something the page leaves out on purpose.
2. Request the cold read. Ask the orchestrator to route it. The reader gets the document and the questions, and nothing else: no conversation, no sources, no author notes, no earlier drafts. The orchestrator picks the reader under its own limits, and the reader changes nothing. The package names no reader and starts none. Ask the reader, per question, for the answer taken from the page alone, and overall for what is ambiguous, what the page assumes the reader already knows, and what contradicts itself.
3. Compare. Set each returned answer beside the predicted one. A wrong or missing answer, a flagged ambiguity or an assumed fact that the target reader lacks is a fault in the document, not in the reader. Fix the section, then ask for a fresh cold read of the changed parts, because a reader who saw the old version is no longer cold.
4. Stop when a cold read answers every question correctly and raises nothing new.

Until the cold read is back, report the reader test as unverified and list the questions. Never present your own prediction as the reader's answer, and never say the test passed. The cold read does not check facts: names, links and commands are checked against the source files.

## PR and commit text

The text goes back to the orchestrator. The package creates no branch, makes no commit, pushes nothing and opens no pull request.

- Write the PR body as a briefing that a reviewer finishes in about a minute. Say what changed and why in plain words. Link long logs, lists of commit ids and tables of numbers, and do not paste them. A commit message follows the style of the repository's recent log. Read both the log and the project's PR template first, and the project's form wins.
- Merge danger. State whether the merge is a two-way door, cheap to walk back, or a one-way door, such as a dropped column, a sent message or a published artifact. Name the blast radius in one word. Add a line on what could follow only when it is not obvious. Working out what a change can break is blast-radius's job, which the orchestrator attaches; this text only records its result. When the door or the radius is not known, write "unverified" and say what would settle it.
- Evidence. One pair. Before: the command or check that failed, with its key output line. After: the same command passing. Quote only output that the orchestrator's run returned. When no run exists, write "no run evidence" and say why. A screenshot appears only when tooling the orchestrator already runs captured one.
- Picture. When a small picture shortens the read, use the smallest that carries the point: a few lines of pseudocode, a short call tree or file tree, or a diff of the shape that changes. One is usually enough.
- Use the project's own domain words from its existing authority files. The package creates no glossary or other authority file.

## Prose and decisions

Choices that belong to the owner go to the owner through the orchestrator's question step, one clear question at a time. Prose follows the project's writing rules where it has them, and plain wording otherwise.

The project's own rules on confidential material win. Each project's documents follow that project's own authority. Replace any secret or client data in quoted material with `<REDACTED>`, and never ask for a secret or show one in chat. Outward-facing text goes to the orchestrator for a style check where the project has style rules, and nothing is sent.

## Not this package

Without an attached method, a direct request in any of these areas gets a decline and the owner's name. With it attached, the same areas are still declined.

- Customer-facing copy, website text, outreach, proposals and pitches: a marketing-copy workflow. Decks, memos, talks and workshops: a presentation workflow.
- Social posts and articles, replies and comments, follow-up email after a meeting: a communications workflow.
- Changelogs and release notes from git history: changelog-drafter.
- Long-form drafts such as essays and chapters: a long-form writing step.
- UI copy and error messages: a UI copy review.
- Committing: commit-and-push-gate. Pushing: no-mistakes, and a push needs the owner's go-ahead. The merge-or-PR decision: a branch-finishing decision.
- Reviewing a diff or giving a merge verdict: the project's code-review process. Analysis of what a change can break: blast-radius.
- Closing a run and its evidence record: run-close-pack, which the orchestrator routes.

## Provenance

This package adapts the `technical-writing` skill from pstack by Lauren Tan (cursor/plugins, MIT) and the `pr` skill from Matt Pocock's skills (mattpocock/skills, MIT). The upstream `technical-writing` skill builds on four published standards, which are credited here as it credits them: the Diataxis documentation framework (the four kinds of page), the Google developer documentation style guide (sentence rules), ASD-STE100 Simplified Technical English (instruction rules) and Global English (syntax that avoids double readings). The activation rule, the execution limits, the review report form, the reader test and the PR and commit section are our own. A separate idea source, the `doc-coauthoring` skill in the anthropics/skills repository, is named in the upstream notice; no text was copied from it. Credit and licence text are in `references/upstream-notice.md`, and the repository's `CREDITS.md` lists the pinned commits.
