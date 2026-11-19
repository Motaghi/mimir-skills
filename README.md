# mimir-skills

Twenty-five skills for coding agents, in plain `SKILL.md` folders. They come from the working setup behind the mimir orchestrator repository, cleaned of everything specific to that setup. Some are original. Some are forks of other people's MIT-licensed skills with changes we found useful, and each of those names its upstream author and pins the upstream commit in [CREDITS.md](CREDITS.md).

Each skill is a folder under `skills/` with a `SKILL.md` (frontmatter with `name` and `description`, then the method) and, where needed, `references/` files that the skill points to. Copy the folders you want into whatever skills directory your agent reads.

Several skills mention an orchestrator. That is the main agent or session that reads a request, picks the work and attaches skills to tasks. If you run a single agent, read "the orchestrator" as that agent. Five skills read a project profile (commit-and-push-gate, parallel-run-control-plane, session-handoff, run-close-pack, morning-brief). Each looks for `<skill-name>.profile.md` in your project root, for example `run-close-pack.profile.md`, and asks where it is if the file is missing. The skill's `profiles/example.md` lists every field for a fictional project: copy it to your project root under the required name and fill it in.

## The skills

### Original skills

| Skill | What it does |
|---|---|
| [changelog-drafter](skills/changelog-drafter) | Drafts a Keep-a-Changelog entry from the git log and proposes a version bump. |
| [refine-pattern](skills/refine-pattern) | Tightens a plan so counted fan-out and cross-task references are exact. |
| [deepreview](skills/deepreview) | Two-stage critical review with four independent reviewers and two adjudicators. |
| [deeperreview](skills/deeperreview) | The same review at a larger panel size. |
| [deepestreview](skills/deepestreview) | The same review at the largest panel size. |
| [improve-loop](skills/improve-loop) | Improves an artifact in rounds until an independent panel puts it at the bar. |
| [build-team](skills/build-team) | Runs a build with a PM, an isolated test author, two developers and independent QA. Borrows report fields from pstack and credits it. |

### Originals that read a project profile

| Skill | What it does |
|---|---|
| [commit-and-push-gate](skills/commit-and-push-gate) | Builds a commit from the session's own changes and gates what may be committed. |
| [parallel-run-control-plane](skills/parallel-run-control-plane) | Rules for a build that runs two or more lanes at once. |
| [session-handoff](skills/session-handoff) | Writes a structured handoff so a session can be cleared and resumed. |
| [run-close-pack](skills/run-close-pack) | Closes a run whose output reaches users: freeze, decisive suite, public pack. Borrows report fields from pstack and credits it. |
| [morning-brief](skills/morning-brief) | Finds the latest daily brief and surfaces the action items first. |

### Forks with our changes

| Skill | What it does |
|---|---|
| [typescript-discipline](skills/typescript-discipline) | Numbered TypeScript type-design rules with a report form. |
| [engineering-principles](skills/engineering-principles) | One file per engineering principle, each with numbered checks. |
| [prototype](skills/prototype) | Throwaway prototypes that answer one logic or look-and-feel question. |
| [proof-map](skills/proof-map) | A standing document on how to launch, drive and prove an app, plus upkeep. |
| [explain-how](skills/explain-how) | Read-only walkthroughs of a subsystem and what to know before changing it. |
| [merge-intent-resolution](skills/merge-intent-resolution) | Resolves a conflict in progress by recovering what each side meant. |
| [internal-technical-writing](skills/internal-technical-writing) | Sentence and structure rules for runbooks, READMEs and PR text, with a cold-read test. |

### Forks generalised from a private setup

| Skill | What it does |
|---|---|
| [blast-radius](skills/blast-radius) | Finds what a change could break outside its diff and proves it with one check. |
| [agent-instruction-audit](skills/agent-instruction-audit) | Read-only audit of agent instructions and repeated mistakes. |
| [architecture-alternatives](skills/architecture-alternatives) | Compares two or three structurally different designs, then challenges the pick. |
| [root-cause-diagnosis](skills/root-cause-diagnosis) | Read-only root-cause loop for bugs and regressions. |
| [wayfinder](skills/wayfinder) | Charts a goal too big for one session as a live map of decision tickets. Tickets mode needs the task-tracker operations listed in Vocabulary. |

### Re-fork of a current upstream

| Skill | What it does |
|---|---|
| [no-mistakes](skills/no-mistakes) | The no-mistakes push gate from Kun Chen's project, with a short local contract added. |

## Vocabulary

Skills here name what they need in capability words instead of tool names, so they work with whatever your agent offers. If a capability is missing, a skill says which step it blocks and marks that step unverified.

| Word | Meaning |
|---|---|
| package | One skill folder: its `SKILL.md` and the files it points to. |
| run request | A step the skill does not run itself: the exact command, directory, inputs, expected result and evidence to bring back, handed to the orchestrator to run. |
| orchestrator | The main agent or session that reads a request, routes the work and attaches skills to tasks. With a single agent, that agent. |
| owner | The person who owns the project and makes the decisions the skill must not make for them. |
| `filesystem` | Read (and where a skill says so, write) files in the project. |
| `git-read` | Read-only git: status, log, diff, blame, history. Nothing that changes the tree, the index, refs or remotes. |
| `shell` | Run shell commands. Skills that say "read-only shell" limit it to search and listing. |
| `docs` | The owner's documents: notes, specs, plans and decision records, which may live outside the repository. |
| `review-page` | A page or message where the owner compares options and answers with real controls. Any equivalent works. |
| `task-tracker` | The project's task or ticket list. Read-only unless a skill says it files tasks. wayfinder's tickets mode files tickets: it needs to create a ticket with a chosen id, title, kind, body, blockers and priority, and to show a ticket's full state before and after each write. If your tracker assigns ids itself, map the approved logical keys to the ids it assigns. |
| `style-check` | A check of wording against the project's own style rules, where it has them. |
| `logs` | Read logs and run records. |
| `status` | Read the current state of the system or run (queues, jobs, health). |
| `user-decision` | Ask the owner a question and wait for the answer. |
| `subagent-orchestration` | Start separate agent contexts, tell when each is finished and collect their results. |
| `artifact-build` | Produce a file or build artifact through the orchestrator's normal tools. |
| `python-tooling` | Run Python scripts that ship with a skill. |

## Installing

Copy whole skill folders into your agent's skills directory, so each folder keeps its `references/` and any upstream notice files. Keep the repository's [LICENSE](LICENSE) (MIT, covers the originals and our changes) and [CREDITS.md](CREDITS.md) with the copies, for example in the directory above the folders, because the forks are MIT-licensed work by other authors and their notices have to travel with them.

Some skills load or name others. If you install a skill, add the companions in this table:

| Skill | Also install |
|---|---|
| build-team | parallel-run-control-plane, run-close-pack (it loads both when a run has two lanes or reaches users) |
| run-close-pack | parallel-run-control-plane, build-team (its usual caller) |
| parallel-run-control-plane | run-close-pack |
| blast-radius | root-cause-diagnosis, deepreview, deeperreview, deepestreview, engineering-principles, no-mistakes |
| wayfinder | root-cause-diagnosis, prototype, build-team, explain-how, engineering-principles, parallel-run-control-plane, session-handoff, morning-brief, refine-pattern |
| architecture-alternatives | prototype, explain-how, root-cause-diagnosis, engineering-principles, build-team, deepreview, deeperreview, deepestreview |
| agent-instruction-audit | engineering-principles, typescript-discipline, root-cause-diagnosis, commit-and-push-gate, no-mistakes, session-handoff |
| root-cause-diagnosis | blast-radius, build-team, engineering-principles, explain-how |
| engineering-principles | root-cause-diagnosis, build-team, prototype, no-mistakes |
| typescript-discipline | engineering-principles, root-cause-diagnosis, build-team |
| prototype | explain-how, engineering-principles, architecture-alternatives, build-team |
| proof-map | engineering-principles, typescript-discipline, root-cause-diagnosis, build-team, no-mistakes |
| explain-how | root-cause-diagnosis |
| merge-intent-resolution | commit-and-push-gate, no-mistakes, root-cause-diagnosis |
| internal-technical-writing | changelog-drafter, commit-and-push-gate, no-mistakes, blast-radius, run-close-pack |
| improve-loop | deepreview |
| deepreview, deeperreview, deepestreview | each other (they are three sizes of one review) |
| morning-brief | commit-and-push-gate |

The other skills (changelog-drafter, refine-pattern, commit-and-push-gate, no-mistakes, session-handoff) name no companion.

### Prerequisites outside this repository

- **no-mistakes** is a skill for Kun Chen's separate `no-mistakes` command-line tool (kunchenguid/no-mistakes). Install and configure that tool first, following its own documentation. If the `no-mistakes` command is missing, that is an installation problem, and the skill cannot help. If the command is installed but a run misbehaves, `no-mistakes doctor` reports what is wrong with the configuration.
- **build-team** relies on acceptance checks that you implement yourself: a spec readiness check, a stub-fail check, an assertion-diff check, a criterion-tag check and a run-manifest reporter for your test runner. [acceptance-checks.md](skills/build-team/references/acceptance-checks.md) specifies each as a contract. Without them build-team can still run as a team, but the frozen-suite gate has nothing to enforce it.
- Several skills use a test runner, git and a shell. `changelog-drafter` needs Python 3.

### Skills that act only when attached

`typescript-discipline`, `engineering-principles`, `internal-technical-writing` and `blast-radius` are criteria or methods, not general behaviours. They decline a direct request unless the orchestrator or you attach the skill as a labeled input to the task. A worked example of such a task brief:

```text
Task: review the diff on branch feature/export for type-design problems.
Attached input (labeled): skills/typescript-discipline/SKILL.md
Report each numbered rule as met, failed, not applicable or unverified, with a file and line for each result.
```

Without the attached input, the same request is answered with a decline that names who owns it.

## Credits and licence

Every fork is listed in [CREDITS.md](CREDITS.md) with its upstream skill, author, repository, pinned commit, licence line and what we changed. The licence notices of the upstream projects are kept in the skill folders that adapt them.

This repository is MIT licensed, see [LICENSE](LICENSE). Contributions need a DCO sign-off, see [CONTRIBUTING.md](CONTRIBUTING.md).
