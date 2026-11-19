#!/bin/sh
# Runs every test-*.sh beside this file. A test passes when it exits 0.
set -u
cd "$(dirname "$0")"; fail=0; log=$(mktemp "${TMPDIR:-/tmp}/rlt.XXXXXX") || exit 1
trap 'rm -f "$log"' EXIT
for t in test-*.sh; do
  if sh "$t" >"$log" 2>&1; then echo "PASS $t"; else echo "FAIL $t"; cat "$log"; fail=1; fi
done
exit $fail
