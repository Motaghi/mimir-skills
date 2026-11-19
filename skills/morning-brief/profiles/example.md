Example profile: fictional project, not a real setup.

# morning-brief profile: Lanternworks

Lanternworks is an invented small web shop used only to show the fields. Copy this file into your own project, rename it and replace every value.

- brief writer: a nightly script, `~/code/lanternworks/tools/morning_brief.py`, run by cron at 06:30. It writes `<today>-morning-brief.md` to the inbox.
- notes root: `~/notes`.
- search order: (1) `~/notes/inbox/<today>-morning-brief.md`, (2) `~/notes/archive/<today>-morning-brief-*.md`, (3) `~/notes/desk/latest-morning-brief.md`, only if its `date:` is today, (4) the newest `~/notes/archive/*-morning-brief-*.md`. For a requested date, only the dated files in (1) and (2) for that date.
- inbox folder for stale items: `~/notes/inbox`.
- follow-up commands:
  - Acknowledge an alert: `lw-alerts ack <id>`.
  - Review items waiting for a decision: `lw-review list-pending`.
  - Uncommitted files in the main repository: inspect `~/code/lanternworks`, then use the `commit-and-push-gate` skill.
  - Uncommitted files in another repository: inspect that exact repository, then the same skill.
  - Brief job errors: `crontab -l` and the log at `~/code/lanternworks/logs/morning_brief.log`.
- extra sections the brief carries: a "Cost" block with yesterday's model spend. Show it under "Loose ends".
- staleness note: if the newest brief is older than one day, say how many days old it is.
