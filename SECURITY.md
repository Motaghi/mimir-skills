# Security and private content

## Report privately

If you find private-looking content in this repository, such as a personal name or address, a credential or token, an internal path or hostname, or customer or project data that should not be public, do not post it in a public issue, pull request or discussion. Posting it there makes the exposure worse.

Use GitHub's private vulnerability reporting instead: open the repository's Security tab and choose "Report a vulnerability". Say which file and line, and what kind of content it is. You do not need to paste the sensitive value itself.

The same route covers a security problem in a skill or script, for example a command a skill tells an agent to run that could do harm.

## What to expect

Reports are read by the maintainer. A confirmed problem is fixed in a new commit, and where a credential was exposed it should be treated as compromised and rotated by its owner whether or not the file is changed.

## Not security reports

Wrong or unclear instructions in a skill, missing credits and typos belong in ordinary public issues, see [CONTRIBUTING.md](CONTRIBUTING.md).
