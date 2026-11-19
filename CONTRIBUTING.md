# Contributing

Thanks for taking the time. Issues and pull requests are welcome: a fix to a skill, a clearer sentence, or a missing credit. If you find private-looking content (a personal name, credential, internal path or customer data) or a security problem, do not post it in a public issue or pull request: report it privately as described in [SECURITY.md](SECURITY.md).

## Sign your commits (DCO)

Every commit needs a sign-off under the Developer Certificate of Origin, version 1.1. The full text is at <https://developercertificate.org/>. By signing off you state that you wrote the change, or otherwise have the right to submit it under this repository's licence (MIT).

Sign off by adding a trailer to the commit message:

```
Signed-off-by: Your Name <you@example.com>
```

`git commit -s` adds it for you. The name and email in the `Signed-off-by` line must match the commit's author. Pull requests with unsigned commits cannot be merged; `git commit --amend -s` or `git rebase --signoff` fixes them.

## What fits here

- Keep each skill readable on its own. A skill folder holds a `SKILL.md` and may hold `references/` and `profiles/` files that `SKILL.md` points to.
- Do not add private paths, hostnames, customer or project names, or personal data. Example profiles describe a fictional project.
- If a change adapts text from another project, add or update its entry in `CREDITS.md` with the upstream skill, author, repository, pinned commit and licence line, and keep that project's licence notice in the skill folder. Only MIT-compatible material is accepted.
- Write plain prose.

## Licence

By contributing you agree that your contribution is licensed under the MIT License in [LICENSE](LICENSE).
