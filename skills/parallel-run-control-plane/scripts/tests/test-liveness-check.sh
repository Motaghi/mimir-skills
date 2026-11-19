#!/bin/sh
# liveness-check: flags silent roles, honours FROZEN (last matching line, first word only), reports ok for fresh and near-future stamps, rejects bad usage, counts processes by working-copy path excluding the checker itself.
set -eu
H=$(cd "$(dirname "$0")/.." && pwd); D=$(mktemp -d); CH="$D/chan.md"; BGPID=""; BGPID2=""; BGPID3=""
trap 'rm -rf "$D" "${D8:-}" "${D12:-}" "${D18:-}"; [ -n "${BGPID:-}" ] && kill "$BGPID" 2>/dev/null; [ -n "${BGPID2:-}" ] && kill "$BGPID2" 2>/dev/null; [ -n "${BGPID3:-}" ] && kill "$BGPID3" 2>/dev/null; :' EXIT
FMT=%Y-%m-%dT%H:%M; now=$(date +$FMT); old=$(date -v-45M +$FMT 2>/dev/null || date -d '45 min ago' +$FMT)
printf -- '- PM %s report point\n- LANE1 %s FROZEN at stop\n- WATCH %s verify cycle\n' "$now" "$old" "$old" > "$CH"
out=$(sh "$H/liveness-check.sh" "$CH" 10 PM LANE1 WATCH REVIEWER)
echo "$out" | grep -q '^PM: ok' || { echo "PM not ok: $out"; exit 1; }
echo "$out" | grep -q '^LANE1: FROZEN' || { echo "FROZEN not honoured: $out"; exit 1; }
echo "$out" | grep -qE '^WATCH: silent 4[4-6]m since' || { echo "WATCH not flagged: $out"; exit 1; }
echo "$out" | grep -q '^REVIEWER: no line ever' || { echo "missing role not reported: $out"; exit 1; }

# t1: last matching line wins for FROZEN, both when it is the last write and when it is not
printf -- '- FLAST %s working\n- FLAST %s FROZEN now\n' "$old" "$now" >> "$CH"
printf -- '- FFIRST %s FROZEN now\n- FFIRST %s working fine\n' "$old" "$now" >> "$CH"
out=$(sh "$H/liveness-check.sh" "$CH" 10 FLAST FFIRST)
echo "$out" | grep -q '^FLAST: FROZEN' || { echo "t1: last-line FROZEN missed: $out"; exit 1; }
echo "$out" | grep -q '^FFIRST: ok' || { echo "t1: stale FROZEN wrongly honoured over fresh last line: $out"; exit 1; }

# t2: FROZEN mentioned as ordinary text (not the first word after the stamp) is not the FROZEN verdict
printf -- '- PMTALK %s LANE1 posted FROZEN, acknowledged\n' "$old" >> "$CH"
out=$(sh "$H/liveness-check.sh" "$CH" 10 PMTALK)
echo "$out" | grep -q '^PMTALK: silent' || { echo "t2: mid-sentence FROZEN not reported silent: $out"; exit 1; }
echo "$out" | grep -q '^PMTALK: FROZEN' && { echo "t2: mid-sentence FROZEN wrongly honoured: $out"; exit 1; }

# t3: role name is matched as a fixed field, not a regex, so a dot does not cross-match another role
printf -- '- LANEX1 %s off track\n' "$now" >> "$CH"
out=$(sh "$H/liveness-check.sh" "$CH" 10 "LANE.1")
echo "$out" | grep -qF 'LANE.1: no line ever' || { echo "t3: dotted role name cross-matched an unrelated line: $out"; exit 1; }

# t4: process count by working-copy path, excluding the checker's own shell
mkdir -p "$D/wc path.dir"
sh -c 'sleep 20 & wait' "$D/wc path.dir" &
BGPID=$!
sleep 0.3
printf -- '- HASPROC %s idle\n' "$old" >> "$CH"
out=$(sh "$H/liveness-check.sh" "$CH" 10 "HASPROC=$D/wc path.dir")
echo "$out" | grep -q 'processes=1' || { echo "t4: live process on the working-copy path not counted: $out"; exit 1; }
printf -- '- NOPROC %s idle\n' "$old" >> "$CH"
out=$(sh "$H/liveness-check.sh" "$CH" 10 "NOPROC=$D/nowhere")
echo "$out" | grep -q 'processes=0' || { echo "t4: absent working-copy path miscounted: $out"; exit 1; }
kill "$BGPID" 2>/dev/null; BGPID=""

# t4b: a session whose working directory is the path but whose argv never names it still counts
if command -v lsof >/dev/null 2>&1; then
  mkdir -p "$D/cwdonly"
  W="$D/cwdonly" sh -c 'cd "$W" && sleep 20' &
  BGPID=$!
  sleep 0.5
  printf -- '- CWDROLE %s idle\n' "$old" >> "$CH"
  out=$(sh "$H/liveness-check.sh" "$CH" 10 "CWDROLE=$D/cwdonly")
  echo "$out" | grep -qE 'processes=[1-9]' || { echo "t4b: cwd-only session not counted: $out"; exit 1; }
  kill "$BGPID" 2>/dev/null; BGPID=""
else
  echo "note: lsof not found; t4b skipped"
fi
# t4c: a zero count says it is a hint, not proof
out=$(sh "$H/liveness-check.sh" "$CH" 10 "NOPROC=$D/nowhere")
echo "$out" | grep -q 'does not prove the session is dead' || { echo "t4c: zero count not hedged: $out"; exit 1; }

# t5: a stamp a few minutes in the future (clock skew) clamps to ok, not a false silent
future=$(date -v+5M +$FMT 2>/dev/null || date -d '5 min' +$FMT)
printf -- '- SKEW %s from the future\n' "$future" >> "$CH"
out=$(sh "$H/liveness-check.sh" "$CH" 10 SKEW)
echo "$out" | grep -q '^SKEW: ok' || { echo "t5: near-future skew wrongly flagged silent: $out"; exit 1; }

# t6: fewer than two arguments is a caller error, not a verdict; exit 2
if sh "$H/liveness-check.sh" >/dev/null 2>&1; then rc=0; else rc=$?; fi
[ "$rc" -eq 2 ] || { echo "t6: no-args exit code was $rc, expected 2"; exit 1; }

# t7: the latest line has no text after the stamp; must be an ordinary line, not a crash
printf -- '- T7ROLE %s \n' "$old" >> "$CH"
if out=$(sh "$H/liveness-check.sh" "$CH" 10 T7ROLE 2>"$D/err7"); then rc=0; else rc=$?; fi
[ "$rc" -eq 0 ] || { echo "t7: exit code was $rc, expected 0"; exit 1; }
echo "$out" | grep -q '^T7ROLE: silent' || { echo "t7: text-less stamp not reported silent: $out"; exit 1; }
[ -s "$D/err7" ] && { echo "t7: unexpected stderr: $(cat "$D/err7")"; exit 1; }

# t8: channel text with shell glob metacharacters must not expand against the caller's cwd
D8=$(mktemp -d); : > "$D8/FROZEN"
printf -- '- T8ROLE %s F??ZEN note\n' "$old" >> "$CH"
out=$(cd "$D8" && sh "$H/liveness-check.sh" "$CH" 10 T8ROLE)
echo "$out" | grep -q '^T8ROLE: silent' || { echo "t8: glob text not reported silent (cwd leaked in): $out"; exit 1; }
echo "$out" | grep -q '^T8ROLE: FROZEN' && { echo "t8: glob text wrongly honoured as FROZEN via cwd match: $out"; exit 1; }
rm -rf "$D8"; D8=""

# t9: a CRLF line's FROZEN token must still be honoured, not silently defeated by a trailing \r
printf -- '- T9ROLE %s FROZEN queue wait\r\n' "$old" >> "$CH"
out=$(sh "$H/liveness-check.sh" "$CH" 10 T9ROLE)
echo "$out" | grep -q '^T9ROLE: FROZEN' || { echo "t9: CRLF line did not honour FROZEN: $out"; exit 1; }
# t9b: the worst case, FROZEN itself is the last token before \r\n so the \r sticks to it directly
printf -- '- T9B %s FROZEN\r\n' "$old" >> "$CH"
out=$(sh "$H/liveness-check.sh" "$CH" 10 T9B)
echo "$out" | grep -q '^T9B: FROZEN' || { echo "t9b: CRLF-terminated FROZEN token not honoured: $out"; exit 1; }

# t10: a non-integer or negative threshold is a usage error, not a silent pass-through
for bad in abc -5; do
  if out10=$(sh "$H/liveness-check.sh" "$CH" "$bad" PM 2>"$D/err10"); then rc=0; else rc=$?; fi
  [ "$rc" -eq 2 ] || { echo "t10: threshold '$bad' exit code was $rc, expected 2"; exit 1; }
  [ -z "$out10" ] || { echo "t10: threshold '$bad' wrote to stdout: $out10"; exit 1; }
  grep -q '^usage:' "$D/err10" || { echo "t10: threshold '$bad' missing usage line on stderr"; exit 1; }
done

# t11: a nonexistent channel is a usage error with a clear message, not an awk crash
if out11=$(sh "$H/liveness-check.sh" "$D/does-not-exist.md" 10 PM 2>"$D/err11"); then rc=0; else rc=$?; fi
[ "$rc" -eq 2 ] || { echo "t11: nonexistent channel exit code was $rc, expected 2"; exit 1; }
grep -q 'cannot read channel' "$D/err11" || { echo "t11: nonexistent channel missing message on stderr: $(cat "$D/err11")"; exit 1; }

# t12: one working-copy path must not match another path that merely starts with it
D12=$(mktemp -d); mkdir -p "$D12/wc2"
sh -c 'sleep 20 & wait' "$D12/wc2/marker" &
BGPID2=$!
sleep 0.3
printf -- '- T12ROLE %s idle\n' "$old" >> "$CH"
out=$(sh "$H/liveness-check.sh" "$CH" 10 "T12ROLE=$D12/wc")
echo "$out" | grep -q 'processes=0' || { echo "t12: prefix collision falsely matched: $out"; exit 1; }
out=$(sh "$H/liveness-check.sh" "$CH" 10 "T12ROLE=$D12/wc2")
echo "$out" | grep -q 'processes=1' || { echo "t12: exact working-copy path not matched: $out"; exit 1; }
kill "$BGPID2" 2>/dev/null; BGPID2=""; rm -rf "$D12"; D12=""

# t13: an impossible stamp (99:99) must not be matched or drive a negative age; an earlier valid line still wins
printf -- '- T13ROLE %s idle\n- T13ROLE 2026-13-45T99:99 bogus\n' "$old" >> "$CH"
out=$(sh "$H/liveness-check.sh" "$CH" 10 T13ROLE)
echo "$out" | grep -q '^T13ROLE: silent' || { echo "t13: impossible stamp not skipped, or wrongly reported ok: $out"; exit 1; }
echo "$out" | grep -q '^T13ROLE: ok' && { echo "t13: impossible stamp wrongly read as fresh (negative age): $out"; exit 1; }

# t14: a directory as the channel is a usage error with a clear message, not a silent empty read
mkdir -p "$D/chandir"
if out14=$(sh "$H/liveness-check.sh" "$D/chandir" 10 PM 2>"$D/err14"); then rc=0; else rc=$?; fi
[ "$rc" -eq 2 ] || { echo "t14: directory channel exit code was $rc, expected 2"; exit 1; }
grep -q 'cannot read channel' "$D/err14" || { echo "t14: directory channel missing message on stderr: $(cat "$D/err14")"; exit 1; }

# t15: a seven-digit threshold is a usage error
if out15=$(sh "$H/liveness-check.sh" "$CH" 9999999 PM 2>"$D/err15"); then rc=0; else rc=$?; fi
[ "$rc" -eq 2 ] || { echo "t15: threshold 9999999 exit code was $rc, expected 2"; exit 1; }
grep -q '^usage:' "$D/err15" || { echo "t15: threshold 9999999 missing usage line on stderr"; exit 1; }

# t16: a UTF-8 BOM on the channel's first line must not hide that line
D16=$(mktemp -d); CH16="$D16/chan.md"
printf '\357\273\277- T16ROLE %s solo line\n' "$old" > "$CH16"
out=$(sh "$H/liveness-check.sh" "$CH16" 10 T16ROLE)
echo "$out" | grep -q '^T16ROLE: no line ever' && { echo "t16: BOM-prefixed line not matched: $out"; exit 1; }
echo "$out" | grep -qE '^T16ROLE: (silent|ok)' || { echo "t16: BOM-prefixed line did not yield a normal verdict: $out"; exit 1; }
rm -rf "$D16"

# t17: a role name containing a backslash is compared literally, not escape-processed away
printf -- '- A\\B %s working\n' "$now" >> "$CH"
out=$(sh "$H/liveness-check.sh" "$CH" 10 'A\B')
echo "$out" | grep -qF 'A\B: ok' || { echo "t17: backslash role name not matched: $out"; exit 1; }

# t18: a working-copy path given with a trailing slash still matches
D18=$(mktemp -d); mkdir -p "$D18/wc"
sh -c 'sleep 20 & wait' "$D18/wc/marker" &
BGPID3=$!
sleep 0.3
printf -- '- T18ROLE %s idle\n' "$old" >> "$CH"
out=$(sh "$H/liveness-check.sh" "$CH" 10 "T18ROLE=$D18/wc/")
echo "$out" | grep -q 'processes=1' || { echo "t18: trailing-slash working-copy path not matched: $out"; exit 1; }
kill "$BGPID3" 2>/dev/null; BGPID3=""; rm -rf "$D18"; D18=""

# t19: thresholds of a day or more are valid now that ages use full timestamps
printf -- '- T19ROLE %s long silence\n' "$(date -v-3d +$FMT 2>/dev/null || date -d '3 days ago' +$FMT)" >> "$CH"
out=$(sh "$H/liveness-check.sh" "$CH" 1440 T19ROLE)
echo "$out" | grep -qE '^T19ROLE: silent 43[0-9][0-9]m since' || { echo "t19: three-day silence not reported with its full age: $out"; exit 1; }
out=$(sh "$H/liveness-check.sh" "$CH" 9000 T19ROLE)
echo "$out" | grep -q '^T19ROLE: ok' || { echo "t19: threshold above the age not ok: $out"; exit 1; }

# t20: the same HH:MM a day ago is not fresh (an HH:MM-modulo-a-day check would call it ok)
printf -- '- T20ROLE %s a day ago\n' "$(date -v-1d +$FMT 2>/dev/null || date -d '1 day ago' +$FMT)" >> "$CH"
out=$(sh "$H/liveness-check.sh" "$CH" 10 T20ROLE)
echo "$out" | grep -qE '^T20ROLE: silent 14[0-9][0-9]m since' || { echo "t20: day-old stamp wrongly fresh: $out"; exit 1; }

# t21: a stamp far in the future is reported as silent with a note, not ok
printf -- '- T21ROLE %s far future\n' "$(date -v+2d +$FMT 2>/dev/null || date -d '2 days' +$FMT)" >> "$CH"
out=$(sh "$H/liveness-check.sh" "$CH" 10 T21ROLE)
echo "$out" | grep -q '^T21ROLE: silent, stamp in the future' || { echo "t21: far-future stamp not flagged: $out"; exit 1; }

# t22: an old-style HH:MM stamp is not a matching line
printf -- '- T22ROLE 12:00 old style\n' >> "$CH"
out=$(sh "$H/liveness-check.sh" "$CH" 10 T22ROLE)
echo "$out" | grep -q '^T22ROLE: no line ever' || { echo "t22: HH:MM stamp matched: $out"; exit 1; }

echo ok
