# Formal checks (create mode)

Read this file only when a proof-map request names a formal target, for example "a proof map for this service that includes a formal check of its lease logic". A request for formal verification with no proof map behind it is not this package's: the orchestrator routes it.

A test covers the cases someone wrote down. A formal check covers all cases inside a boundary you state: every interleaving of steps in a small model, every input below a size limit, or every input with no limit. In a proof map it is one entry in a Formal checks section, so a later agent can see what is checked, run it and tell whether it still matches the code. The package writes that entry as text. It generates no skill, installs no tool, runs no checker and edits no product code. Model, harness and property files the project would need are proposed text only, and the package never edits them. The map's authority rule covers the map and nothing else. Each such file reaches the orchestrator as a run request: exact path, exact content, inputs, expected result, the evidence to return, and every effect outside the checkout named and isolated, or sent to the owner as a decision. Every run is a run request too.

## Pick the place

Work out the answer from the code, and ask the owner only what the code does not show. If the owner pointed at an area or an incident, begin there. Otherwise look for a guarantee the code gives where failing would hurt users and ordinary tests seldom reach the failing case. Typical homes are lock and lease handling, retries, queues, state machines, parsers, and anything that can run twice by accident. Choose the most damaging guarantee in the repo, even if another would be quicker to check. State the guarantee, and the damage if it breaks, in one plain sentence each.

## Pick the approach from the question

- Could events interleave badly? Model the design at small scale and use a model checker. That works whatever the language.
- Must the code itself behave for all inputs, such as memory safety, integer overflow or an invariant of a data structure? Use a verifier that works on the code.
- Must it hold at every size, where a size limit would hide the problem? That may call for a proof. Explain why a limit is not enough.
- No verifier exists for this language? Say so, and record tests fed with generated inputs that run the real code. Do not model the function by hand instead.

Favour a tool already in the project, or one its developers can install and run themselves, and say why it was picked. If the tool is absent, report that to the orchestrator as a decision for the owner. The package never installs it, and the entry stays unverified until it exists.

## What the entry records

- The guarantee and what it protects, in words someone can follow without knowing the tool.
- Covered code: files and functions a reviewer can open, named as they are in this repo. Anything the check treats as a single atomic step must be a single atomic step in that code.
- Limits: bounds, assumptions and omissions. A pass speaks for the model within its bounds, not for the whole system.
- Tool, version, and one run command quick enough to use on every relevant change.
- Sync commit: the last commit where a run showed the check still matches the covered code, whether it passed or failed on a counterexample the code really allows. Advance it only after such a run.

## Show that it can fail

A check nobody has seen fail has told you nothing yet. Once the check has passed on the unchanged code, write, for each property, a run request for a deliberate temporary break in an isolated checkout, such as deleting a guard or swapping two steps in the covered code. Give the exact command, the expected result (the check fails), the output to return and the cleanup. Cleanup removes the break and shows the check back in its starting state: passing, or failing only on findings already reported. Name any effect outside the checkout, such as files the tool writes elsewhere. If the check does not notice the break, or a step will not run, repair the entry or the model and leave the break alone. Until this evidence returns, the entry is `unproven`. While no tool is chosen or no passing run exists, the entry holds the break request as a draft that names what it will do, with its command marked unverified, and asks the orchestrator for the missing input; no command is invented, and the request is issued only after a passing run.

## Findings stay findings

If the code as it stands violates the property, report that as a finding: the counterexample told as a few steps in the code's own terms, and the damage in a sentence. Never loosen the property or reshape the model to get a pass, and never edit product code. A fix is a separate request that the orchestrator routes.

## Hand back

Add to the report what was checked, which tool and why, the limits, the results, the run command, the gaps, and any tool decision waiting on the owner. Mention a second candidate only if one came up while reading.
