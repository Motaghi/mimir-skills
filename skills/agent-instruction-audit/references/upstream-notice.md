# Upstream notice

Parts of this package are adapted from third-party MIT-licensed text.

- Upstream repository: cursor/plugins
- Upstream path: pstack/skills/correct
- Adapted from commit: 88d47514b82e7c44f00f2b2a72ff6dd12158038c

This pin is drawn on by the repeated-mistake audit in SKILL.md: grouping mistakes into classes that have happened twice, the ladder from architecture through types, lint and test to docs last, the lint error that names the replacement, and the rule that each check is shown failing on a real past mistake. The upstream steps that fix each class in a commit, that keep a rule table in an instruction file and that fix repeats in the same change are not carried: this package reports and proposes only, and the orchestrator files and routes the work. The exception rule and the same-command-locally-and-in-CI rule are kept in new wording.

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
- Upstream path: skills/engineering/retro
- Upstream path: skills/productivity/writing-for-agents
- Adapted from commit: 5beb35b040e3de97e54fa9e386d7e42d15c295c2

This pin is drawn on by the session retro in SKILL.md, from the retro skill, and by the instruction audit in SKILL.md and references/skill-mechanics.md, from the writing guide and its mechanics file. The retro keeps the upstream rule that it runs only when asked. The upstream steering toward building hooks, lint rules and CI jobs, toward a standards file and toward granting the agent new access is replaced by proposals that go to the orchestrator and are never applied. The upstream choice between model-invoked and user-invoked skills is mapped onto three activation modes, and the upstream router skill is replaced by the orchestrator's own routing.

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
