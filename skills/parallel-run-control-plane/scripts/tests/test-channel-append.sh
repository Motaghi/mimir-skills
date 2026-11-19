#!/bin/sh
# channel-append: appends with prefix and stamp, refuses doubled prefixes, embedded newlines, and non-append edits.
set -eu
H=$(cd "$(dirname "$0")/.." && pwd); D=$(mktemp -d); trap 'rm -rf "$D"' EXIT; CH="$D/chan.md"; : > "$CH"
call() { if out=$(CHANNEL="$CH" ROLE=PM sh "$H/channel-append.sh" "$1" 2>&1); then rc=0; else rc=$?; fi; }

call "first line"
[ "$rc" -eq 0 ] || { echo "first append failed ($rc): $out"; exit 1; }
grep -qE '^- PM [0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2} first line$' "$CH" || { echo "no stamped line"; exit 1; }
[ -f "$CH.seal" ] || { echo "no seal"; exit 1; }

b1=$(cksum < "$CH")
call "- PM doubled"
[ "$rc" -ne 0 ] || { echo "doubled bullet accepted"; exit 1; }
b2=$(cksum < "$CH")
[ "$b1" = "$b2" ] || { echo "doubled bullet mutated the channel"; exit 1; }

b1=$(cksum < "$CH")
call "PM already prefixed"
[ "$rc" -ne 0 ] || { echo "doubled role accepted"; exit 1; }
b2=$(cksum < "$CH")
[ "$b1" = "$b2" ] || { echo "doubled role mutated the channel"; exit 1; }

b1=$(cksum < "$CH")
call "$(printf 'a\nb')"
[ "$rc" -eq 2 ] || { echo "embedded newline not refused with exit 2 (got $rc): $out"; exit 1; }
case "$out" in *REFUSED*) ;; *) echo "embedded newline refusal missing REFUSED message: $out"; exit 1;; esac
b2=$(cksum < "$CH")
[ "$b1" = "$b2" ] || { echo "embedded newline mutated the channel"; exit 1; }

echo "- WATCH 2026-01-01T12:01 raw append by another tool" >> "$CH"
call "after raw append"
[ "$rc" -eq 0 ] || { echo "plain append refused: $out"; exit 1; }

printf -- '- WATCH 2026-01-01T12:02 no newline' >> "$CH"
call "after no newline"
[ "$rc" -eq 0 ] || { echo "no-newline append refused: $out"; exit 1; }
grep -qE '^- PM [0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2} after no newline$' "$CH" || { echo "no-newline append glued to prior line"; exit 1; }

sed -i.bak 's/first line/edited line/' "$CH"
b1=$(cksum < "$CH")
call "after edit"
[ "$rc" -ne 0 ] || { echo "in-place edit accepted"; exit 1; }
b2=$(cksum < "$CH")
[ "$b1" = "$b2" ] || { echo "in-place edit mutated the channel further"; exit 1; }

: > "$CH.seal"
call "after empty seal"
[ "$rc" -eq 3 ] || { echo "empty seal did not exit 3 (got $rc): $out"; exit 1; }
case "$out" in *"malformed seal"*) ;; *) echo "empty seal message missing 'malformed seal': $out"; exit 1;; esac

printf '9\n' > "$CH.seal"
call "after size-only seal"
[ "$rc" -eq 3 ] || { echo "size-only seal did not exit 3 (got $rc): $out"; exit 1; }
case "$out" in *"malformed seal"*) ;; *) echo "size-only seal message missing 'malformed seal': $out"; exit 1;; esac

printf 'abc 12345\n' > "$CH.seal"
call "after non-numeric seal"
[ "$rc" -eq 3 ] || { echo "non-numeric seal did not exit 3 (got $rc): $out"; exit 1; }
case "$out" in *"malformed seal"*) ;; *) echo "non-numeric seal message missing 'malformed seal': $out"; exit 1;; esac

rm -f "$CH.seal"
call "clean reseal before truncation"
[ "$rc" -eq 0 ] || { echo "clean reseal before truncation failed: $out"; exit 1; }
head -c 10 "$CH" > "$CH.t" && mv "$CH.t" "$CH"
call "after truncation"
[ "$rc" -eq 3 ] || { echo "truncated channel did not exit 3 (got $rc): $out"; exit 1; }
case "$out" in *"channel changed"*) ;; *) echo "truncation message missing 'channel changed': $out"; exit 1;; esac

# concurrent writers: every line lands, none is refused, and the seal still matches
: > "$CH"; : > "$D/none"; rm -f "$CH.seal"
i=0
while [ "$i" -lt 12 ]; do
  ( CHANNEL="$CH" ROLE="W$i" sh "$H/channel-append.sh" "line $i" >"$D/par.$i" 2>&1; echo $? > "$D/par.$i.rc" ) &
  i=$((i + 1))
done
wait
i=0; while [ "$i" -lt 12 ]; do
  [ "$(cat "$D/par.$i.rc")" = 0 ] || { echo "parallel writer $i failed: $(cat "$D/par.$i")"; exit 1; }
  grep -qE "^- W$i [0-9T:-]+ line $i\$" "$CH" || { echo "parallel writer $i line missing"; exit 1; }
  i=$((i + 1))
done
[ "$(wc -l < "$CH" | tr -d ' ')" -eq 12 ] || { echo "parallel line count wrong"; exit 1; }
call "after the parallel burst"
[ "$rc" -eq 0 ] || { echo "append after parallel burst refused: $out"; exit 1; }
[ ! -e "$CH.lock" ] || { echo "lock left behind"; exit 1; }

# a writer waits while a live process holds the lock, then appends once it is released
before=$(wc -l < "$CH" | tr -d ' ')
ln -s $$ "$CH.lock"
( CHANNEL="$CH" ROLE=HELD sh "$H/channel-append.sh" "waited for the lock" >"$D/held.out" 2>&1; echo $? > "$D/held.rc" ) &
sleep 1
[ "$(wc -l < "$CH" | tr -d ' ')" -eq "$before" ] || { echo "writer appended while the lock was held"; exit 1; }
rm -f "$CH.lock"
wait
[ "$(cat "$D/held.rc")" = 0 ] || { echo "waiting writer failed: $(cat "$D/held.out")"; exit 1; }
grep -q 'HELD .* waited for the lock$' "$CH" || { echo "waiting writer line missing"; exit 1; }

# a lock whose holder is gone is never removed automatically: exit 4, lock untouched, channel unchanged
b1=$(cksum < "$CH")
ln -s 999999 "$CH.lock"
call "after stale lock"
[ "$rc" -eq 4 ] || { echo "stale lock exit was $rc, want 4: $out"; exit 1; }
case "$out" in *"not running"*) ;; *) echo "stale lock message missing: $out"; exit 1;; esac
[ "$(readlink "$CH.lock")" = 999999 ] || { echo "stale lock was removed or changed"; exit 1; }
[ "$b1" = "$(cksum < "$CH")" ] || { echo "stale lock case mutated the channel"; exit 1; }
rm -f "$CH.lock"

# a lock path that is a directory (older lock format) or a link to one is refused: exit 4, nothing written, nothing created inside
b1=$(cksum < "$CH")
mkdir "$CH.lock"; echo 999999 > "$CH.lock/pid"
call "into an old-format lock dir"
[ "$rc" -eq 4 ] || { echo "lock directory exit was $rc, want 4: $out"; exit 1; }
[ "$b1" = "$(cksum < "$CH")" ] || { echo "lock directory case wrote to the channel"; exit 1; }
[ "$(ls "$CH.lock" | tr '\n' ' ')" = "pid " ] || { echo "stray entry created inside the lock directory: $(ls "$CH.lock")"; exit 1; }
rm -rf "$CH.lock"
mkdir "$D/elsewhere"; ln -s "$D/elsewhere" "$CH.lock"
call "through a link to a directory"
[ "$rc" -eq 4 ] || { echo "link-to-directory lock exit was $rc, want 4: $out"; exit 1; }
[ -z "$(ls "$D/elsewhere")" ] || { echo "stray entry created in the linked directory"; exit 1; }
[ "$b1" = "$(cksum < "$CH")" ] || { echo "link-to-directory case wrote to the channel"; exit 1; }
rm -f "$CH.lock"

# ROLE with spaces, newlines or other characters could forge extra records: refused before any lock or write
b1=$(cksum < "$CH")
for badrole in "PM 2026-01-01T00:00 FAKE" "$(printf 'PM\nOTHER')" "PM/x" "PM;x" 'PM$x'; do
  if out=$(CHANNEL="$CH" ROLE="$badrole" sh "$H/channel-append.sh" "hello" 2>&1); then rc=0; else rc=$?; fi
  [ "$rc" -eq 2 ] || { echo "bad ROLE accepted (exit $rc): $badrole"; exit 1; }
done
[ "$b1" = "$(cksum < "$CH")" ] || { echo "bad ROLE mutated the channel"; exit 1; }
[ ! -e "$CH.lock" ] || { echo "bad ROLE left a lock"; exit 1; }

# a signalled writer that is waiting for a lock exits and does not touch the lock it never held
b1=$(cksum < "$CH")
ln -s $$ "$CH.lock"
CHANNEL="$CH" ROLE=SIG sh "$H/channel-append.sh" "must not be written" >"$D/sig.out" 2>&1 &
sigpid=$!
sleep 1
kill -TERM "$sigpid" 2>/dev/null || true
sleep 1
if kill -0 "$sigpid" 2>/dev/null; then echo "signalled writer did not exit"; kill -KILL "$sigpid" 2>/dev/null; exit 1; fi
if wait "$sigpid"; then sigrc=0; else sigrc=$?; fi
[ "$sigrc" -ne 0 ] || { echo "signalled writer reported success"; exit 1; }
[ "$(readlink "$CH.lock")" = "$$" ] || { echo "signalled waiter removed a lock it did not hold"; exit 1; }
[ "$b1" = "$(cksum < "$CH")" ] || { echo "signalled waiter wrote to the channel"; exit 1; }
rm -f "$CH.lock"

echo ok
