#!/bin/sh
# The recommended commit commands name exact files only: pathspec magic in a file name is never expanded.
set -eu
H=$(cd "$(dirname "$0")/.." && pwd); S=$H/..; D=$(mktemp -d); trap 'rm -rf "$D"' EXIT
# the skill and the example profile both recommend the literal form
grep -q -- '--literal-pathspecs add' "$S/SKILL.md" || { echo "SKILL.md does not recommend --literal-pathspecs for add"; exit 1; }
grep -q -- '--literal-pathspecs commit' "$S/SKILL.md" || { echo "SKILL.md does not recommend --literal-pathspecs for commit"; exit 1; }
grep -q -- '--literal-pathspecs add' "$S/profiles/example.md" || { echo "example profile lacks the literal form"; exit 1; }
# behaviour: committing the file named '*.txt' must not sweep in other .txt files
git init --quiet "$D/r"; git -C "$D/r" config user.email t@example.com; git -C "$D/r" config user.name t
echo base > "$D/r/base.md"; git -C "$D/r" add base.md; git -C "$D/r" commit --quiet -m init
echo a > "$D/r/a.txt"; echo b > "$D/r/b.txt"; echo star > "$D/r/*.txt"
( cd "$D/r" && git --literal-pathspecs add -- '*.txt' && git --literal-pathspecs commit --quiet -m star -- '*.txt' )
tracked=$(git -C "$D/r" ls-files | sort | tr '\n' ' ')
[ "$tracked" = '*.txt base.md ' ] || { echo "literal pathspec expanded: $tracked"; exit 1; }
# without the flag the same command takes every .txt file, which is why the flag is required
git init --quiet "$D/q"; git -C "$D/q" config user.email t@example.com; git -C "$D/q" config user.name t
echo base > "$D/q/base.md"; git -C "$D/q" add base.md; git -C "$D/q" commit --quiet -m init
echo a > "$D/q/a.txt"; echo star > "$D/q/*.txt"
( cd "$D/q" && git add -- '*.txt' )
git -C "$D/q" ls-files | grep -qx 'a.txt' || { echo "control case did not expand the pattern"; exit 1; }
echo ok
