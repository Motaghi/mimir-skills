---
name: session-handoff
description: Use when the user says "summarize for clear", "wrap this session", "handoff time", "give me a resume prompt", or "let's clear and continue later". Runs in-session only. Extracts open decisions, active files, pending tasks, current state and recent corrections from the conversation, renders them in a fixed layout, writes a dated handoff note to the configured notes folder, and returns a short resume prompt that works in any agent host.
---

# session-handoff

Formalises the "summarize, clear, resume" workflow. The skill turns the conversation into five fixed fields, renders them in a deterministic layout, writes a dated note and prints a short prompt the user pastes into a fresh session. Setup-specific values (the notes folder, an optional renderer command, the note's frontmatter) are in a profile; see `profiles/example.md`. Your own profile is `session-handoff.profile.md` in the project root; if it is not there, ask the user where to write handoffs. Keep it in your project, not in this folder.

## What it needs

- Write access to the notes folder named in the profile.
- A shell, only if the profile names a renderer command. Without one, render the layout in "Step 2" yourself.

If the notes folder is not writable, stop before writing anything and say so. Do not create a partial handoff.

## When to invoke

Trigger phrasing the user types:

- "summarize for clear"
- "wrap this session"
- "handoff time"
- "give me a resume prompt"
- "let's clear and continue later"

If the trigger is ambiguous, ask which conversation thread to hand off. If you are unsure whether to invoke this skill or summarize freehand, prefer the skill: the fixed layout and the deterministic file name are the value over a freestyle summary.

## Process

### Step 1: Extract the five fields

You have the full transcript in context. Build these fields with these exact names:

- `open_decisions`: list of strings, each one a decision the user has not yet made or a question awaiting their answer.
- `active_files`: list of strings, each one a file path you have read, written or edited this session.
- `pending_tasks`: list of strings, each one a concrete next action that should resume work.
- `current_state`: a multi-line string describing where the session is right now (what just got done, what is in flight).
- `recent_corrections`: list of strings, each one a piece of feedback or a correction from the user that should not be lost.

Each field may be empty. Do not invent content to fill quotas. An honest empty list is better than a padded one. Keep each list to 50 items and `current_state` to about 4,000 characters; if you are over, cut the least useful items and say so.

### Step 2: Render

If the profile names a renderer command, pipe the five fields to it as JSON on standard input and take the markdown from standard output. Malformed JSON or a non-zero exit means: show the error to the user and do not write a partial file.

Without a renderer, produce exactly this layout (an empty list renders as `- (none)`):

```markdown
# Session handoff summary

## Open decisions
- <item>

## Active files
- <item>

## Pending tasks
- <item>

## Current state
<current_state text>

## Recent corrections
- <item>
```

### Step 3: Pick a file name

- Kebab-case slug from the session's primary topic, 3 to 5 words.
- Date prefix: today's local date as `YYYY-MM-DD`.
- File name `<YYYY-MM-DD>-handoff-<slug>.md`, with a collision suffix `-2`, `-3` if that name already exists.

Example: for a session about polishing the checkout page, the slug is `checkout-page-polish` and the file is `<YYYY-MM-DD>-handoff-checkout-page-polish.md`.

### Step 4: Write the note

Write the rendered markdown to `<notes-folder>/<file name>` with the profile's frontmatter prepended. With no profile frontmatter, use:

```yaml
---
date: <YYYY-MM-DD>
tags: [handoff]
description: <one-line summary of the session, under 100 characters>
---
```

### Step 5: Return the resume prompt

Print the resume prompt in chat for the user to copy:

> `Wrote <notes-folder>/<file name>`
>
> `Start a fresh session, then paste this as your first message:`
>
> `"Resume from <path of the note relative to the notes root> and proceed from the pending tasks. If the handoff names an execution plan or other authoritative source, reread it before building any focus or task list; the handoff is a pointer, not the source of truth."`

Keep the prompt free of URLs, so clipboard tools do not rewrite the `.md` file name.

The "reread the authoritative source" clause exists because a resumed session sees only the pasted prompt and its standing instructions, not the earlier transcript. If a plan drove the session, a task list built from the handoff alone can drop the plan's real criteria. When Step 1 finds that a plan or other source drove the session, name it explicitly in `current_state`.

## Out of scope

- Reading earlier handoff files. If the user asks "what was in last week's handoff?", that is an ordinary file read.
- Running automatically when a session closes. The user invokes this explicitly.
- Writing to any long-term memory store. That is a separate step with its own rules.

## Failure modes

- Renderer named in the profile but not available: report the missing command and stop without writing.
- JSON parse error from the renderer: do not write a partial file; show the error and ask the user how to proceed.
- Notes folder not writable: surface the error; do not retry silently.
- Slug collision suffixes used up (rare): bump to the next number and warn the user that several handoffs landed today on the same topic.
