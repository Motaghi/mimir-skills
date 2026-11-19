#!/bin/sh
# classify_changes.py: sibling check against an explicitly given session repo, a repository with no commits, and the block list.
set -eu
H=$(cd "$(dirname "$0")/.." && pwd); D=$(mktemp -d); trap 'rm -rf "$D"' EXIT
PY=${PYTHON:-python3}
status() { printf '%s' "$1" | "$PY" -c 'import json,sys; print(json.load(sys.stdin)["tree_status"])'; }
field() { printf '%s' "$1" | "$PY" -c 'import json,sys; print(json.load(sys.stdin)[sys.argv[1]])' "$2"; }
mkrepo() {
  git init --quiet "$1"; git -C "$1" config user.email t@example.com; git -C "$1" config user.name t
  echo base > "$1/base.txt"; git -C "$1" add base.txt; git -C "$1" commit --quiet -m "init"
}
mkrepo "$D/session"; mkrepo "$D/other"
echo change > "$D/other/new.txt"

# s1: changes live in another repository than the session's: sibling_confirm
out=$(cd "$D/other" && "$PY" "$H/classify_changes.py" --session-repo "$D/session")
[ "$(status "$out")" = sibling_confirm ] || { echo "s1: expected sibling_confirm: $out"; exit 1; }
[ "$(field "$out" sibling_repo)" = True ] || { echo "s1: sibling_repo not true: $out"; exit 1; }

# s2: session repo given as a subfolder of the changed repository: safe
mkdir "$D/other/sub"
out=$(cd "$D/other" && "$PY" "$H/classify_changes.py" --session-repo "$D/other/sub")
[ "$(status "$out")" = safe ] || { echo "s2: expected safe: $out"; exit 1; }

# s3: the same through the environment variable
out=$(cd "$D/other" && SESSION_REPO="$D/session" "$PY" "$H/classify_changes.py")
[ "$(status "$out")" = sibling_confirm ] || { echo "s3: env var ignored: $out"; exit 1; }

# s4: no session repo given: safe, with a warning that the sibling check did not run
out=$(cd "$D/other" && env -u SESSION_REPO "$PY" "$H/classify_changes.py")
[ "$(status "$out")" = safe ] || { echo "s4: expected safe: $out"; exit 1; }
printf '%s' "$out" | grep -q 'sibling-repository check did not run' || { echo "s4: warning missing: $out"; exit 1; }

# s5: a session path that is not a repository is an error, exit 1
if (cd "$D/other" && "$PY" "$H/classify_changes.py" --session-repo "$D" >"$D/o5" 2>&1); then rc=0; else rc=$?; fi
[ "$rc" -eq 1 ] || { echo "s5: exit $rc, want 1"; exit 1; }

# b1: a blocked file wins over everything
echo k > "$D/other/prod.pem"
out=$(cd "$D/other" && "$PY" "$H/classify_changes.py" --session-repo "$D/other")
[ "$(status "$out")" = blocked ] || { echo "b1: expected blocked: $out"; exit 1; }

# c1: a repository with no commits does not crash
git init --quiet "$D/empty"; echo first > "$D/empty/a.txt"
if out=$(cd "$D/empty" && "$PY" "$H/classify_changes.py" --session-repo "$D/empty" 2>"$D/e1"); then rc=0; else rc=$?; fi
[ "$rc" -eq 0 ] || { echo "c1: no-commit repo exit $rc: $(cat "$D/e1")"; exit 1; }
[ "$(status "$out")" = safe ] || { echo "c1: expected safe: $out"; exit 1; }
git -C "$D/empty" add a.txt
out=$(cd "$D/empty" && "$PY" "$H/classify_changes.py" --session-repo "$D/empty")
printf '%s' "$out" | grep -q 'a.txt' || { echo "c1: staged file not in diff stat: $out"; exit 1; }

# m1: a real merge conflict is never safe
mkrepo "$D/conf"; git -C "$D/conf" branch -M main
git -C "$D/conf" checkout --quiet -b side; echo side > "$D/conf/base.txt"; git -C "$D/conf" commit --quiet -am side
git -C "$D/conf" checkout --quiet main; echo main > "$D/conf/base.txt"; git -C "$D/conf" commit --quiet -am main
git -C "$D/conf" merge side >/dev/null 2>&1 || true
out=$(cd "$D/conf" && "$PY" "$H/classify_changes.py" --session-repo "$D/conf")
[ "$(status "$out")" = unmerged ] || { echo "m1: conflict not refused: $out"; exit 1; }
printf '%s' "$out" | grep -q '"base.txt"' || { echo "m1: conflicted file not named cleanly: $out"; exit 1; }
printf '%s' "$out" | grep -q 'unresolved merge conflicts' || { echo "m1: reason missing: $out"; exit 1; }
# after resolving and staging, the tree is safe again
echo resolved > "$D/conf/base.txt"; git -C "$D/conf" add base.txt
out=$(cd "$D/conf" && "$PY" "$H/classify_changes.py" --session-repo "$D/conf")
[ "$(status "$out")" = safe ] || { echo "m1: resolved tree not safe: $out"; exit 1; }

# i1: a force-added ignored file produces the warning (check-ignore must really run)
mkrepo "$D/ign"; echo '*.log' > "$D/ign/.gitignore"; git -C "$D/ign" add .gitignore; git -C "$D/ign" commit --quiet -m ignore
echo x > "$D/ign/debug.log"; git -C "$D/ign" add -f debug.log
out=$(cd "$D/ign" && "$PY" "$H/classify_changes.py" --session-repo "$D/ign")
printf '%s' "$out" | grep -q 'debug.log (matches .gitignore but is staged)' || { echo "i1: ignored-file warning missing: $out"; exit 1; }

# i2: a check-ignore failure (exit other than 0 or 1) is reported, not swallowed
mkdir "$D/shim"; real_git=$(command -v git)
printf '#!/bin/sh\ncase " $* " in *" check-ignore "*) echo "fatal: simulated failure" >&2; exit 128;; esac\nexec %s "$@"\n' "$real_git" > "$D/shim/git"
chmod +x "$D/shim/git"
if out=$(cd "$D/ign" && PATH="$D/shim:$PATH" "$PY" "$H/classify_changes.py" --session-repo "$D/ign"); then rc=0; else rc=$?; fi
[ "$rc" -eq 1 ] || { echo "i2: check-ignore failure exit $rc, want 1: $out"; exit 1; }
[ "$(status "$out")" = error ] || { echo "i2: not reported as error: $out"; exit 1; }
printf '%s' "$out" | grep -q 'check-ignore failed (exit 128)' || { echo "i2: reason missing: $out"; exit 1; }

# u1: an unknown argument is a usage error, exit 2
if (cd "$D/other" && "$PY" "$H/classify_changes.py" --nonsense >/dev/null 2>&1); then rc=0; else rc=$?; fi
[ "$rc" -eq 2 ] || { echo "u1: exit $rc, want 2"; exit 1; }

echo ok
