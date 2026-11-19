# Fixed point and traceability

## Rule

A review of a change compares it against something fixed. Name the comparison base first, then judge the diff along two axes and keep them apart. The standards axis asks whether the change follows the standards the project has written down. The traceability axis asks whether the change does what was asked: every requirement shows up in the diff, and every behavior in the diff traces back to a requirement. Report the two axes under separate headings. Never merge them into one ranked list, and never name one winner across them.

Where the standards and the originating request live is settled from the project's own files, the task record in the task tracker, the diff itself and the output of the no-mistakes gate when it has run on this change. If none of them says, the question goes to the orchestrator. No setup step is run to manufacture an answer.

## Why

A change can pass one axis and fail the other. Code that follows every convention while building the wrong thing passes on standards and fails on traceability. Code that does exactly what was requested while ignoring the project's conventions does the reverse. A single blended verdict lets the clean axis hide the broken one, and a reader who sees one score cannot tell which kind of problem they have.

A fixed point also keeps the review honest about size. Without a named base, "the changes" drifts to whatever the reviewer happened to read, and an empty or mistaken comparison is only discovered after the work has been spent on it.

## Checks

For each check, cite the ref, the file and line, or the quoted spec line behind the answer. A check with no citation is reported as unverified. This file spawns nothing. If the two axes are better reviewed by separate reviewers, that is a routing request to the orchestrator, who decides under its own slot limits and write rules.

1. Fixed point: is the comparison base named exactly (a commit, branch, tag or the merge-base with the main line), does it resolve, and is the diff against it non-empty? Compare against the merge-base so that changes made on the other side since the branch point are not counted. A base that does not resolve, or an empty diff, stops the review here; report the remaining checks as unverified. If no base was given, report that to the orchestrator and stop; do not guess one.
2. Spec source: was the originating request or spec found, and is its source named? Look in this order: a request id in the commit messages, resolved through the task tracker; a path the requester passed; a spec or plan file in the project or its docs that matches the branch or feature. If the search finds nothing and the requester confirms there is none, record "no spec available", and report checks 5 to 7 as unverified. Do not reconstruct a spec from the diff and then grade the diff against it.
3. Standards sources: were the files that document how code is written in this project searched for and listed by path? Search the project for all of them: a coding standards file, a contributing guide, formatter and lint configuration, style rules in AGENTS.md or CLAUDE.md, and decision records. A coding standards file and a contributing guide must be on the list whenever they exist. A list that stops at the first file found fails.
4. Standards findings: does any hunk break a documented standard? Each finding cites the standard (file and rule) and quotes the hunk. Skip anything the project's tooling already enforces, since the tool will report it. A breach of a written rule is a hard finding. A design smell that no written rule covers is a judgment call, labelled as one, and a documented project standard always outranks it. This file holds no smell list. The criteria that exist elsewhere in the package are narrow: pass-through layers and one-caller wrappers (minimize-reader-load.md checks 1 and 2, deep-modules.md check 1), one choice made in several places (laziness.md check 2), and branching on one concept spread over several files (model-the-domain.md check 3). A smell outside those has no criterion in this package, so it is at most a labelled judgment call with a quoted hunk. If the project documents no standards, say that the standards axis has nothing to check against and report it that way.
5. Missing or partial requirements: is every requirement in the spec present in the diff? For each, quote the spec line and cite the file and line that implements it. A requirement with no implementing line is missing; one with only part of its condition covered is partial.
6. Unrequested behavior: does every behavior change in the diff trace to a spec line? Name the hunk and the line it traces to. A behavior change with no line is scope creep and is reported as such, even when the addition looks useful.
7. Looks right, is wrong: for each requirement that appears implemented, does the code do what the spec line says in the cases the line names (limits, empty input, the error path)? Quote both the spec line and the code.
8. Separate reporting: are the findings given under one heading for standards and one for traceability, each with its own count and its own worst finding, and with no combined ranking? A closing line that picks one overall winner fails.

## Example

A branch adds a retry limit to an export job. The requester names `main` as the fixed point. Check 1 resolves it, finds 6 commits and a non-empty diff, and compares against the merge-base. A commit message says "closes T-212". Check 2 resolves that id through the task tracker and quotes its text: retry up to three times, then mark the job failed and notify the owner. Check 3 finds a contributing guide and a lint configuration and lists both by path.

Check 5 finds the three retries and the failed status in `export/job.py`, but no owner notification anywhere in the diff: partial, with the spec line quoted. Check 6 finds a new cache layer for the export queue that no spec line asks for: scope creep, with the hunk named. Check 4 finds one breach of the contributing guide's logging rule, cited by file and rule. The report gives the traceability findings (one partial, one unrequested) under their own heading and the standards finding under another. It gives no merge verdict, since that belongs to the project's code-review process.

## When it does not apply

- No fixed point can be named or confirmed. Check 1 fails and nothing further is claimed.
- The subject is a document, a plan or a design instead of a diff. Artifact review belongs to the reviewer sub-agent, which can take this file's checks 2 and 5 to 8 as input.
- A change with no originating request, such as an exploratory spike. Run checks 1, 3 and 4 only and mark the rest not applicable, saying why.
- Reviewing which changes lowered a test or check bar. quality-bar-guard.md covers that; here the standards axis only asks about written rules.
- Giving the merge verdict. This file supplies findings per axis and nothing more.
