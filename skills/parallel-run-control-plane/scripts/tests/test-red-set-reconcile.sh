#!/bin/sh
# red-set-reconcile: exact match exits 0; each direction of drift is printed and exits 1; missing input exits 2.
set -eu
H=$(cd "$(dirname "$0")/.." && pwd); D=$(mktemp -d)
trap 'rm -rf "$D"' EXIT

# d1: clean case checks the script's own exit status, not grep's
printf 'cart-badge :41\nmenu-links :27\n' > "$D/exp.txt"
printf '## B\ncart-badge :41 timeout\nmenu-links :27 debt\n' > "$D/cls.md"
if sh "$H/red-set-reconcile.sh" "$D/exp.txt" "$D/cls.md" > "$D/out1" 2>&1; then rc=0; else rc=$?; fi
[ "$rc" -eq 0 ] || { echo "clean case exit $rc"; cat "$D/out1"; exit 1; }
grep -q 'unmatched: 0' "$D/out1" || { echo "clean case failed"; exit 1; }

# d2: .spec.<ext> normalisation still reconciles across the suffix
printf 'search-filter.spec.ts :58\n' > "$D/exp.txt"
printf 'search-filter :58\n' > "$D/cls.md"
if sh "$H/red-set-reconcile.sh" "$D/exp.txt" "$D/cls.md" > "$D/out2" 2>&1; then rc=0; else rc=$?; fi
[ "$rc" -eq 0 ] || { echo "spec-normalise exit $rc"; cat "$D/out2"; exit 1; }
grep -q 'unmatched: 0' "$D/out2" || { echo "spec-normalise unmatched wrong"; exit 1; }

# d3: same key twice in expected collapses against a single classified entry
printf 'cart-badge :41\ncart-badge :41\n' > "$D/exp.txt"
printf 'cart-badge :41\n' > "$D/cls.md"
if sh "$H/red-set-reconcile.sh" "$D/exp.txt" "$D/cls.md" > "$D/out3" 2>&1; then rc=0; else rc=$?; fi
[ "$rc" -eq 0 ] || { echo "dup-key exit $rc"; cat "$D/out3"; exit 1; }
grep -q 'unmatched: 0' "$D/out3" || { echo "dup-key unmatched wrong"; exit 1; }

# d4/t1: a malformed reference is "cannot reconcile": exit exactly 2, before any
# comparison, with the offending entry named on stderr.
printf 'cart-badge :41a\n' > "$D/exp.txt"
printf 'cart-badge :41\n' > "$D/cls.md"
if sh "$H/red-set-reconcile.sh" "$D/exp.txt" "$D/cls.md" > "$D/out4" 2>&1; then rc=0; else rc=$?; fi
[ "$rc" -eq 2 ] || { echo "malformed reference exit was $rc, want 2"; cat "$D/out4"; exit 1; }
grep -q 'malformed' "$D/out4" || { echo "malformed reference not named"; cat "$D/out4"; exit 1; }

# t2: a range reference ("133-134") must not silently truncate to "133" and
# reconcile clean against a real "133" key.
printf 'cart-badge :41-42\n' > "$D/exp.txt"
printf 'cart-badge :41\n' > "$D/cls.md"
if sh "$H/red-set-reconcile.sh" "$D/exp.txt" "$D/cls.md" > "$D/out_range" 2>&1; then rc=0; else rc=$?; fi
[ "$rc" -eq 2 ] || { echo "range reference exit was $rc, want 2"; cat "$D/out_range"; exit 1; }

# t3: an unreadable expected file is "cannot reconcile", exit 2. Skip with a
# printed note if the current user can still read a chmod 000 file (root).
printf 'cart-badge :41\n' > "$D/unreadable.txt"
printf 'cart-badge :41\n' > "$D/cls.md"
chmod 000 "$D/unreadable.txt"
if [ -r "$D/unreadable.txt" ]; then
  echo "note: current user can read a chmod 000 file (likely root); t3 skipped"
else
  if sh "$H/red-set-reconcile.sh" "$D/unreadable.txt" "$D/cls.md" > "$D/out_unreadable" 2>&1; then rc=0; else rc=$?; fi
  [ "$rc" -eq 2 ] || { echo "unreadable file exit was $rc, want 2"; cat "$D/out_unreadable"; exit 1; }
fi
chmod 644 "$D/unreadable.txt"

# t4: the accepted boundary characters (comma, closing paren, backtick) must
# still reconcile clean against the plain key.
printf 'cart-badge :41,\nmenu-links :27)\nsearch-filter :58`\n' > "$D/exp.txt"
printf 'cart-badge :41\nmenu-links :27\nsearch-filter :58\n' > "$D/cls.md"
if sh "$H/red-set-reconcile.sh" "$D/exp.txt" "$D/cls.md" > "$D/out_boundary" 2>&1; then rc=0; else rc=$?; fi
[ "$rc" -eq 0 ] || { echo "boundary-char case exit $rc"; cat "$D/out_boundary"; exit 1; }
grep -q 'unmatched: 0' "$D/out_boundary" || { echo "boundary-char unmatched wrong"; cat "$D/out_boundary"; exit 1; }

# t5: the same malformed entry on both sides must not reconcile clean: exit 2
printf 'cart-badge :41a\n' > "$D/exp.txt"
printf 'cart-badge :41a\n' > "$D/cls.md"
if sh "$H/red-set-reconcile.sh" "$D/exp.txt" "$D/cls.md" > "$D/out_mm" 2>&1; then rc=0; else rc=$?; fi
[ "$rc" -eq 2 ] || { echo "malformed-vs-malformed exit was $rc, want 2"; cat "$D/out_mm"; exit 1; }
# malformed only in the classified list is also exit 2
printf 'cart-badge :41\n' > "$D/exp.txt"
printf 'cart-badge :41-42\n' > "$D/cls.md"
if sh "$H/red-set-reconcile.sh" "$D/exp.txt" "$D/cls.md" > "$D/out_mc" 2>&1; then rc=0; else rc=$?; fi
[ "$rc" -eq 2 ] || { echo "malformed classified entry exit was $rc, want 2"; cat "$D/out_mc"; exit 1; }
# an expected line with no key at all is malformed
printf 'cart-badge 41\n' > "$D/exp.txt"
printf 'cart-badge :41\n' > "$D/cls.md"
if sh "$H/red-set-reconcile.sh" "$D/exp.txt" "$D/cls.md" > "$D/out_nk" 2>&1; then rc=0; else rc=$?; fi
[ "$rc" -eq 2 ] || { echo "keyless expected line exit was $rc, want 2"; cat "$D/out_nk"; exit 1; }
# blank lines and # comments in the expected file are fine
printf '# expected reds\n\ncart-badge :41\n' > "$D/exp.txt"
if sh "$H/red-set-reconcile.sh" "$D/exp.txt" "$D/cls.md" > "$D/out_cm" 2>&1; then rc=0; else rc=$?; fi
[ "$rc" -eq 0 ] || { echo "comment/blank expected file exit was $rc, want 0"; cat "$D/out_cm"; exit 1; }

# d5: a missing expected file is "cannot reconcile", exit 2
printf 'cart-badge :41\n' > "$D/cls.md"
if sh "$H/red-set-reconcile.sh" "$D/nope.txt" "$D/cls.md" > "$D/out5" 2>&1; then rc=0; else rc=$?; fi
[ "$rc" -eq 2 ] || { echo "missing file exit was $rc, want 2"; cat "$D/out5"; exit 1; }

# d6: no arguments exits non-zero
if sh "$H/red-set-reconcile.sh" > "$D/out6" 2>&1; then rc=0; else rc=$?; fi
[ "$rc" -ne 0 ] || { echo "no-args case exited 0"; exit 1; }

# d7: drift case, section-scoped so swapping the two comm calls fails this test
printf 'cart-badge :41\nmenu-links :27\norder-export :63\n' > "$D/exp.txt"
printf '## B\ncart-badge :41\nprofile-theme :19\n' > "$D/cls.md"
if out=$(sh "$H/red-set-reconcile.sh" "$D/exp.txt" "$D/cls.md"); then rc=0; else rc=$?; fi
[ "$rc" -ne 0 ] || { echo "drift exited 0"; exit 1; }
lane_section=$(echo "$out" | sed -n '/stated by lane/,/in classified list/p')
list_section=$(echo "$out" | sed -n '/in classified list/,$p')
echo "$lane_section" | grep -q 'order-export :63' || { echo "lane-only red missing from its section"; exit 1; }
echo "$list_section" | grep -q 'profile-theme :19' || { echo "list-only red missing from its section"; exit 1; }
echo "$out" | grep -q 'unmatched: 3' || { echo "count wrong: $out"; exit 1; }

echo ok
