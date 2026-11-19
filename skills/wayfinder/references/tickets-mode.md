# Tickets mode

The "Safe execution" section of SKILL.md applies first. Tickets mode turns a settled plan, a spec, a conversation, or the route a map has cleared into tickets in the task tracker: tracer-bullet slices, each naming the tickets that block it. It is active with this package and runs under the limits below. The package writes nothing itself: every task it adds and every blocker it records is a run request for the orchestrator. It creates no second tracker, no ticket files and no second backlog.

## Entry conditions

All three must hold, otherwise stop and say which is missing:

1. A source exists: a plan, a spec, the conversation so far, or a map whose destination is confirmed and whose route decisions are in Decisions so far.
2. The owner asked for tickets, or approved turning the frontier into tickets.
3. A key prefix is known for this effort, from the map or from the orchestrator, so that every ticket this mode creates is recognizable and findable together.

## What the tracker must provide

This mode needs four things from the task tracker: add a task that stays queued and is not started; show or search tasks; name each blocker, at creation or afterwards; and find a task again by its key. Each ticket has an approved key: the effort's prefix plus short plain words. Where the tracker accepts a chosen id, the key is the id. Where the tracker assigns its own ids, the key is written as the first line of the body (`Key: <key>`), the tracker's id is recorded next to the key after creation, and blockers name tasks by those assigned ids. If the tracker cannot do one of the four, stop before the quiz, say which is missing, and create nothing.

## What this mode may run and request

The package itself runs only reads: the task tracker's overview, listing, showing one task and listing what is ready. Writing is limited to two operations, requested from the orchestrator only after the approval in step 5:

- add a task, always queued, never started, naming each blocker;
- record a blocker, for an edge that could not be set at creation.

It requests no other writing operation: no start, finish, reopen, remove, move, prune, hold or render, and no edit of any task it did not create. A map held in a task body goes through the body-replacement request in SKILL.md, after the owner approves the exact commands. Apart from that one approved body update of the task that holds the canonical map, this mode never modifies the source task or a parent task, and it never closes either. Backlog files are never edited by hand.

## Process

### 1. Gather context

Read the source in full, with any comments or notes attached to it. If the source is a task, show it in full. Read the project authority files and decision records for the area, so that ticket titles use the project's own words and respect the decisions already made.

### 2. Look at the code, read-only

If the current state of the code has not been looked at, look at it, to see what the slices must cross. Where a small preparatory change would make the real change easy, make that its own first ticket: make the change easy, then make the easy change.

### 3. Draft vertical slices

Each ticket is a narrow but complete path through every layer the work touches (data, interface, behavior, checks), not a horizontal slice of one layer. A finished ticket can be shown or verified on its own. Each one fits in one fresh working session. Preparatory work comes first.

Each ticket names the tickets that block it. A ticket with no blockers can start at once.

**Wide refactors are the exception to vertical slicing.** A wide refactor is one mechanical change, such as renaming a column or retyping a shared symbol, whose reach crosses the whole codebase, so a single edit breaks thousands of call sites and no slice can stay green alone. Sequence it as expand, migrate, contract:

- Expand: add the new form beside the old one, so nothing breaks.
- Migrate: move the call sites over in batches sized by how far each reaches (per package, per directory). Each batch is its own ticket, blocked by the expand ticket, and the old form keeps the build green between batches.
- Contract: remove the old form once no caller is left, in a ticket blocked by every batch.

When even the batches cannot stay green on their own, keep the sequence and add one final integrate-and-verify ticket that every batch blocks. Green is promised only there, and where the batches are combined is for the orchestrator to decide.

### 4. Check what already exists

Before the quiz, read the task list. For each proposed key, look for it: show the id where the tracker accepts chosen ids, otherwise search for the `Key:` line. A key follows the tracker's naming rule, starts with the effort's prefix, and has not been used. A used key is never reused or overwritten; choose another. Keep titles short and plain.

### 5. Quiz the owner and get approval

Present the breakdown as a numbered list. For each ticket give the title, the key, what blocks it, and what it delivers as end-to-end behavior from the user's side. Put one to three checkable acceptance lines in the body. Then ask:

- Does the granularity feel right, too coarse or too fine?
- Does each ticket depend only on tickets that really gate it?
- Should any be merged or split?

Also name the effect on shared state: which tickets have no blockers and will therefore appear in the tracker's ready list, and whether anything else acts on that list. The owner decides whether they may appear. The owner also sets a priority if the tracker has one, and the kind is the tracker's default kind unless the orchestrator names another. With more than two options, or a structure easier to see than to read, use one review page. Iterate until the owner approves, and show the final list as the exact commands, blockers first, before anything is run. Each command carries the complete payload: key (and the id where the tracker accepts one), title, kind, body, blockers and priority, with the expected state queued. Approval of the list is approval of those commands and no others.

A body for a ticket that is ready for an agent follows the durable-brief rules in `ticket-states.md`. Ticket bodies avoid file paths and code snippets, which go stale. The exception is a snippet from a prototype that states a decision more precisely than prose can, such as a state machine, a schema or a type shape. Inline only the decision-bearing part and say it came from a prototype.

### 6. Request the writes, one ticket at a time

In dependency order, so each blocker exists before the ticket that names it, hand the orchestrator one run request per ticket: the approved command exactly as shown, its inputs, the expected state queued, and the evidence to return (the tracker's show output taken immediately before and after the write). Each request tells the orchestrator to do this in order:

1. Look for the key immediately before the write, because other sessions edit the same list.
2. If the key is free, add the task with the approved key (as the id, or as the `Key:` line), title, kind, body, blockers and priority. Nothing else.
3. If the key exists, compare everything the show reports with the complete approved payload and expected state: title, kind, body, priority, blockers, and that the task is still queued and not started. Only an exact match counts as done, and then move on. Any difference is a clash, however small, and so is a task that was started, finished or moved. For a clash, write nothing for that ticket or for any ticket it blocks, return each field that differs, and the package asks the owner for a new id. Tickets that do not depend on the clashing one may proceed in order. Never overwrite, update or remove the task that is there.

Do not use the start flag, a pull request link or a report link. Do not mint keys; use the approved ones. Where the tracker assigns ids, report each assigned id next to its key.

### 7. Read back

List, show and list what is ready, to confirm what is now on the list matches the approved breakdown: keys and assigned ids, titles, kinds, bodies, priorities, blockers, states, what is ready. Report any difference. Do not repair a difference by removing anything.

### 8. If something fails midway

The orchestrator stops and returns which keys exist, which do not and which command failed with its message. Do not retry blindly and do not request removal of tickets. The orchestrator and the owner decide the repair. Requesting the same approved list again is safe, because step 6 skips only keys already present with the complete approved payload and state, and stops at any difference.

## Frontier

The frontier is every ticket whose blockers are all done. For a straight chain that is the top ticket. Working the tickets is not this package's job: the orchestrator routes the work after the tickets exist.

## Client and project care

Tickets sit on a list that other sessions and dashboards read. The project's own rules on confidential material win.

## Not allowed in any case

- Triage labels, status labels or any label vocabulary.
- Local ticket files, a scratch folder of tickets, or an external tracker.
- A branch, commit, push or pull request.
- A host tool call to run a configuration or installation command.
