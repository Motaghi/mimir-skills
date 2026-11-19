# Upstream notice

Parts of this package are adapted from third-party MIT-licensed text.

- Upstream repository: cursor/plugins
- Upstream path: pstack/skills/create-verification-skill
- Upstream path: pstack/skills/maintain-verification-skill
- Upstream path: pstack/skills/create-formal-verification-skill
- Upstream path: pstack/skills/maintain-formal-verification-skill
- Adapted from commit: 88d47514b82e7c44f00f2b2a72ff6dd12158038c

This pin is drawn on by create mode in SKILL.md, from the two create skills, and by references/maintain-mode.md, from the two maintain skills. The formal pair also feeds references/formal-checks.md and the formal checks pass in references/maintain-mode.md. The upstream output is a project-local skill folder with generated helper scripts. Here the output is a proof-map document, so the skill folder, the registration step and the generated helpers are not carried. From the formal pair, only the method is kept: how to pick the target and the approach, what a check must record, and how to sort failures into drift and bugs. Installing a tool, running it, the scratch break on real code and the pull request for corrections become proposed text and run requests. The three rules added at this pin are kept in new wording: a launch must reach a usable state from an empty data directory, a journey whose precondition is missing from the seed data reports a failure and is never weakened, and a proof run in a stand-in lists every step the stand-in did that the real target will not. The upstream parallel readers and the pull request that ships corrections are replaced by routing through the orchestrator and by an authority rule, and the package opens no branch and no pull request.

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
