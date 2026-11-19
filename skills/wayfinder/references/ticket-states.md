# Ticket states

This file describes how an item that comes in is checked and moves through the map. It is read-only map behaviour. It adds no tracker, no label vocabulary and no task tracker field: a ticket's state is read from where it sits in the map and from the lines in its body, and the only writing is the map-note and ticket requests that SKILL.md already allows.

## One state at a time

Every ticket is in exactly one of these states.

| State | Where it shows | What puts it there |
|---|---|---|
| Waiting for an answer | Blockers, with the open question written out | The question says what is missing and who can supply it, the owner or a fact request through the orchestrator |
| Ready for an agent | Frontier | A durable brief is in the ticket body (below) |
| Ready for the owner | Frontier | One line in the body says why it cannot be delegated: a judgment call, access only the owner has, a design choice or a manual test |
| In hand | In hand, with the dated in-hand line from Claiming; never in Frontier | The orchestrator reported the entry moved there with that line written |
| Blocked | Blockers, with the blocking titles | Each named blocker is still open |
| Ruled out | Out of scope, with one line of reason | The owner's ruling. An item that already exists is closed with a pointer to where it lives and gets no Out of scope line, because nothing was rejected |
| Done | Decisions so far | The resolution is recorded with its basis, date and who confirmed it |

If a ticket seems to be in two states at once, for example a Frontier ticket with an unanswered question, or one that is in hand and also blocked, say so to the owner and change nothing until they rule.

## How an item moves

An item the owner hands over, such as an idea, a bug report or a fragment of a plan, becomes a ticket only when its question can be stated sharply. Until then it stays under Not yet specified. After that it moves one step at a time, and each step needs its evidence.

- Into Waiting for an answer: the missing fact or answer is named.
- Out of Waiting: the answer is recorded with its source, and the ticket goes to Frontier or Blockers according to what else gates it.
- Into In hand: the entry moves from Frontier with its in-hand line written, never before.
- Into Done: the resolution is recorded under Decisions so far.
- Into Ruled out: the owner rules, or the item turns out to exist already and is closed with a pointer.

A move that skips a step, such as Waiting straight to Done or Done back to Frontier, is unusual. Say what looks unusual and ask before proposing the change. The owner may override any move; state what would change first.

Nothing here reaches the task tracker, which has no field for these states. If a queryable state would help, that is a change to the tracker and a decision for the owner. The package only mentions it to the orchestrator.

## Before anything is grilled

1. Check that the claim holds. For a bug report, ask for the reproduction through root-cause-diagnosis; any step that runs something is a run request for the orchestrator. For a described change, check that it does what its author says. Report one of three results: confirmed, with the path it takes; failed; or too little detail to try. Too little detail puts the ticket in Waiting for an answer.
2. Look for an existing implementation by concept, not only by the words of the request, and say where you looked. A header comment, a name or a doc line only points at behaviour. It is proof once the implementation is read, or a run result comes back from the orchestrator that shows the behaviour. If neither is in hand, mark the finding unverified, ask the orchestrator for that evidence, and leave the item where it is. If an implementation is confirmed, close the item with a pointer to where it lives, in the ticket if there is one and otherwise in the report. Record nothing as rejected.
3. Read Out of scope and Decisions so far for an earlier ruling on the same thing. If there is one, show it instead of reopening the question.

Questions that remain go through the decision flow set out in SKILL.md.

## Note for a waiting ticket

Write the note in the ticket body, in two parts.

- What is established so far: every point already settled, so that none of it is lost.
- What is still needed: each question specific enough to answer in a line. "Please give more detail" is not a question.

## Durable brief

A ticket that is ready for an agent carries a brief that stays useful for days while the code changes around it.

- Describe the behaviour wanted and what happens now, not the steps to take.
- Name interfaces, types and contracts. Give no file paths and no line numbers, which go stale.
- List acceptance criteria that can each be checked alone, in terms a test or a person could confirm.
- State what is out of scope, so adjacent work is not pulled in.

The brief goes into the ticket body through tickets mode, after the owner approves the exact commands.

## Resuming

When a ticket already has notes, read them first and present the updated picture before going on. Never ask again what has been answered.
