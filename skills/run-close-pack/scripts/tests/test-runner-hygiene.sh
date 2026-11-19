#!/bin/sh
# The test runner keeps its log in a private mktemp file, never at a predictable path, and removes it afterwards.
set -eu
H=$(cd "$(dirname "$0")" && pwd); D=$(mktemp -d); trap 'rm -rf "$D"' EXIT
mkdir "$D/t"; cp "$H/run.sh" "$D/t/run.sh"
printf '#!/bin/sh\nls "$TMPDIR" | grep -c "^rlt\\." > "$TMPDIR/seen"\nexit 0\n' > "$D/t/test-probe.sh"
mkdir "$D/tmp"
TMPDIR="$D/tmp" sh "$D/t/run.sh" >/dev/null 2>&1 || { echo "runner failed"; exit 1; }
[ "$(cat "$D/tmp/seen")" = 1 ] || { echo "runner log not created through TMPDIR with mktemp"; exit 1; }
[ -z "$(ls "$D/tmp" | grep '^rlt\.' || true)" ] || { echo "runner log left behind"; exit 1; }
# a planted symlink at the old predictable name is never followed
ln -s "$D/victim" "/tmp/rlt.$$" 2>/dev/null && planted=1 || planted=""
printf '#!/bin/sh\nexit 1\n' > "$D/t/test-probe.sh"
TMPDIR="$D/tmp" sh "$D/t/run.sh" >/dev/null 2>&1 || true
[ -z "$planted" ] || rm -f "/tmp/rlt.$$"
[ ! -e "$D/victim" ] || { echo "runner wrote through a planted symlink"; exit 1; }
echo ok
