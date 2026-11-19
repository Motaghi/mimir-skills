# Explain the number

## Rule

Before you trust, report or act on a number you measured, such as a speedup, a regression, a throughput, a latency or an eval result, do three things. Name the limiter that bounds it. Rule out what else the number could be measuring. Keep the run count and the spread with the number wherever it is written down.

A figure about an artifact is held to a simpler rule. Before you quote a size, effort, count or duration for a draft or any other artifact, measure the artifact itself and give the measured figure with how it was measured. An estimate is labeled as one.

## Why

A measured number looks like a fact, and it is only the output of one setup. If the load generator was the slowest part, the number describes the generator. If half the runs failed early, the number describes the failures. A figure that nobody can explain gets repeated, reused in decisions and defended long after the setup that produced it is gone.

## Checks

For each check, cite the profile, the counter capture, the log or the artifact that shows the answer. A check with no citation is reported as unverified. Reading the code and reasoning about it is not evidence for check 1.

1. Limiter: ask "why not double?" Is the resource or code path that bounds the result named (a core, a lock, the disk, the network, or the load generator itself) from a profile or system counters taken during a run, and mapped back to the code? No profile or counters means unverified. If you cannot say why the number is not twice as good, you do not yet know what you measured.
2. Alternatives: is each alternative reading of the number ruled out with cited evidence? The usual candidates are errors, work that was skipped or served from a cache, code that never ran, a side left on default settings while the other side was tuned, noise, and a changed piece that is too small to matter end to end. An alternative with no evidence is unverified, and one that the evidence supports means the number does not measure what it was taken to measure.
3. Evidence kept with the number: are the run count, the spread (for example the minimum and maximum, or the standard deviation) and the limiter written next to the number, or in an artifact it links to? A number with no run count or no spread is reported as unverified and is not quoted as a result.
4. Size sanity: is the time saved larger than the time the changed piece took before the change? If so, something other than the change moved the number. Treat the figure as unexplained.
5. Eval results only: did every run do the task, does the gap hold across repeated trials and configurations, and does the scenario tested matter for the claim? A run that failed before the task began counts as a failure, not as a pass.
6. Artifact figures only: measure the artifact. Words, pages, slides, lines, files, items and hours of work are counted from the artifact itself with a counting step you can name, and the figure is quoted together with that step. A figure carried over from memory, an earlier version or the brief is not a measurement. If the artifact is not available to you, the figure is an estimate: say it was not measured and what it rests on. When a tool already produces the count for that artifact, such as a word or element counter, read the figure from the tool and cite it instead of counting again.

Where the project has its own benchmark or eval procedure, that procedure wins for how to run the measurement. This file adds no benchmark checklist. It only decides whether a number someone already has can be trusted, and it never optimizes anything.

## Example

A report says a new upload path doubled throughput from 120 to 240 MB/s. It comes from one run on a laptop. Counters captured during that run show the load generator at 100 percent of one core and the server at 20 percent. Check 1 names the limiter: the generator. The number describes the generator, not the upload path. Check 3 is unverified: the run count is present (n = 1) and the spread is absent, so the figure is withheld as a result. The same report says the changed function used 30 ms of a 900 ms request and that the request now takes 500 ms. Check 4 fails: 400 ms saved cannot come from a piece that took 30 ms. The figure is unexplained until it is rerun with a generator that is not saturated, several runs and a spread.

An eval shows 94 percent pass against 80 percent before, 50 trials each. The run log shows 9 of the new trials ended with a startup error before the task began and were counted as passes. Check 2 rules in "errors" as an alternative, and check 5 says those trials count as failures. The figure has to be recomputed before anyone quotes it.

## When it does not apply

- Values that are records, not measurements, such as an invoice total or a row count read from a system of record. Check 6 cites those with their source instead of measuring them.
- Quick timings run out of curiosity that no decision or report will use.
- A number taken from an authoritative source that you did not measure. Cite the source instead.
- Measuring the quality of a skill or instruction: that belongs to a skill-evaluation workflow.
- Tuning performance. This file checks how good a number is, not how to improve it.
- A project instruction that sets a different measurement rule. Those win.
