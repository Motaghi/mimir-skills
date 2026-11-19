---
name: morning-brief
description: Use when the user asks to show or read the morning brief, review today's work, or see what needs attention. Finds the freshest daily brief in the configured notes folders (today's file preferred), surfaces action items first, and offers follow-up routing for each kind of item the brief lists. It does not regenerate or edit the brief.
---

# morning-brief

Reading-side handler for a daily brief that some other job writes (a scheduled script, a cron job, a CI task). The skill finds the brief, reads it and turns its action items into concrete next steps. Setup-specific values (where briefs live, the order to search, the follow-up commands for each kind of item) are in a profile; see `profiles/example.md`. Your own profile is `morning-brief.profile.md` in the project root; if it is not there, ask the user where briefs are kept. Keep it in your project, not in this folder.

## What it needs

- Read access to the folders the profile lists.
- Optionally, the commands the profile names for follow-ups (acknowledging an alert, listing pending review items, checking a scheduled job). If one is missing, still show the brief and mark that follow-up as unsupported. Do not substitute another command and do not change anything silently.

## When to invoke

Trigger phrases:
- "morning brief", "show me the brief", "read the brief"
- "what's on my plate", "what do I need to do today", "what's pending"
- "daily brief", "daily status"

If the user names a date ("yesterday's brief", "the brief from Monday"), look for that date's file instead of today's.

## Inputs

No required inputs. The skill resolves the brief path itself.

Optional:
- **Date override**: the user says "the brief from <date>"; use that date's file.
- **Section filter**: the user says "just the action items" or "only alerts"; read the full file, then show only that section.

## Process

### Step 1: Locate the brief

If the user asked for a date, look only for that date first: `<inbox>/<date>-morning-brief.md`, then `<notes>/<date>-morning-brief-*.md`. If that date has no brief, say so and offer the nearest earlier one; do not fall back to a "latest" file silently.

With no date requested, check the profile's search order and use the first path that exists. With no profile, use this order:

1. `<inbox>/<today>-morning-brief.md`: today's brief before it has been filed.
2. `<notes>/<today>-morning-brief-*.md`: today's filed brief; take the first exact-date match.
3. A file named `latest-morning-brief.md` in the notes folder, if the brief job keeps one, but only when its `date:` frontmatter is today. A "latest" file with an older date never beats a dated file for today.
4. The most recent `<notes>/*-morning-brief-*.md`: fallback when today's brief does not exist yet.

Report which path was found and its `date:` frontmatter value, so the user knows how fresh the brief is.

If no brief is found, report the paths you checked. If the profile names a way to inspect the brief job (a scheduler status command, a log file), use it to say why the brief is missing. Otherwise say that job diagnosis is not available here.

### Step 2: Read and show the brief

Read the file and show its contents without truncating. Present them in this order, whatever order the file uses:

1. **Action items**: the checklist under `## Action items` (any capitalisation). These come first because they are the user's main task.
2. **Decisions needing input**: the `## Decisions needing input` section, if present.
3. **Shipped yesterday**: abbreviated (commit ids plus a one-line summary each is enough).
4. **Status snapshot**, if present.
5. **Upcoming** and **Stale items**, if present.
6. **Loose ends** and any cost or delegation signals.

### Step 3: Give follow-up hints

After the content, print a short "routing hints" block that maps each kind of action item to the exact command or skill the user can use. The profile supplies the table. With no profile, use these generic rows:

| Action item type | Follow-up |
|---|---|
| Alert to acknowledge | the profile's acknowledge command |
| Review items waiting for a decision | the profile's list command, then decide each one |
| Uncommitted files in a repository | inspect that exact repository and route through the `commit-and-push-gate` skill |
| Stale inbox items | open the inbox folder and go through them |
| Brief job errors | the profile's job status command |

Only show hints for kinds of item that appear in this brief. Do not pad with hints for empty categories.

### Step 4: Offer to act on one item

After the hints, ask once:

> "Want me to jump into any of these directly? (for example, 'acknowledge the alert' or 'commit the repository')"

If the user says yes, handle that item immediately through the matching skill or command. A commit always goes through `commit-and-push-gate` and keeps its separate approval step. For stale inbox items, read each file and ask what to do with it (keep, archive, or route onward).

Do not chain items on your own unless the user says "go through all action items" or "clear the whole list".

## Out of scope

- Regenerating the brief. The job that writes it does that.
- Writing to the brief file. It is a read-only record once written.
- Acting on all items silently. Each item needs the user's confirmation.
- A "summary of the summary". Show the content; do not add a third level of abstraction.

## Failure modes

- **Brief not found**: report the paths checked and suggest checking the job's log or status.
- **Brief has no date in its frontmatter**: still show the content and say the date could not be confirmed.
- **Several briefs for today** (for example a weekly and a morning brief): prefer the morning brief and mention that both exist.
- **Brief is from an earlier date** (the job did not run today): show it and flag it: "This brief is from <date>, <N> days ago. The job may not have run today."
