# Upstream notice

Parts of this package are adapted from third-party MIT-licensed text.

- Upstream repository: cursor/plugins
- Upstream path: pstack/skills/architect
- Upstream path: pstack/skills/interrogate
- Upstream path: pstack/skills/principle-exhaust-the-design-space
- Adapted from commit: 88d47514b82e7c44f00f2b2a72ff6dd12158038c

This pin is drawn on by SKILL.md and by references/design-red-flags.md, references/rationale-template.md and references/reopen-chosen-shape.md, from the design-sketch skill: grounding before sketching, the usage-first candidate fields, the preference for interface depth, the screening list of design red flags (including its four newer entries), the rationale outline and the signals for reopening a chosen shape. It is also drawn on by references/interrogate.md, from the adversarial review skill (the reviewer packet, the review lenses, the quality lens and the lead-judgment filters), and by references/exhaust-design-space.md, which keeps the one sentence about decisions that depend on feel. Several upstream parts are not carried. The multi-model synthesis step, the role lines that name which model drafts or reviews, the named reviewer defaults and the call to a generic catch-all agent are replaced by requests to the orchestrator, which routes under its own slot limits and provider policy. The optional checkpoint and the implement-against-the-sketch phase are not carried either, because this package ends at the decision and a rationale. The comparison page, the bound of three candidates, the isolation rule, the no-slot stops and the gates at the top of SKILL.md are written by judgment and are not upstream wording.

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
- Upstream path: pstack/skills/interrogate
- Upstream path: pstack/skills/principle-exhaust-the-design-space
- Adapted from commit: 195d9359bdc2890f83745df69927528ad4538406

This pin is drawn on by references/interrogate.md and references/exhaust-design-space.md, where the later upstream commit removed text that this earlier one still had. From the review skill, the verdict-calibration guidance is restored: a verdict is useful and not exhaustive, and the rejected findings are always shown. The more-than-five test is kept; the advice to merge items that share one cause is written by judgment. From the design-space principle, the rule itself is restored: two or three competing candidates compared side by side before any is chosen, designing it twice as the same rule by another name, the cost of building the wrong thing, and the lists of when the rule applies and when it does not. The nine checks, the uniform candidate fields, the isolation check and both examples are written by judgment and are not upstream wording.

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

- Upstream repository: addyosmani/agent-skills
- Upstream path: skills/doubt-driven-development
- Adapted from commit: aeac41d4d005999432bb7312f7ff06383a91d59d

This pin is drawn on by the challenge section of references/interrogate.md: writing the claim briefly, cutting the smallest reviewable unit and stripping the author's reasoning from it, checking whether a finding only reflects an unclear contract before sorting it, the three-cycle stop rule with its decompose-instead-of-lifting-the-bound corollary, and the signs of an unchanged rerun or of validating in place of challenging. The upstream steps that pick or call outside reviewers are not carried: the offer of a second opinion from another provider, the command-line invocations, the persona roster and the links to other skills. Provider choice returns to the orchestrator's routing and provider policy, and the package asks no question about another provider. The four finding classes are merged into the four buckets of references/interrogate.md, with the contract-misread check kept as a step before bucketing.

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
