# Closing step: look sideways for the same mistake

This file is read together with `SKILL.md` after a fix. It is the last step of the loop and short on purpose. This is no security scan, and no way to discover bugs from nothing.

## Gate

Both of these must hold before anything below runs:

- the routed work has fixed the underlying cause and reports the original reproduction green;
- that cause is written as one sentence that a reader can check against the code.

A request to look for more of the same after a fix only counts if both hold. If the cause is known but unfixed, finish the diagnosis. If no bug is in hand, the request is discovery or understanding, and it belongs to explain-how or to whoever owns the audit. Nothing here runs for it.

## Scope

The default is one narrow search, run once, through the code search the host already provides. No tool is installed or named, and no scanner rules are written. Anything wider, such as several searches side by side or a loop that repeats until it finds nothing new, is the orchestrator routing under its slot limits and needs the owner's explicit opt-in through `user-decision`. This package never starts agents itself.

## Working order

1. Name the mistake in general terms. Drop everything that belongs only to the place where the bug was found, and keep three things: the rule that was broken, the condition that made it break, and the kind of code that does it. For example, "a job reads a whole day's log into memory before it filters" is the mistake. "the nightly report job ran out of memory" is the incident.
2. Guess where a second copy would come from before searching, because the source predicts the location. A block that was pasted into a sibling job sits in sibling files. A helper that invites the wrong call sits at all its callers. A repair applied at one site leaves the other sites of the same call. A habit shows up in code written in the same period or by the same hand.
3. Prove the search on the known case. The fix has probably removed the faulty code, so take the original from a captured snippet of it or from the revision before the fix, which `git-read` can show. Write the narrowest search that finds the original site there and run it against that snippet or revision. If it misses, the cause was misread: go back to the loop in `SKILL.md`. A search that cannot find its own origin has no authority over other code. Once it is proven, run it against the current tree. The repaired site is not expected to match any more, and a match on it would itself be a finding.
4. Loosen the search in single moves. Each run changes one part of the pattern (a name, a literal, an argument position, the surrounding structure), and every new hit is read before the next change. Search from the repository root, because copies rarely stay in the folder of the original. Beyond the literal form, look at these neighbours: other names that do the same job (confirm each exists before counting it), the same mistake written another way, and boundary inputs such as empty, zero and missing values. Back off one move when most of the new hits are irrelevant, and try a different part of the pattern rather than loosening further.
5. Try to clear each hit. Read the function around it, its callers and the types involved. A hit is cleared only by something you can point to: a check earlier on the path, a type that excludes the bad value, or callers that cannot send it. Code that nothing calls yet is not cleared by that fact alone. Keep it, with a lower priority and a note of what would start calling it.
6. Give each hit one verdict: real, cleared with the reason, or unclear. State the likely impact and your confidence in it as two separate statements, and keep minor hits in the list, because the orchestrator decides what to drop.

## Report

The result goes back to the orchestrator as a working report. The orchestrator files it as an open report in the project's docs. This package writes nothing into a project repository. The report holds the mistake from step 1, the proving search and its single hit in the pre-fix snippet or revision, each loosening with its hit count and what it taught, the real hits with location, impact and confidence, the cleared hits with their reasons, and the searches that produced only noise.

Finding no further instance is a valid result. Say so, and list the patterns tried so the claim has visible limits.

## Fixes and prevention

Fixing further instances is routed work, with the same red-first discipline as the first fix. A check that would catch the mistake in future, such as a test, a lint rule or a build check, is a proposal. Report it, and the orchestrator files it. This package writes no file and installs no hook, lint rule or build job.
