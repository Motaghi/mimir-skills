---
name: parallel-run-control-plane
description: >-
  Rules for a build that runs two or more lanes at once: liveness, one
  append-only channel, two-gate lifts, pins before the decisive suite, one
  resource contract, stops and freezes, capacity as a scheduling input, and
  one decision round at a time. Loads the moment a second lane opens, at
  kickoff or mid-run. Names roles by function only; hosts and providers live
  in a profile (see profiles/example.md).
---

# parallel-run-control-plane

## Authority order
The user's current instructions, the project's own rules, and the accepted kickoff outrank this skill. Hard stops and no-retry rules win over completion pressure.

## Trigger
Loads the moment a second lane opens, whether at kickoff or mid-run. A single lane with an outer watch does not load it. A run that declared single-lane and later opens a second lane loads this skill then and posts the change on the channel.

## Profile
Your own profile is `parallel-run-control-plane.profile.md` in the project root; if it is not there, ask the user where it is. Setup-specific values (where the channel and the evidence store live, the liveness threshold, the worker cap, the load threshold, the report interval, the fallback list, how a monitor is armed on your tools, and how quota exhaustion shows up) are in a profile. `profiles/example.md` lists the fields with a worked example for an invented project. A run without a profile states each of those values at kickoff and posts them on the channel.

## Shared base: capacity and evidence
Both this skill and run-close-pack apply this section.
- Capacity: every role has a ranked fallback list of providers or accounts agreed before the run, never a single fallback. A fallback is used only if it is an authorised route for that work and within the provider's usage terms and limits; a route that is not authorised or would exceed those terms is not a fallback. Quota exhaustion is a planned handover: the affected session posts it if it still can; the orchestrator treats silence past the liveness threshold plus the provider signal named in the profile as the same event. With no fallback left the default is pause and post; the run never continues silently on a reduced roster. A planned handover uses the replacement mechanics of rule 1: a fresh session in a fresh working copy, resumed from the frozen tip and the channel.
- Evidence: a channel line is a pointer, never the record. Anything that decides a lift, a verdict, or a close is a saved artifact at a stable path in the durable evidence store, and the channel line names that path. The channel's path and retention rule are in the profile.
- Owner unreachable: freeze at the last verified state and post the question. Nothing ships on an assumed answer.

## Roles, by function
Orchestrator (rules, owner relay, go decisions); coordinator (dispatch, merges, report points); lanes (code, each in its own isolated working copy); reviewers (never the author, fresh working copy, restated evidence on resume); outer watch (verifies every merge in a clean checkout, holds the final line); owner (rulings only).

## Definitions
- Lift: the orchestrator's permission for a lane's work to merge.
- Reviewer clean: no open blocker or major, every finding answered with a line reference.
- Observed evidence: the change seen in the running product where it is visible, recorded as a file in the evidence store.
- Decisive suite: the project's end-to-end suite run once on the tested tip under the resource contract; its classified list is the record.
- Go decision: the orchestrator's posted line that a gated step may start.
- Load threshold, report interval, and worker cap: profile fields (the same fields run-close-pack reads); a run without a profile states all three at kickoff.

## Rules
1. Liveness. Every session arms a persistent monitor or an equivalent long-lived shell task as its first act and on every resume. A role is dead when all three hold: no live process for its working copy, no new channel stamp past the profile's threshold, and no FROZEN marker as the first word after the stamp on its latest line. Confirm with `<skill-dir>/scripts/liveness-check.sh <channel> <threshold> ROLE=<working-copy> ...`. The process check looks at command lines and, where `lsof` exists, working directories; a count of 0 is a hint, not proof, so confirm by process id with whoever launched the session before replacing it. Dead roles are replaced, not nudged. Interrupted steps re-run from the start. A resumed reviewer restates its evidence before continuing.
2. Channel. One append-only file written only through `<skill-dir>/scripts/channel-append.sh`, which takes a lock, adds the role prefix and a full date-and-time stamp (`YYYY-MM-DDTHH:MM`), refuses a line that already starts with a bullet or a role prefix, and refuses to write after an edit that changed or removed sealed bytes. ROLE may hold only letters, digits, dot, underscore and hyphen. If a lock is left behind by a process that no longer runs, the helper exits 4 and names it; remove it by hand once no writer is active. A hand-appended line is not caught by the seal, so at close the orchestrator scans the channel for lines that do not carry a role prefix and a full stamp (the line shape `liveness-check.sh` reads) and records each one as a violation in the evidence store. After a refusal the orchestrator posts the refusal, saves the diff in the evidence store, and removes the seal file so the next append reseals. Corrections are new lines. Report points at the report interval carry measured pace and derived projections. The channel is authoritative; any other copy of a ruling is diffed against it before close.
3. Lifts. Two gates: reviewer clean and observed evidence. The expected red set is stated against the merge order before the decisive suite starts, one red per line as `<spec-basename> :<line>`, and reconciled with `<skill-dir>/scripts/red-set-reconcile.sh <expected> <classified-list>` (a malformed entry makes it exit 2 before comparing). A block on disclosure alone is reconciled, not stopped. The coordinator confirms the set is stated before scheduling the suite; a suite run without one is rerun.
4. Pins before the decisive suite. A change that moves a shipped default, a route, a menu path, or a starting state corrects every test pin, fixture, and visual spec that assumed the old value, in the same lane, before asking for a lift. The coordinator checks this before scheduling the suite. A stale pin found during the suite is a lane defect with its own category in the classified list.
5. Load and resources. One contract shared with run-close-pack: the decisive suite runs in its own isolated working copy; non-browser battery chunks may run beside it under the worker cap (the profile field, or the value stated at kickoff for a run without a profile); every step that opens a browser or binds the suite's ports waits. Load-class failures get one lone quiet rerun below the load threshold. Coordinators withdraw duplicate checks only when an independent clean-checkout check covers the same thing.
6. Stops. Lanes freeze at their stop and post a FROZEN marker. They extend only by a documented queue wait and never unfreeze themselves. Every later line from a frozen lane starts with FROZEN until the orchestrator posts the lift, because the liveness check reads only the latest line. The orchestrator may grant a bounded delta with the frozen tip as fallback; the frozen tip's review completes before the delta's review starts. The critical-path lane holds lock priority over side lanes.
7. Decision surface. One round of owner questions at a time, never over an open round, none on an unverified premise. One question is a chat message. A need that arises during an open round waits for that round to close. Rulings are recorded verbatim on the channel and in the round's archive; the channel wins on conflict.

## Host adapters
This skill names no host or provider. Reaper timings, surviving monitor primitives, wakeup behaviour, and quota signals differ between agent hosts; write them down once in your profile (or a runbook the profile points to) and keep that table current.

## Checks
`<skill-dir>/scripts/channel-append.sh`, `<skill-dir>/scripts/liveness-check.sh`, `<skill-dir>/scripts/red-set-reconcile.sh`; tests under `<skill-dir>/scripts/tests/run.sh`. `<skill-dir>` is the folder that holds this `SKILL.md`, resolved to an absolute path from where the skill is installed; run the helpers by that absolute path. POSIX shell, no provider or host calls.

## Why these rules
A watcher that rebuilds each merge in a clean checkout catches what the lanes' own runs miss. Taking one decision round at a time with verbatim rulings avoids lost or contradictory answers. Agreeing capacity and fallbacks before the run turns a quota outage into a handover instead of a stall. Correcting every pin in the same lane that moves a default keeps stale tests out of the decisive suite.
