#!/bin/sh
# Append one prefixed, timestamped line to an append-only channel. Usage: CHANNEL=<file> ROLE=<PREFIX> channel-append.sh "<text>". Exit 0 appended, 1 usage, 2 refused (bad ROLE, bullet, role prefix, or embedded newline), 3 append-only violation, 4 could not get the channel lock.
# ROLE may hold only letters, digits, dot, underscore and hyphen, so one append can never add extra apparent records.
# Line shape: "- <ROLE> <YYYY-MM-DDTHH:MM> <text>" (local time).
# Locking: a lock path that is a directory (or a link to one) is refused with exit 4. The lock is the symlink <channel>.lock whose target is the holder's pid; creating it is atomic, so the pid is never missing. It is held across the seal check, the append and the seal rewrite. A lock whose holder is no longer running is never removed automatically (two waiters could each delete the other's fresh lock); the script exits 4 and names the lock so a person can remove it. Signals make the script exit, and only the holder removes its own lock.
set -eu
[ -n "${CHANNEL:-}" ] && [ -n "${ROLE:-}" ] && [ $# -eq 1 ] || { echo "usage: CHANNEL=<file> ROLE=<PREFIX> $0 \"text\""; exit 1; }
case "$ROLE" in *[!A-Za-z0-9_.-]*) echo "REFUSED: ROLE may only hold letters, digits, dot, underscore and hyphen"; exit 2;; esac
[ -f "$CHANNEL" ] || { echo "FATAL: $CHANNEL missing"; exit 1; }
case "$1" in -*) echo "REFUSED: text already starts with a bullet"; exit 2;; esac
case "$1" in "$ROLE "*) echo "REFUSED: text already starts with the role prefix"; exit 2;; esac
nl=$(printf '\nx'); nl=${nl%x}; case "$1" in *"$nl"*) echo "REFUSED: text contains an embedded newline"; exit 2;; esac
SEAL="$CHANNEL.seal"; LOCK="$CHANNEL.lock"
have_lock=""
release() { [ -z "$have_lock" ] || [ "$(readlink "$LOCK" 2>/dev/null || true)" != "$$" ] || rm -f "$LOCK"; have_lock=""; }
trap release EXIT
trap 'exit 129' HUP
trap 'exit 130' INT
trap 'exit 143' TERM
tries=0
until { [ ! -d "$LOCK" ] || { echo "FATAL: $LOCK is a directory (or a link to one), not a pid lock; it may come from an older version of this script. Remove it by hand if no writer is active"; exit 4; }; ln -s "$$" "$LOCK" 2>/dev/null; }; do
  holder=$(readlink "$LOCK" 2>/dev/null || true)
  if [ -n "$holder" ] && ! kill -0 "$holder" 2>/dev/null && [ "$(readlink "$LOCK" 2>/dev/null || true)" = "$holder" ]; then
    echo "FATAL: $LOCK is held by process $holder, which is not running; remove the lock by hand if no writer is active"; exit 4
  fi
  tries=$((tries + 1)); [ "$tries" -le 300 ] || { echo "FATAL: could not get the channel lock $LOCK"; exit 4; }
  sleep 0.1
done
if [ ! -L "$LOCK" ] || [ "$(readlink "$LOCK" 2>/dev/null || true)" != "$$" ]; then
  echo "FATAL: $LOCK could not be taken as a pid lock"; exit 4
fi
have_lock=1
if [ -f "$SEAL" ]; then
  read -r size sum < "$SEAL" || { size=; sum=; }
  case "$size" in ''|*[!0-9]*) echo "REFUSED: malformed seal"; exit 3;; esac
  [ -n "$sum" ] || { echo "REFUSED: malformed seal"; exit 3; }
  now=$(wc -c < "$CHANNEL" | tr -d ' '); cur=$(head -c "$size" "$CHANNEL" | cksum | cut -d' ' -f1)
  [ "$now" -ge "$size" ] && [ "$cur" = "$sum" ] || { echo "REFUSED: channel changed other than by appending since the last seal"; exit 3; }
fi
[ -s "$CHANNEL" ] && [ "$(tail -c1 "$CHANNEL" | wc -l | tr -d ' ')" -eq 0 ] && printf '\n' >> "$CHANNEL"
printf -- "- %s %s %s\n" "$ROLE" "$(date +%Y-%m-%dT%H:%M)" "$1" >> "$CHANNEL"
printf '%s %s\n' "$(wc -c < "$CHANNEL" | tr -d ' ')" "$(cksum < "$CHANNEL" | cut -d' ' -f1)" > "$SEAL"
echo "APPENDED."
