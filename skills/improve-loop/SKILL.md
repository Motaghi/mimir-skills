---
name: improve-loop
description: >-
  Improve any artifact (code, copy, plan, deck, UI) in rounds until a review
  panel puts it at the bar. Each round a panel of independent reviewers scores
  it and lists findings, the orchestrating session makes the smallest fix per
  agreed finding, and the loop stops at the bar, the budget, a stall, or a
  dispute the owner decides. UI mode adds browser screenshots and
  side-by-side reference shots. Use for /improve-loop, "improve loop", "loop
  until 9/10", "keep improving X until it beats Y". Not for writing a loop
  prompt for another session, or a one-off review (deepreview
  family).
---

# improve-loop

You run the loop yourself. The panel reviews, you fix. Reviewers never edit, and you never grade your own work. Your second job is to keep scope small: make the smallest change that answers each agreed finding and decline the rest.

## Inputs

- **Target.** The artifact and where it lives (repo and branch, file path, URL). UI mode also needs the pages and widths to shoot.
- **Bar.** Default: every panel member at 9/10 or better on the current version, no open blocker, the approved references beaten, and every main-intent check passing (see Before round 1).
- **Budget.** Default: 3 rounds, plus a stall stop after 2 rounds in a row in which the lowest panel score does not rise.
- **Panel.** Default: the two members in "Default panel" below. The owner can name others, for example four judges.
- **References.** Named by the caller, or found as below when the bar includes them.
- **Guardrails.** Fixed rules from the caller that every fix must keep (see the last section).

Owner overrides win in any phrasing: "up to 20 rounds or until 9/10", "until 11:00 tomorrow or 10/10", "skip references". Restate the resolved bar, budget and panel in two lines before round 1.

## Before round 1

1. **Pin the main intent.** Restate what the owner most wants changed as 1 to 3 explicit pass or fail checks (for example "the first sentence states the reader's value" or "no headline over 10 words"). Show them in one short question and get a yes or an edit before round 1. They become part of the bar: every round and the final check run them through a separate checker context, not the panel and not you, and any fail blocks the bar whatever the scores say. A run can score 9/10 and still miss the point; these checks are what stop that.
2. **Resolve the panel.** Confirm each member's provider, model and effort is reachable through the routes the governing platform policy allows. If a provider or model is missing, report it and stop. Never substitute.
3. **Baseline.** Record the start (commit or file hash) before any change. In UI mode, take browser screenshots of the named pages at the named widths.
4. **Clean start.** Fix only the known issues the caller names, list them in the report as pre-loop changes, and run the artifact's own checks (tests, build, lint, voice lint).
5. **References.** When the bar includes references and the owner has not already approved a set, start two researchers in parallel on two different providers (defaults below). Each proposes 3 to 5 references with real user praise (quoted, linked, dated); candidates the caller named go through the same check. Each reference must be named, fetchable and comparable. Merge both lists for the owner, who approves the set before round 1. No approval, no round 1. Shoot each approved reference at the same widths as the baseline.
6. **Held-out parts.** When sampling (a big target), set aside 2 to 4 parts (UI: pages) before round 1, covering different kinds of content where possible. They are never sampled or shown to the panel during rounds and are used only in the final blind pick (see Stop). Record the list in the report.
7. **Run folder.** Create `improve-loop-<date>-<slug>/` in the owner's docs and start the report there.

## Each round

1. **Prepare.** For a big target (a whole site, a long document set), pick a rotating sample: the fixed core the caller names plus parts not seen recently, so every part is reviewed over the run, never the held-out parts. Retake UI screenshots for the sample. When the bar includes references, put the current version and every reference into one unlabelled batch: neutral item letters, a fresh shuffle per panel member, file names and metadata that reveal nothing. References are rescored every round together with ours, so a drift in leniency moves both.
2. **Review.** Start one fresh, isolated, read-only review context per panel member, all in parallel. Never reuse an earlier round's context. Do not edit the target while the panel runs. A timeout, error or missing reply is not a score; rerun that member once. If it fails again, stop and report the bar as not reached, naming the member. Never judge the bar or a stall from a partial panel.
3. **Answer findings.** Check each finding and its severity yourself. Agree: smallest fix, preferring delete or narrow over adding. Disagree: reply with evidence. Nit or scope creep: decline in one line. A dispute still open after two replies goes to the owner.
4. **Verify.** Run the artifact's checks and the guardrails after the fixes. If a fix breaks one, undo the fix. If the change grew, cut before the next round.
5. **Record.** Add the scores to the table and the outcomes to the ledger (id, severity, outcome, reviewer, round).

Brief per member (review contexts get no history, so it must stand alone). Judges get no project context: no project or brand history, no earlier scores, no round number, no target score, and no hint which batch item is the version being improved. In UI mode they see only the lettered batch; for a non-visual target they get the artifact itself, without its project history.

```
Review only. Do not edit, commit, push, deploy, or start subagents.
Items: <letters, each with its screenshots or files>
Criteria: <the bar's quality description, without target numbers> Rules: <guardrails>
Open findings to recheck: <ids and claims only, no scores>
Score every item against the criteria.
blocker = fails the criteria or a rule. should = a real gap a user would notice. nit = the rest.
Reply:
SCORE <letter>: <n>/10   (one line per item)
R1 [blocker|should|nit] <item letter> <location> <claim>. Fix: <suggestion>
(keep ids stable; mark rechecked ids resolved or still open)
```

You hold the letter mapping and translate the replies: the version being improved gets its score and findings, and each reference's score is used only for the "references beaten" part of the bar.

## Stop

- **Bar met** on the current version. When sampling, a full final check must pass too: a fresh review of the whole target (UI: every page and width) by every panel member against the same bar. It does not count as a round. If it fails, its findings start the next round within budget; with no budget left, the bar is not reached. Then a **final blind pick** on the held-out parts: each member, in a fresh context, makes A-or-B picks with the order swapped, the current version against the best-scoring reference and against the starting version. It passes when every member prefers the current version over the start in both orders and no member prefers the reference in both orders. A failed pick works like a failed final check.
- **Budget, cap or stall** reached. Report "bar not reached", never approval.
- **Dispute** unresolved after two replies. Show both sides in two or three lines each. The owner decides.

## Output

Write `report.md` in the run folder with frontmatter (`date`, `title`, `status: open`, `tags`, `description`) and:

- a score table, reviewer by round (`no score` where a member gave none; never invent one);
- the ledger with one-line reasons for every decline and dispute;
- what changed, with before and after (diff size, key screenshots side by side in UI mode);
- the stop reason, references used, and any missing provider or model.

Keep screenshots in `shots/` inside the folder. Commit, push and deploy follow the project's own rules; the loop does none of them by default.

## Guardrails

The caller can add fixed rules that hold for every fix and every round. They go into each brief and are checked in the Verify step. Example for a marketing-site run: copy may be reworded and restructured, but no new facts, numbers, customer names or claims; the style linter and the banned-words list apply.

## Default panel

This section is configuration, not core behavior. Default members: two independent reviewers from different model providers, each at high reasoning effort, dispatched only through the routes your platform policy allows. Default reference researchers: one per provider, whatever the panel. Start each member as a new review task per round with a read-only role; never reuse an earlier round's task. UI screenshots use a browser automation tool such as Playwright.

On engineering targets (code, plan, spec, platform) or when the owner asks for it, add a third scored member with a principal-engineer stance: it must meet the same bar.

Any extra reviewer the owner names is added as an extra scored member, judging by the same criteria. Extra members never replace a default member, and the loop ends only when they also meet the bar.
