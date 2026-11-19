# Upstream notice

Parts of this package are adapted from third-party MIT-licensed text.

- Upstream repository: mattpocock/skills
- Upstream path: skills/engineering/resolving-merge-conflicts
- Adapted from commit: 6654f6b60cd9d5be8b54c6fafe44346dabeb3b76

This is the August pin. The upstream project removed this skill in a later release with no replacement (its changelog for version 1.3.0 says so), so there is no newer upstream text to track and this package is maintained here as its own copy.

The package draws on the five upstream steps: look at the state, find the primary sources for each conflict, resolve each hunk without inventing behaviour, run the project's automated checks, and finish. It departs from upstream in these places:

- Upstream says always resolve and never abort. This package allows an abort when the intent of a side cannot be recovered, and treats the abort as a decision for the owner.
- Upstream finishes the operation by staging everything and committing. This package never commits; the finish goes to the orchestrator and the commit gate.
- Upstream reads pull requests and tickets as primary sources. This package reads commit messages, task records through the project's task tracker and the project's authority files, and marks an outside tracker "not checked".
- The read-only rule with run requests, the baselines, the search for conflicts the markers do not show, the generated-file rule and the report format are written by judgment and are not upstream wording.

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
