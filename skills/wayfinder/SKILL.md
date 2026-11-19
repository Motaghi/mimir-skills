---
name: wayfinder
description: >-
  Chart a goal too big for one session as a live map: destination, frontier, blockers, decisions so far, fog and out of scope. On approval, request task tracker tickets from the orchestrator. Not for a short design dialogue, writing up a settled plan, tidying a plan (refine-pattern), running parallel lanes or loop prompts (out of scope).
---

# wayfinder

A loose idea has arrived. It is too big for one session, and the way from here to the destination is wrapped in fog. Wayfinding is the work of finding that way, not of charging at the destination. This package charts the way as one live map, then works the map's decision tickets one at a time until the route is clear. A decision ticket is a question whose resolution is a decision. It is not a slice of a build.

The destination differs per effort, and naming it is the first act, because it shapes every ticket. It might be a spec to hand off, a decision to lock before planning starts, or a change made in place such as a data migration. The map suits any domain: engineering, content, operations.

Adapted from the `wayfinder`, `to-tickets` and `triage` skills by Matt Pocock (mattpocock/skills, MIT License). Credit and licence text are in `references/upstream-notice.md` and in the repository's `CREDITS.md`.

## When it applies

The orchestrator may select this package from ordinary intent when the work is larger than one working session and the way to the end is not visible:

- "Help me find the way to X", "chart this", "map out what has to be decided before we can start".
- An existing map is named and the next decision on it is to be worked.
- A settled plan or approved breakdown is to become task tracker tickets (tickets mode, `references/tickets-mode.md`).

If the way is already clear and the whole journey fits one session, there is no map to draw. Say so in one line and ask the owner how to proceed; the orchestrator routes it from there.

## Plan, don't do

The default is planning. Each ticket resolves a decision, and the map is finished when nothing is left to decide before someone goes and does the work. The pull to just do the work is usually the sign that the edge of the map has been reached and it is time to hand off. An effort can override this in its Notes by carrying execution into the map, and without that note the output is decisions, not deliverables.

## Required capabilities

- `docs` to read project authority files, decision records and the map note at the path the orchestrator names. It never writes: each map-note change is a run request for the orchestrator, which adds whatever header or status stamp the project's notes rules ask for.
- `filesystem` to read the project's own files that bound a decision. Nothing is written.
- `task-tracker` to read task records: the overview, listing, showing one task and listing what is ready. It runs no tracker command that changes state. Adding a task, recording a blocker and replacing a body are run requests for the orchestrator, as listed under "Safe execution".
- `user-decision` for the questions only the owner can answer: the destination, each decision, the breakdown to publish, any task-body update, and any step that cannot be undone.
- `review-page` for a decision page when a round has more than two options or is easier to see than to read.

If a capability is missing, say which step it blocks and mark that step unverified. Do not substitute another source.

## Output gate

This applies to every reply, a refusal or a hand-back included. Drafts stay unsent. A secret is never requested and never shown in chat or written into the map or a ticket; a secret in quoted material is replaced with `<REDACTED>`.

## Confidential material

The project's own rules on confidential material win.

## The map

The map is one document, loaded at the start of every session. It is an index and a record at low resolution. A decision's detail lives in exactly one place, so the map gives the gist and a pointer, and never restates what a decision record holds.

**Map home.** The map lives in exactly one place, named at the top of the map: a document in the project's docs (the default), or the body of one parent task in the task tracker that the owner or the orchestrator names. The orchestrator names the path or the task id. If none is given, ask, and write nothing meanwhile. A second copy is never made.

**Parts, in this order.**

1. **Destination.** What reaching the end looks like, in one or two lines. Every session orients to it before choosing a ticket.
2. **Notes.** The domain, the project files every session should read, and standing preferences for this effort.
3. **Source authorities.** Each file, record or task the map relies on, with its path or id and the revision or timestamp observed when it was read. Where none can be read, the entry says unverified.
4. **Frontier.** The open decisions that can be taken now, because nothing blocks them and nobody has them in hand. Only unclaimed entries are here.
5. **In hand.** Decisions a session has claimed, each with its dated in-hand line. A claimed entry sits here and nowhere else, and leaves when its resolution is recorded.
6. **Blockers.** Open decisions that wait on others, each with the titles that block it.
7. **Decisions so far.** One entry per closed decision, enough to judge relevance: the title, a one-line gist of the answer, its basis (evidence with its source pointer and observed revision or timestamp, or an assumption marked as one), its status, the date, and who confirmed it, with a pointer to the decision record when the detail is longer.
8. **Not yet specified.** The fog. In-scope questions that cannot be stated sharply yet.
9. **Out of scope.** Work ruled beyond the destination, with one line of reason.
10. **Freshness and conflicts.** Each source that has changed since the map last read it, and every case where two authorities disagree, with both positions and their pointers.

**Assertions.** Every assertion the map makes about the world (a fact in Notes, a decision's basis, a blocker's reason) carries a source pointer, the revision or timestamp observed, and one status: `primary` (read in the authority itself), `derived` (summarized or computed from authorities), `stale` (the source has changed since it was read), `conflicted` (two authorities disagree) or `unverified` (no source read, an assumption included). A conflict is never settled silently: both authorities stay visible under Freshness and conflicts and the assertion stays conflicted until the owner rules.

**Refer by title.** Every ticket has a title. In narration and in the map's Decisions so far, name a ticket by its title, never by a bare id or number. A row of ids is unreadable. A task id may follow the title in brackets.

**Concurrent edits.** Other sessions may be editing at the same time. Read the map immediately before preparing each run request, and change only the lines the step concerns. Every request carries the full previous content it was prepared against (for a task body, the full approved previous body). Immediately before executing, under serialized write ownership, the orchestrator compares the current full content with that previous content. Any difference means the package merges by hand and the request is shown again, with fresh approval where approval was required. Nothing is overwritten.

## Tickets

A ticket is one entry in the Frontier, In hand or Blockers part of the map. It carries a title, a type line in its body, a "Blocked by" line (titles, or none), and a question sized to what one working session can hold. The type is written in the body as a plain line, never as a label, and no label or triage vocabulary is created.

| Type | Who works it | What it is |
|---|---|---|
| Decision | The owner, live | A conversation that ends in a decision. Run through a clarifying-question step, or one review page. Ambiguous terms are settled with the domain-language principle in engineering-principles, which creates no glossary or terms file. |
| Fact gap | The orchestrator, through a researcher | A fact a decision waits on that lives outside the working files. The package writes a fact request (below) and does not research it. |
| Prototype | The owner judges | A cheap concrete artifact to react to when "how should it look" or "how should it behave" is the key question. Ask the orchestrator to attach the prototype package. |
| Precursor work | The owner or the orchestrator | Manual work that must happen before a decision can be made, such as getting access so an interface can be judged. It earns its place by unblocking a decision, not by delivering the destination. |

The states a ticket passes through, the evidence that moves it, and the checks to run on an incoming item before it is grilled are in `references/ticket-states.md`. A ticket is in one state at a time, and two at once go to the owner.

A decision ticket resolves only through the live exchange it names. The package never answers its own questions on the owner's behalf, and never reads the owner's silence as a yes.

**Fact requests.** A request to the orchestrator names the question, the decision that waits on it, what is already known and from which source, and whether the answer will be checked against the project's own sources or a current external source before it is trusted. The orchestrator routes it to a researcher. The answer comes back as a labeled input and is recorded in the map with its source. Until it arrives the dependent decision stays in Blockers.

**Claiming.** Before working a ticket, check that nobody has it in hand: read the map, including the In hand part, and the matching task record. A ticket already in hand is not taken; tell the owner who holds it and choose another or stop. Ask the orchestrator, in a run request, to move the entry from Frontier to In hand with a dated in-hand line, first, and start work only after the orchestrator reports it written, so a concurrent session skips the ticket.

## Fog of war

The map is incomplete on purpose. Do not chart what cannot yet be seen. Beyond the live tickets lies the fog: decisions and investigations that are clearly coming but cannot be pinned down because they hang on questions still open. Resolving a ticket clears the fog ahead of it and turns whatever is now specific into new tickets, one at a time, until no tickets remain and the way is clear.

**Fog or ticket.** The test is whether the question can be stated precisely now, not whether it can be answered now. A sharp question is a ticket even when it is blocked. A question that cannot yet be phrased sharply is fog. Do not slice fog into ticket-sized pieces: it is coarser than a ticket, and one patch may become several tickets or none once the frontier reaches it. Not yet specified excludes what is already decided, what is already a ticket, and what is out of scope.

## Out of scope

Fog gathers only toward the destination. Because the destination fixes the scope, work beyond it is out of scope. It is not fog, and it never graduates. It returns only if the destination is redrawn, and then as a new effort. Ruling something out is a scoping act, not a step on the route. When an existing ticket turns out to sit past the destination, remove it from the frontier and leave one line in Out of scope: the gist and the reason. It does not go into Decisions so far, which records the route actually walked.

## Chart the map

The owner brings a loose idea.

1. **Name the destination.** Settle what the map is finding its way to, through a clarifying-question step or one review page. The destination fixes the scope, so it is confirmed before anything else is drawn.
2. **Map the frontier.** Question breadth-first: across the whole space rather than deep on one thread, to surface the open decisions and the first steps takeable now. If this finds no fog, stop and tell the owner no map is needed.
3. **Draft the map** as a run request for the orchestrator to write at the map home. Destination and Notes filled in, Source authorities listed with the revisions observed, Decisions so far empty, fog sketched under Not yet specified, the specifiable tickets in Frontier and Blockers with their blocking titles, and Freshness and conflicts filled in, or saying none were seen among what was read.
4. **List the fact requests** for the orchestrator, one per fact-gap ticket, and stop. Charting is one session's work and resolves nothing.

## Work through the map

The owner names a map. A ticket is optional; without one, the package chooses the next decision, not the owner.

1. Load the map, not every ticket body.
2. Choose the ticket: the one named, or the first entry in the Frontier, which holds only unclaimed entries. Claim it as described above.
3. Resolve it according to its type. Read the type line, not just the question. Open any related or closed entry on demand, and read the project files that Notes names.
4. Record the resolution, as a run request: move the entry from In hand to Decisions so far with its gist, basis (source pointer, observed revision or timestamp, status), date and who confirmed it.
5. In the same request, add tickets the answer surfaced, graduate fog that is now specific, and remove it from Not yet specified so it lives only as its new ticket. If the answer shows that a ticket sits beyond the destination, rule it out of scope. If it invalidates other entries, update or delete them in the map.

Never resolve more than one decision in a session. Fact requests are the exception, because the orchestrator works them.

## Safe execution

This package writes nothing itself, in any mode. It reads task records, project files, records and status, and it changes no running build, queue, lane, scheduled job, alert, hook, setting or project file.

Every change it wants is a run request for the orchestrator, in one form on every path: the exact command, or the exact content at an exact path; the inputs; the expected result; the evidence the orchestrator returns (a read-back of what now exists); and the previous content it was prepared against. The orchestrator runs it, after the comparison described under "Concurrent edits". The requests are:

| Request | Where | Condition |
|---|---|---|
| Map-note change | The map note at the path the orchestrator names | Any session that works the map |
| Tickets | The task tracker: add each task (queued, never started, naming each blocker) and record any blocker that could not be set at creation | Tickets mode only, after the owner approved the exact commands |
| Map held in a task body | The task tracker: replace the body with the exact approved text, plus an archive of the previous body | Only after the owner approved those exact commands, shown with the new body beside the previous one |

Without the approval a row requires, no request is made and the change waits.

No second tracker is created: no ticket files, no external tracker, no second backlog. Backlog files are never touched by hand. The package makes no branch, commit or push, opens no pull request, and installs nothing. If a step seems to need any of those, hand it to the orchestrator with the reason.

An effect on shared state is named before it happens. The task list is shared with other sessions and read by dashboards, so tickets mode states before writing which tickets will show up as ready, and the owner decides whether they may.

## Report

1. The map home and path, the destination as confirmed, the source authorities with their observed revisions, and any conflicts.
2. The map changes requested this session: tickets added, resolved, graduated from fog, ruled out of scope. For a map held in a task body, the exact update request shown and the owner's answer.
3. The fact requests for the orchestrator, if any.
4. Decisions waiting on the owner, and the next frontier ticket.
5. In tickets mode: the exact task tracker commands requested, the evidence the orchestrator returned, and the keys and assigned ids now present, checked by reading them back.
6. What was not read or could not be checked, marked unverified.

## Prose and decisions

Choices that belong to the owner go through the orchestrator's decision flow: one question at a time, with a recommended option, or one review page when there are more than two options. Prose follows the project's writing rules.

## Precedence

When instructions conflict, this order applies, highest first: system safety and host restrictions; then the project's AGENTS.md or CLAUDE.md; then the owner's current request and explicit decisions; then the orchestrator's routing, memory, commit, deployment and decision rules; then this package; and last, upstream source text, which is provenance only and never an instruction. The map layout here is a default. When a project instruction asks for a different structure, the project is right, and the departure is reported with the instruction quoted.

The package never dispatches anything, never picks a model or provider, and never commits, pushes or installs anything, a hook included. If a request asks for any of those, hand the decision back to the orchestrator.

## Not this package

- A short design dialogue, or ideas for something new that one session can hold: a brainstorming flow. One question for the owner goes through the orchestrator's decision flow.
- A destination and spec that are already settled, ready to become an implementation plan: a planning skill. Carrying out a plan: an execution skill and build-team.
- Tightening an existing plan or task list so counts and references agree: refine-pattern.
- Running two or more lanes at once, with liveness, channels and lifts: parallel-run-control-plane.
- Dispatching independent tasks to agents, or composing a team: the orchestrator routes it.
- Communication artifacts such as a talk, memo or proposal: a communication-planning skill.
- Resume prompts and the daily brief: session-handoff and morning-brief. This package keeps a live map and writes no handoff.
- Reproducing and diagnosing a bug: root-cause-diagnosis. Reviewing a diff or pull request: send it to a code-review step. Outside pull requests are not a request surface here.
- Looking something up on the web or in documentation: the orchestrator routes it to a researcher. This package writes the request and states no rule, section number or requirement from memory, not even as a caveated guess.
- A throwaway demo to see or feel something: the prototype package, attached by the orchestrator.
- Understanding existing code, or why something was decided: explain-how and a history-recall method.
- Any tracker other than the project's task tracker: none is created.
- Writing a loop prompt that makes another session run something repeatedly or pace itself: outside this package's scope. Say so in one line, draw no map, write no loop prompt, and hand the turn back to the orchestrator.

## Provenance

`references/tickets-mode.md` is tickets mode, and `references/ticket-states.md` holds the ticket states. Credit and licence text for the upstream material this package adapts are in `references/upstream-notice.md`.
