#!/bin/sh
# Diff a lane's stated expected reds against the suite's classified list. Usage: red-set-reconcile.sh <expected.txt> <classified.md>
# Keys are "<spec-basename> :<line>" tokens; write one per red. Comma form "name :244, :289" is not accepted input. A ".spec.<ext>" suffix on the basename is dropped, so "x.spec.ts :244" and "x :244" are the same key.
# Line numbers are compared as literal strings: ":007" and ":7" are different keys.
# Malformed entries (a name :number followed by anything but a space or , . ) | or backtick, such as ":41a" or ":41-42", or a non-blank, non-# line in <expected.txt> that holds no key) exit 2 before any comparison.
# Exit 0 clean, 1 drift, 2 cannot reconcile (missing args, unreadable or missing file, or a malformed entry).
set -eu
[ $# -eq 2 ] && [ -f "$1" ] && [ -r "$1" ] && [ -f "$2" ] && [ -r "$2" ] || { echo "red-set-reconcile: need two existing, readable files" >&2; exit 2; }
keys() { grep -oE '[A-Za-z0-9._-]+ :[0-9]+($|[[:space:],.)|`])' "$1" | sed -e 's/[^0-9]$//' -e 's/\.spec\.[a-z]* :/ :/' | sort -u; }
BAD='[A-Za-z0-9._-]+ :[0-9]+[^0-9[:space:],.)|`]'
m=$(grep -nE "$BAD" "$1" "$2" || true)
[ -z "$m" ] || { echo "red-set-reconcile: malformed entry:" >&2; echo "$m" >&2; exit 2; }
KEYRE='[A-Za-z0-9._-]+ :[0-9]+($|[[:space:],.)|`])'
m=$(grep -vE '^[[:space:]]*(#|$)' "$1" | grep -vE "$KEYRE" || true)
[ -z "$m" ] || { echo "red-set-reconcile: malformed entry (no key) in $1:" >&2; echo "$m" >&2; exit 2; }
E=$(mktemp); C=$(mktemp); keys "$1" > "$E"; keys "$2" > "$C"
echo "== stated by lane, absent from classified list =="; comm -23 "$E" "$C"
echo "== in classified list, not stated by lane =="; comm -13 "$E" "$C"
n=$(comm -3 "$E" "$C" | wc -l | tr -d ' '); rm -f "$E" "$C"
echo "unmatched: $n"; [ "$n" -eq 0 ]
