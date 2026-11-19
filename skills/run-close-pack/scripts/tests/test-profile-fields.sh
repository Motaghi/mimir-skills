#!/bin/sh
# The profile requirements depend on the close path: build-only fields are marked and the text-only path does not demand them.
set -eu
S=$(cd "$(dirname "$0")/../.." && pwd)
for f in "build command" "upload bundle name" "source snapshot name" "identity string format" "serve port and folder" "worker cap" "load threshold" "report interval" "artifact shape" "pack folder" "pack owners"; do
  grep -q "^- (full path only) $f:" "$S/profiles/example.md" || { echo "example profile does not mark '$f' as full path only"; exit 1; }
done
for f in "texts folder" "text pipeline steps" "previous public version" "durable evidence store path" "channel path" "close docs folder"; do
  grep -q "^- $f:" "$S/profiles/example.md" || { echo "required field '$f' missing or wrongly marked"; exit 1; }
done
grep -q 'text-only path .* needs only' "$S/SKILL.md" || { echo "SKILL.md does not state the text-only field list"; exit 1; }
if grep -q 'Every field must be present' "$S/SKILL.md"; then echo "SKILL.md still requires every field on every path"; exit 1; fi
echo ok
