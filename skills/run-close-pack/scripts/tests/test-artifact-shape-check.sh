#!/bin/sh
# artifact-shape-check: correct pair passes; swapped pair fails; upload carrying the manifest fails;
# upload missing the entry file fails; snapshot missing the manifest fails; a snapshot holding a
# lookalike name (packageXjson) instead of the real manifest fails; a missing archive path exits 2.
set -eu
H=$(cd "$(dirname "$0")/.." && pwd); D=$(mktemp -d); trap 'rm -rf "$D"' EXIT; cd "$D"
mkdir up snap; echo x > up/index.html; echo '{}' > snap/package.json; echo x > snap/index.html
(cd up && zip -q ../upload.zip index.html); (cd snap && zip -q ../snapshot.zip package.json index.html)
sh "$H/artifact-shape-check.sh" upload.zip snapshot.zip >/dev/null || { echo "good pair failed"; exit 1; }
sh "$H/artifact-shape-check.sh" snapshot.zip upload.zip >/dev/null 2>&1 && { echo "swapped pair passed"; exit 1; }
echo '{}' > up/package.json; (cd up && zip -q ../upload2.zip index.html package.json)
sh "$H/artifact-shape-check.sh" upload2.zip snapshot.zip >/dev/null 2>&1 && { echo "upload with manifest passed"; exit 1; }
mkdir up3; echo x > up3/other.txt; (cd up3 && zip -q ../upload3.zip other.txt)
sh "$H/artifact-shape-check.sh" upload3.zip snapshot.zip >/dev/null 2>&1 && { echo "upload missing entry passed"; exit 1; }
mkdir badsnap; echo x > badsnap/index.html; (cd badsnap && zip -q ../badsnap.zip index.html)
sh "$H/artifact-shape-check.sh" upload.zip badsnap.zip >/dev/null 2>&1 && { echo "snapshot missing manifest passed"; exit 1; }
mkdir fakesnap; echo x > fakesnap/packageXjson; echo x > fakesnap/index.html
(cd fakesnap && zip -q ../fakesnap.zip packageXjson index.html)
sh "$H/artifact-shape-check.sh" upload.zip fakesnap.zip >/dev/null 2>&1 && { echo "lookalike manifest passed"; exit 1; }
code=0
sh "$H/artifact-shape-check.sh" nope.zip snapshot.zip >/dev/null 2>&1 || code=$?
[ "$code" -eq 2 ] || { echo "missing upload path exit code $code, want 2"; exit 1; }
code=0
sh "$H/artifact-shape-check.sh" upload.zip nope.zip >/dev/null 2>&1 || code=$?
[ "$code" -eq 2 ] || { echo "missing snapshot path exit code $code, want 2"; exit 1; }
code=0
sh "$H/artifact-shape-check.sh" >/dev/null 2>&1 || code=$?
[ "$code" -eq 2 ] || { echo "no args exit code $code, want 2"; exit 1; }
echo ok
