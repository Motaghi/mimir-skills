Example profile: fictional project, not a real setup.

# commit-and-push-gate profile: Lanternworks

Lanternworks is an invented small web shop used only to show the fields. Copy this file into your own project, rename it and replace every value.

- session repository: the repository the session was opened in, for example `~/code/lanternworks`.
- commit command: `git --literal-pathspecs add -- <paths> && git --literal-pathspecs commit -m "<message>" -- <paths>`. It must take exact paths. A wrapper that takes a lock first is fine as long as it commits only the paths named.
- gated paths: `deploy/`, `.github/workflows/`, `scripts/release/`. A change here needs the diff shown and an explicit "go", even inside the session's repository. For `deploy/` the same change must also update `docs/deploy-notes.md`.
- sibling repositories: `~/code/lanternworks-docs` and `~/code/lanternworks-infra`. Committing into either needs an explicit yes for that repository, every time.
- never commit: `.env*`, anything under `secrets/`, files over 10 MB (the classifier enforces the last one and the name patterns).
- message style: conventional prefixes (`feat:`, `fix:`, `docs:`), subject under 72 characters, imperative mood, no trailing period.
- trailers: none. Do not add author or tool attribution lines unless the project asks for them.
- push route: not part of this skill. The owner pushes by hand, or tells the agent "push" in a separate message, and the agent then runs `git push origin <branch>` and nothing else.
- ask-the-user route: a chat message that offers a short list of answers and waits.
