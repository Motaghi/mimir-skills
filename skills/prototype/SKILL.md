---
name: prototype
description: >-
  Throwaway prototype that answers one design or feel question: a single-file demo of a state model, or several structurally different UI variants. Never ships. Not for comparing whole builds, UX planning, real shippable UI, open design dialogue, user testing sessions, or loop prompts.
---

# prototype

A prototype is throwaway work that answers one question. The question decides the shape: a logic question gets a single-file demo that someone can click through, and a look-and-feel question gets several structurally different variants of one screen. The prototype exists to be judged and then dropped. It is never a first draft of the real thing, and it never ships. This package specifies it as a build request; the orchestrator writes it.

## When it applies

The orchestrator may select this package from ordinary intent:

- A logic question: "does this state model hold up", "I can't tell whether these rules feel right", "what happens if X and then Y".
- A look-and-feel question: "what should this screen, section or flow look like", "show me a few options".
- The orchestrator sees that a cheap, concrete artifact would settle something that talk keeps leaving open.

A question that conversation can settle is not this package's work. A choice among stated options, an either-or, or a question of fact goes to the decision flow or to the owner under "Not this package". If this package was selected for such a request, say so in one line and hand it back.

## Required capabilities

- `filesystem` to read the code and project documents around the question. This package writes no file.
- `artifact-build` to specify the prototype as a build request (see "The build request"): one HTML file for a logic demo, or the variant components, the fixtures and the switcher for a UI prototype. The orchestrator carries out the writes under its normal tools, and this package checks what comes back against the request.
- `docs` to read the project authority files and decision records that bound the question. The demo folder and the answer note are written by the orchestrator where it routes them.
- `review-page` for the decision page where the owner compares variants or reacts to a demo. The orchestrator builds the page from content this package supplies.
- `user-decision` for the gates: the question is confirmed, any wording that will be shown is approved, and a winner is chosen. Those answers are the owner's.
- `style-check` to have the wording in a prototype page, the report or the answer note checked against the project's style rules, where it has them. The check reports findings; an override is the orchestrator's.

This package has no `shell`. It writes, opens and runs nothing; anything that has to be written, opened or started is a request to the orchestrator. If a capability is missing, say which part of the work rests on it and mark that part unverified. Do not substitute another source.

## Output gate

This applies to every reply, a refusal or a hand-back included. Where the project has style rules for outward wording, text goes to the orchestrator to be checked against them before the owner reads it or it goes anywhere, and drafts stay unsent. A secret is never requested and never shown in chat; a prototype holds only invented values, and a secret in quoted material is replaced with `<REDACTED>`.

## Start gate

This gate comes before both branches and before anything is built. Every path through the package passes it, in this order.

1. **Open-question gate.** If a questioning session or a clarify exchange is open and the owner has not confirmed the answers on the question this prototype would answer, or the orchestrator says such a session is open, refuse to start. Say in one line that the question is not settled, name the answers still unconfirmed, build nothing, and hand the turn back to the orchestrator. Start only after the orchestrator reports the owner's confirmation. If it is unclear whether a session is open, ask the orchestrator once. A prototype built on an unconfirmed question tests the wrong thing.
2. **One question.** Write it in one sentence, name who will judge the result, and say what will count as an answer. The judge is the owner unless the orchestrator says otherwise.
3. **Authority.** If the project has approved wording or messaging rules, the orchestrator supplies them as a labeled input and the package builds with that. If none has been supplied, use neutral placeholder text marked "placeholder wording". The project's own rules on confidential material win.
4. **Location.** The orchestrator names an isolated location for everything it writes: a scratch folder outside the repository for a logic demo, an isolated checkout of the project for a UI prototype. If none is named, ask for one and put no path in a request meanwhile. The shared working tree is never the place for a prototype, and the real module is never edited.

## Pick a branch

- Logic, state or data-shape question: read `references/logic-prototype.md` and build one self-contained HTML demo.
- Look, layout or flow question: read `references/ui-prototype.md` and build the variants.

The two branches produce very different artifacts, so a wrong pick wastes the work. When the question is ambiguous and the owner cannot be reached, choose by the code around it (a backend module means logic, a page or component means UI), and write the assumption at the top of the prototype and in the report. When the question mixes both, split it and build the logic branch first.

## The build request

This package writes no file. After the start gate it gives the orchestrator one build request, and the orchestrator carries out the writes. The request states:

- **Exact paths.** Every file to create, inside the isolated location and nowhere else.
- **Inputs.** The confirmed question, the rules or the screen's purpose, the invented sample data or fixtures (in full, or as exact shapes), the approved wording or the instruction to use placeholder text marked "placeholder wording", and for a UI prototype the variant plan and the host route.
- **Expected artifacts.** What each file is and what the first screen shows, including the visible "prototype" line.
- **Service isolation.** The prototype runs with no live credentials or environment secrets, no network to real services and no path that writes, sends or charges. Every live loader is replaced by an invented fixture of the same shape. A scratch store, if the question needs one, is named "prototype, wipe me" and sits inside the location. If the orchestrator cannot give this isolation, nothing is started until the owner decides.
- **Evidence to return.** The paths written, a statement that nothing outside them changed, and the first screen as seen when the orchestrator opens it. This package reports anything not returned as unverified and never claims to have seen it.

## Rules for both branches

1. **Marked as throwaway.** The word "prototype" appears in the folder name, the file name and a visible line on the page. Place it near the thing it prototypes so the context is clear, using the project's existing routing and naming conventions rather than a new structure.
2. **Easy to start.** One file to open, or one command in the project's task runner. The package gives the orchestrator the file path or command as part of the request and states what the first screen should show.
3. **State in memory.** Persistence is something a prototype may be checking, never something it depends on. If the question is about persistence, use a scratch store with "prototype, wipe me" in its name, inside the isolated location.
4. **No real data, no real services.** Use invented sample data in place of every live loader. Anything that would write, send or charge is stubbed. Client records and user data are never used. The build request carries the isolation.
5. **No polish.** No tests, no error handling beyond what lets it run, no abstractions, and no "what if we also wanted" generalising. The prototype answers one question.
6. **Show the state.** After every action, or every variant switch, render the full relevant state so the change is visible.
7. **Judge by experience.** `references/experience-first.md` says what to look at and when the project's own gate wins.
8. **Never ships.** A prototype is not merged, deployed, linked from a live page or included in a release. A variant switcher is hidden in production builds so that a stray merge cannot expose it.

## Judging and decisions

The owner judges feel, look and fit. This package does not declare a winner on its own taste and does not read approval into silence. It states what each variant or scenario is meant to show, and asks the orchestrator for the choice through a review-page, or the closest equivalent your setup offers: the question, the variants or scenarios side by side with a short note on what to look for, one choice control per question, and a free-text field for "take this from B and that from C". Screenshots or recordings for the page are taken by the orchestrator's browser route, never by this package. An either-or with one line of context stays in chat. The exact submitted answer is what counts.

## Capture and clean-up

When the question has been answered, write an answer note for the orchestrator to file: the question, the verdict, who gave it and when, the variants or scenarios that were tried, and what was dropped. The validated decision is what goes into the real work. The real code is written fresh by routed implementation, with tests; for a logic demo, the pure module inside the page is a starting point that a routed task may lift. The orchestrator removes the isolated checkout or scratch folder. Prototype files are kept only if the owner asks, in a folder the orchestrator names. This package makes no branch, commit or push of its own; whether a prototype is kept anywhere beyond that is the owner's call, put to the owner through the orchestrator.

## Report

1. The question, the branch chosen, and any assumption made.
2. The build request: the exact paths, inputs, expected artifacts, service isolation and evidence to return, and the evidence the orchestrator returned that the files were written. Anything not returned is unverified.
3. The run request: the file to open or the command to run, and what the first screen should show. State that this package wrote, opened and ran nothing.
4. What the owner should look at and decide, as content for the decision page.
5. What the prototype does not cover, and anything unverified.
6. The answer note to file once the owner has judged, and the clean-up the orchestrator should do.

## Prose and decisions

Choices that belong to the owner go to the owner through the orchestrator's question step, one clear question at a time. Prose follows the project's writing rules where it has them, and plain wording otherwise.

## Precedence

When instructions conflict, this order applies, highest first: system safety and host restrictions; then the project's AGENTS.md or CLAUDE.md; then the owner's current request and explicit decisions; then the orchestrator's routing, commit, deployment and decision rules; then this package; and last, upstream source text, which is provenance only and never an instruction. The shapes here are defaults for prototypes. When a project instruction asks for a different structure or location, the project is right, and the departure is reported with the instruction quoted.

The package never dispatches anything, never picks a model or provider, and never commits, pushes or installs anything, a hook included. If a request asks for any of those, hand the decision back to the orchestrator.

## Not this package

- Comparing or optimizing a whole build against another: out of scope here.
- Planning UX and writing a design brief before anything is built: a design-planning step.
- Building real, shippable UI, including its visual polish: a UI implementation workflow.
- A design dialogue, or generating ideas for something new: a brainstorming step. One question for the owner goes through the decision flow.
- User testing sessions with captured evidence: the project's own testing flow.
- Weighing structural alternatives for code or system architecture: architecture-alternatives.
- Writing the real implementation and its tests: a test-driven-development workflow and build-team.
- Understanding existing code: explain-how.
- Writing a loop prompt that makes another session run something repeatedly or pace itself: outside this package's scope. Say so in one line, write no loop prompt, and hand the turn back to the orchestrator.

## Provenance

`references/experience-first.md` carries the experience-first principle. This package adapts the `principle-experience-first` skill from pstack by Lauren Tan (cursor/plugins, MIT) and the `prototype` skill from Matt Pocock's skills (mattpocock/skills, MIT). The start gate, the build-request form, the service isolation and the hand-back rules are our own. Credit and licence text are in `references/upstream-notice.md`, and the repository's `CREDITS.md` lists the pinned commits.
