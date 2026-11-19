# Upstream notice

Parts of this package are adapted from third-party MIT-licensed text.

- Upstream repository: cursor/plugins
- Upstream path: pstack/skills/principle-make-operations-idempotent
- Upstream path: pstack/skills/principle-boundary-discipline
- Upstream path: pstack/skills/principle-minimize-reader-load
- Upstream path: pstack/skills/principle-model-the-domain
- Upstream path: pstack/skills/tdd
- Upstream path: pstack/skills/principle-test-behavior-not-implementation
- Upstream path: pstack/skills/principle-foundational-thinking
- Upstream path: pstack/skills/principle-laziness-protocol
- Upstream path: pstack/skills/principle-subtract-before-you-add
- Upstream path: pstack/skills/principle-redesign-from-first-principles
- Upstream path: pstack/skills/principle-migrate-callers-then-delete-legacy-apis
- Upstream path: pstack/skills/principle-outcome-oriented-execution
- Upstream path: pstack/skills/principle-explain-the-number
- Adapted from commit: 88d47514b82e7c44f00f2b2a72ff6dd12158038c

This pin is drawn on by idempotent-operations.md, boundary-discipline.md, minimize-reader-load.md, model-the-domain.md, cheap-local-test.md, foundations.md, laziness.md and subtract.md, and by redesign.md, migrate-callers.md (the test rule and the applicability list only), outcome-execution.md and explain-the-number.md. The evidence condition before a redesign reverses upstream's default of always redesigning. That condition, the external-contract exceptions and the conditions that require a safe intermediate state are written by judgment and are not upstream wording.

The adaptation rewrites the upstream wording. The licence below is reproduced exactly as it appears at the commit named above.

```text
MIT License

Copyright (c) 2026 Lauren Tan

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

# Upstream notice

Parts of this package are adapted from third-party MIT-licensed text.

- Upstream repository: cursor/plugins
- Upstream path: pstack/skills/principle-make-operations-idempotent
- Upstream path: pstack/skills/principle-laziness-protocol
- Upstream path: pstack/skills/principle-migrate-callers-then-delete-legacy-apis
- Upstream path: pstack/skills/principle-subtract-before-you-add
- Adapted from commit: 195d9359bdc2890f83745df69927528ad4538406

This pin is drawn on by idempotent-operations.md, for the startup, cleanup, lock and scheduling checks only, and by laziness.md, for the rules that are missing from the newer text: prefer deletion, a flat call hierarchy (without its file-count threshold), question the threading, small leaks and the maintainer test, plus its opening framing, and by subtract.md, for the out-of-spec guards rule inside check 5, and by migrate-callers.md, for the rules that are missing from the newer text: do not keep a legacy path only because internal callers remain, take an inventory of the callers then migrate and delete, and treat a temporary adapter as an exception that is time-boxed. The dated expiry or checkpoint, with an explicit decision when it lapses, is added by judgment, because upstream gives no way to enforce the time box.

The adaptation rewrites the upstream wording. The licence below is reproduced exactly as it appears at the commit named above.

```text
MIT License

Copyright (c) 2026 Lauren Tan

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

# Upstream notice

Parts of this package are adapted from third-party MIT-licensed text.

- Upstream repository: mattpocock/skills
- Upstream path: skills/engineering/domain-modeling
- Upstream path: skills/engineering/codebase-design
- Upstream path: skills/engineering/code-review
- Upstream path: skills/engineering/improve-codebase-architecture
- Adapted from commit: 5beb35b040e3de97e54fa9e386d7e42d15c295c2

This pin is drawn on by domain-language.md, for term disambiguation, scenario tests and the decision-record threshold only, and by deep-modules.md, for the deletion test, seams and the test surface only, and by review-fixed-point-traceability.md, for the fixed point with its stop on an invalid ref or an empty diff, the two review axes, the order of spec sources, the three spec findings, the search for standards files and the rule against a combined ranking. It is also drawn on by hotspot-scan.md, for the commit-history scan, the weighing of recent change, the named-direction shortcut, the widening when changes are scattered and the decision-record rule. Local wording and routing, not upstream: where authority is resolved (project files, the task tracker, the diff and the no-mistakes gate), the pointers to other principle files, the set-aside list for noise churn, the growth-versus-friction reading, the request-only limit on the scan and the examples. The review's separate reviewers, its issue-tracker step, its fixed smell list, and the architecture report with its grilling loop are not adopted.

The adaptation rewrites the upstream wording. The licence below is reproduced exactly as it appears at the commit named above.

```text
MIT License

Copyright (c) 2026 Matt Pocock

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

# Upstream notice

Parts of this package are adapted from third-party MIT-licensed text.

- Upstream repository: addyosmani/agent-skills
- Upstream path: skills/constraint-driven-development
- Adapted from commit: aeac41d4d005999432bb7312f7ff06383a91d59d

This pin is drawn on by quality-bar-guard.md, for the list of moves that quietly lower a quality bar and for the ranking of checks into external, project-owned and the author's own suite, only. Local wording and routing, not upstream: the rule that "no hits" counts only when the whole diff was read, the exception for tests removed with the code they covered, the reason-and-owner check, reporting a gap to the orchestrator for the task tracker and the example. The intake questions, the constraints file, the default numbers, the tool installs, the lifecycle wiring and the instruction-file edits are not adopted.

The adaptation rewrites the upstream wording. The licence below is reproduced exactly as it appears at the commit named above.

```text
MIT License

Copyright (c) 2025 Addy Osmani

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

# Upstream notice

Written fresh in our own words. No upstream text is copied, so no licence text is reproduced. The source is credited for provenance.

- Idea source: trailofbits-skills (trailofbits/skills), path plugins/property-based-testing, commit 5c99c03fb8a9ea568432ecbcba5d86e9f4ac2bf0
- Source licence: CC BY-SA 4.0
