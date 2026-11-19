Example profile: fictional project, not a real setup.

# parallel-run-control-plane profile: Lanternworks

Lanternworks is an invented small web shop used only to show the fields. Copy this file into your own project, rename it and replace every value. A missing field means the run states that value at kickoff and posts it on the channel.

- channel path: `~/code/lanternworks/.runs/<run-id>-channel.md` (one file per run, created empty before the first append).
- channel retention: kept for the life of the project; a copy lands in the evidence store at close.
- durable evidence store: `~/code/lanternworks-evidence/releases/<run-id>/`.
- liveness threshold: 20 minutes without a new channel stamp.
- report interval: 15 minutes between coordinator report points.
- worker cap: 4 parallel workers for non-browser chunks while the decisive suite runs.
- load threshold: 4.0 (1-minute load average below which the lone quiet rerun may start).
- roles and ranked fallbacks: orchestrator on provider A, coordinator on provider A, lanes on provider B with provider C as the first fallback and provider A as the second, reviewers always on a provider different from the lane they review. These names are placeholders; list the real ones before the run.
- monitor primitive: assume a quiet session can be killed by the host. Every session arms a monitor as its first act and on every resume: a long-lived shell task that prints a line only when something changes (a new channel line, a lane going silent) and nothing otherwise. Do not rely on timed wake-ups to keep a session alive. State here what your host's idle reaper does to a quiet session and which primitives survive it.
- quota signal: what a session sees when its provider is out of quota (an error string, a status field, silence), so the orchestrator can tell a planned handover from a dead role.
- owner contact: how a question reaches the owner (a chat message, an email) and where the answer is recorded.
