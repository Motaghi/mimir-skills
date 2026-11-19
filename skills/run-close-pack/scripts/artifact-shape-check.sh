#!/bin/sh
# Confirm the upload bundle and the source snapshot are not swapped. Usage: artifact-shape-check.sh <upload.zip> <snapshot.zip> [entry-file] [manifest-file]; too few arguments or a missing archive path exit 2.
set -eu
[ $# -ge 2 ] || { echo "Usage: artifact-shape-check.sh <upload.zip> <snapshot.zip> [entry-file] [manifest-file]" >&2; exit 2; }
UP=$1; SNAP=$2; ENTRY=${3:-index.html}; MAN=${4:-package.json}; bad=0
for f in "$UP" "$SNAP"; do
  [ -f "$f" ] || { echo "FAIL: $f not found" >&2; exit 2; }
done
has() { unzip -Z1 "$1" | grep -Fqx "$2"; }
has "$UP" "$ENTRY" || { echo "FAIL: $UP lacks $ENTRY at root"; bad=1; }
has "$UP" "$MAN" && { echo "FAIL: $UP carries $MAN at root; the names look swapped"; bad=1; }
has "$SNAP" "$MAN" || { echo "FAIL: $SNAP lacks $MAN at root"; bad=1; }
[ "$bad" -eq 0 ] && echo "artifact-shape-check: ok"
exit "$bad"
