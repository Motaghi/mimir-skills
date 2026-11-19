# Upstream notice

Parts of this package are adapted from third-party MIT-licensed text.

- Upstream repository: cursor/plugins
- Upstream path: pstack/skills/typescript-best-practices
- Adapted from commit: 88d47514b82e7c44f00f2b2a72ff6dd12158038c

This pin is drawn on by SKILL.md, for the rule table, the hot-path exception to object arguments and the schema-first rule, by references/patterns.md, for the code examples, which are rewritten with new names, and also by references/type-system.md, for the reasons an unchecked cast fails to infer. The schema-first rule names no library. Three upstream examples are corrected so they type-check with strict checking and unchecked indexed access: the range example, which upstream presents as unable to hold a negative duration although a plain number admits one, so here a range is a frozen class whose private constructor validates the start, the duration and the end, stores them in `#private` fields and is reached through a static method; the non-empty example, which here reads position 0; and the `satisfies` example, which here defines the contextual type and uses `as const` where a literal must be kept against a wider type. The second hot-path exception, for diagnostics, and the evidence condition for claiming a hot path are written by judgment and are not upstream wording.

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
- Upstream path: pstack/skills/principle-type-system-discipline
- Adapted from commit: 195d9359bdc2890f83745df69927528ad4538406

This pin is drawn on by references/type-system.md and by the rules in SKILL.md that it explains. The text is authored from this earlier commit plus judgment, because the fuller rule set is in that commit: the rules on unrepresentable illegal states and exhaustive variants, the constructions rule, the rule about not lying to the compiler, the rule about strengthening a type only where partiality appears, and the six tests. The newer pin keeps a shorter body. The text here keeps the earlier body, narrowed to TypeScript, and drops the examples for other languages.

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
