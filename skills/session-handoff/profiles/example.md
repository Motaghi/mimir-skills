Example profile: fictional project, not a real setup.

# session-handoff profile: Lanternworks

Lanternworks is an invented small web shop used only to show the fields. Copy this file into your own project, rename it and replace every value.

- notes root: `~/notes` (the folder your notes tool opens).
- notes folder for handoffs: `~/notes/inbox`.
- renderer command: none. The agent renders the layout in the skill's Step 2 itself. If you keep a small script that reads the five fields as JSON on standard input and prints the markdown, put its full command here.
- frontmatter: the default block in the skill, or your own. Example: `date`, `tags: [handoff]`, `description`, plus `status: open` if your notes tool uses it to find unfinished items.
- resume prompt path style: path relative to the notes root, for example `inbox/<YYYY-MM-DD>-handoff-checkout-page-polish.md`.
- file name pattern: `<YYYY-MM-DD>-handoff-<slug>.md`.
- extra fields to name in `current_state` when they apply: the plan file that drove the session, the branch, the ticket id.
