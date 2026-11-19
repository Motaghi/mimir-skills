#!/bin/sh
# close-record-lint: clean folder exits 0; draft markers and banned words exit 1 with the hit printed; bad input exits 2.
set -eu
H=$(cd "$(dirname "$0")/.." && pwd); D=$(mktemp -d); trap 'chmod -R u+rwx "$D" 2>/dev/null; rm -rf "$D"' EXIT; mkdir "$D/docs"
printf '# Tracker\nStatus: CLOSED\nclose sha: this commit\n' > "$D/docs/TRACKER.md"
sh "$H/close-record-lint.sh" "$D/docs" "$H/banned-words.txt" >/dev/null || { echo "clean folder failed"; exit 1; }
printf '# Devlog\nSuite numbers: TBD\n' > "$D/docs/DEVLOG.md"
out=$(sh "$H/close-record-lint.sh" "$D/docs" "$H/banned-words.txt") && { echo "TBD passed"; exit 1; }
echo "$out" | grep -q 'DEVLOG.md' || { echo "hit not printed"; exit 1; }
sh "$H/close-record-lint.sh" "$D/docs" >/dev/null 2>&1 && { echo "no-list TBD passed"; exit 1; }
: > "$D/empty.txt"
out=$(sh "$H/close-record-lint.sh" "$D/docs" "$D/empty.txt") && { echo "empty-list TBD passed"; exit 1; }
echo "$out" | grep -q 'DEVLOG.md' || { echo "empty-list hit not printed"; exit 1; }
if sh "$H/close-record-lint.sh" "$D/nosuchdir" >/dev/null 2>&1; then rc=0; else rc=$?; fi
[ "$rc" -eq 2 ] || { echo "missing dir wrong exit: $rc"; exit 1; }
printf '# Notes\nA robust close.\n' > "$D/docs/DEVLOG.md"
sh "$H/close-record-lint.sh" "$D/docs" "$H/banned-words.txt" >/dev/null 2>&1 && { echo "banned word passed"; exit 1; }
printf 'robust\r\n' > "$D/crlf.txt"
sh "$H/close-record-lint.sh" "$D/docs" "$D/crlf.txt" >/dev/null 2>&1 && { echo "crlf banned word passed"; exit 1; }
rm -f "$D/docs/DEVLOG.md"; mkdir "$D/real"
printf '# Real\nStatus TBD\n' > "$D/real/REAL.md"
ln -s "$D/real/REAL.md" "$D/docs/LINK.md"
sh "$H/close-record-lint.sh" "$D/docs" >/dev/null 2>&1 || { echo "symlink to a draft file outside the folder was scanned"; exit 1; }
mkdir "$D/single"
printf '# Solo\nStatus: TBD\n' > "$D/single/SOLO.md"
out=$(sh "$H/close-record-lint.sh" "$D/single") && { echo "single TBD passed"; exit 1; }
echo "$out" | grep -q 'SOLO.md' || { echo "single-file hit missing filename"; exit 1; }
mkdir "$D/unreadable"
printf '# Secret\nStatus: TBD\n' > "$D/unreadable/SECRET.md"
chmod 000 "$D/unreadable/SECRET.md"
if [ -r "$D/unreadable/SECRET.md" ]; then
  echo "skipping unreadable-file case: running as a user that can read chmod 000 files"
else
  if sh "$H/close-record-lint.sh" "$D/unreadable" >/dev/null 2>&1; then rc=0; else rc=$?; fi
  [ "$rc" -eq 2 ] || { echo "unreadable file wrong exit: $rc"; exit 1; }
fi
chmod 644 "$D/unreadable/SECRET.md"
mkdir "$D/badsubdir"; mkdir "$D/badsubdir/hidden"
printf '# Hidden\nStatus: TBD\n' > "$D/badsubdir/hidden/NOTE.md"
chmod 000 "$D/badsubdir/hidden"
if [ -r "$D/badsubdir/hidden" ]; then
  echo "skipping unreadable-subdir case: running as a user that can read chmod 000 dirs"
else
  if out=$(sh "$H/close-record-lint.sh" "$D/badsubdir" 2>&1); then rc=0; else rc=$?; fi
  [ "$rc" -eq 2 ] || { echo "unreadable subdir wrong exit: $rc"; exit 1; }
  echo "$out" | grep -q 'scan error' || { echo "unreadable subdir missing scan error message"; exit 1; }
fi
chmod 755 "$D/badsubdir/hidden"
mkdir "$D/empty_docs"
printf 'foo(bar\n' > "$D/badregex.txt"
out=$(sh "$H/close-record-lint.sh" "$D/empty_docs" "$D/badregex.txt" 2>&1) && { echo "bad regex passed"; exit 1; }
rc=$?
[ "$rc" -eq 2 ] || { echo "bad regex wrong exit: $rc"; exit 1; }
echo "$out" | grep -q 'invalid pattern' || { echo "bad regex missing invalid pattern message"; exit 1; }
if sh "$H/close-record-lint.sh" "$D/single" "$D/badregex.txt" >/dev/null 2>&1; then rc=0; else rc=$?; fi
[ "$rc" -eq 2 ] || { echo "bad regex (t3b confounded fixture) wrong exit: $rc"; exit 1; }
printf 'robust   \n' > "$D/trailing.txt"
mkdir "$D/trailing_docs"
printf '# Note\nThis is Robust.\n' > "$D/trailing_docs/NOTE.md"
sh "$H/close-record-lint.sh" "$D/trailing_docs" "$D/trailing.txt" >/dev/null 2>&1 && { echo "trailing-space banned word passed"; exit 1; }
printf '   robust\n' > "$D/leading.txt"
mkdir "$D/leading_docs"
printf '# Note\nA robust close.\n' > "$D/leading_docs/NOTE.md"
sh "$H/close-record-lint.sh" "$D/leading_docs" "$D/leading.txt" >/dev/null 2>&1 && { echo "leading-space banned word passed"; exit 1; }
mkdir -- "$D/-abc"
printf '# Note\nStatus: TBD\n' > "$D/-abc/NOTE.md"
(cd "$D" && sh "$H/close-record-lint.sh" "-abc" >/dev/null 2>&1) && { echo "dash dir TBD passed"; exit 1; }
if sh "$H/close-record-lint.sh" "$D/single" "$D/nosuchbannedlist.txt" >/dev/null 2>&1; then rc=0; else rc=$?; fi
[ "$rc" -eq 2 ] || { echo "missing banned list wrong exit: $rc"; exit 1; }
if sh "$H/close-record-lint.sh" >/dev/null 2>&1; then rc=0; else rc=$?; fi
[ "$rc" -eq 2 ] || { echo "no args wrong exit: $rc"; exit 1; }
mkdir "$D/todo_docs"
printf '# Note\ntodo\n' > "$D/todo_docs/NOTE.md"
sh "$H/close-record-lint.sh" "$D/todo_docs" >/dev/null 2>&1 && { echo "lowercase todo passed"; exit 1; }
mkdir "$D/todo2_docs"
printf '# Note\nto do\n' > "$D/todo2_docs/NOTE.md"
sh "$H/close-record-lint.sh" "$D/todo2_docs" >/dev/null 2>&1 && { echo "to do passed"; exit 1; }
# template fields, angle-bracket placeholders and a draft status line fail the lint
mkdir "$D/ph1"; printf '# Tracker\nVersion: {{version}}\n' > "$D/ph1/T.md"
sh "$H/close-record-lint.sh" "$D/ph1" >/dev/null 2>&1 && { echo "mustache placeholder passed"; exit 1; }
mkdir "$D/ph2"; printf '# Tracker\nClose sha: <close-sha>\n' > "$D/ph2/T.md"
out=$(sh "$H/close-record-lint.sh" "$D/ph2") && { echo "angle placeholder passed"; exit 1; }
echo "$out" | grep -q 'T.md:2:<close-sha>' || { echo "angle placeholder hit not printed: $out"; exit 1; }
mkdir "$D/ph3"; printf '# Tracker\nversion <two words> here\n' > "$D/ph3/T.md"
sh "$H/close-record-lint.sh" "$D/ph3" >/dev/null 2>&1 && { echo "two-word placeholder passed"; exit 1; }
mkdir "$D/ph4"; printf '# Tracker\nStatus: DRAFT\n' > "$D/ph4/T.md"
sh "$H/close-record-lint.sh" "$D/ph4" >/dev/null 2>&1 && { echo "Status: DRAFT passed"; exit 1; }
mkdir "$D/ph5"; printf '# Tracker\nstatus:draft\n' > "$D/ph5/T.md"
sh "$H/close-record-lint.sh" "$D/ph5" >/dev/null 2>&1 && { echo "status:draft passed"; exit 1; }
# plain-text release documents are scanned too
mkdir "$D/txt1"; printf 'Release notes\nStatus: DRAFT\nTODO fix hashes\nVersion <version>\n' > "$D/txt1/release.txt"
out=$(sh "$H/close-record-lint.sh" "$D/txt1") && { echo "release.txt draft passed"; exit 1; }
echo "$out" | grep -q 'release.txt:2:' || { echo "release.txt Status: DRAFT not reported: $out"; exit 1; }
echo "$out" | grep -q 'release.txt:3:' || { echo "release.txt TODO not reported: $out"; exit 1; }
echo "$out" | grep -q 'release.txt:4:<version>' || { echo "release.txt placeholder not reported: $out"; exit 1; }
mkdir "$D/txt2"; printf 'Release notes\nStatus: CLOSED\n' > "$D/txt2/release.txt"
sh "$H/close-record-lint.sh" "$D/txt2" >/dev/null 2>&1 || { echo "clean release.txt failed"; exit 1; }
# real HTML documents and markdown with closed tags are markup, not placeholders
mkdir "$D/html1"
printf '<!DOCTYPE html>\n<html>\n<head>\n<title>Notes</title>\n</head>\n<body>\n<h1>Release</h1>\n<section>\n<p>Done.</p>\n</section>\n</body>\n</html>\n' > "$D/html1/index.html"
sh "$H/close-record-lint.sh" "$D/html1" >/dev/null 2>&1 || { echo "valid html flagged"; exit 1; }
mkdir "$D/html2"; printf '<html>\n<body>\n<h1>Release</h1>\n</body>\n</html>\n' > "$D/html2/notes.md"
sh "$H/close-record-lint.sh" "$D/html2" >/dev/null 2>&1 || { echo "closed html tags in markdown flagged"; exit 1; }
mkdir "$D/html3"; printf '<html><body>TODO list</body></html>\n' > "$D/html3/index.html"
sh "$H/close-record-lint.sh" "$D/html3" >/dev/null 2>&1 && { echo "TODO in html passed"; exit 1; }
mkdir "$D/html4"; printf '# Notes\n<title>\n' > "$D/html4/notes.md"
sh "$H/close-record-lint.sh" "$D/html4" >/dev/null 2>&1 && { echo "unclosed <title> placeholder passed"; exit 1; }
# HTML: an unfilled <name> or escaped &lt;name&gt; in the text is a placeholder; known elements are not
mkdir "$D/h5"; printf '<html><body>\n<p>Close sha: <close-sha></p>\n</body></html>\n' > "$D/h5/index.html"
out=$(sh "$H/close-record-lint.sh" "$D/h5") && { echo "html <close-sha> placeholder passed"; exit 1; }
echo "$out" | grep -q 'index.html:2:<close-sha>' || { echo "html placeholder hit not printed: $out"; exit 1; }
mkdir "$D/h6"; printf '<html><body><p>Version &lt;version&gt; released</p></body></html>\n' > "$D/h6/index.html"
sh "$H/close-record-lint.sh" "$D/h6" >/dev/null 2>&1 && { echo "html escaped placeholder passed"; exit 1; }
mkdir "$D/h7"; printf '<html><body><p>Close sha: {{sha}}</p></body></html>\n' > "$D/h7/index.html"
sh "$H/close-record-lint.sh" "$D/h7" >/dev/null 2>&1 && { echo "html {{...}} passed"; exit 1; }
# paired markup outside the allowlist is markup when the same file closes it
mkdir "$D/h10"; printf '<html><body>\n<svg width="10"><g>x</g></svg>\n<figure-x>y</figure-x>\n</body></html>\n' > "$D/h10/index.html"
printf '# Notes\n<svg>icon</svg> and <widget>w</widget>\n' > "$D/h10/notes.md"
sh "$H/close-record-lint.sh" "$D/h10" >/dev/null 2>&1 || { echo "paired unknown markup flagged"; exit 1; }
mkdir "$D/h10b"; printf '<html><body><svg>icon</svg><p>Close sha: <close-sha></p></body></html>\n' > "$D/h10b/index.html"
sh "$H/close-record-lint.sh" "$D/h10b" >/dev/null 2>&1 && { echo "placeholder beside svg passed"; exit 1; }
# escaped code examples inside <code> and <pre> are not placeholders, including multi-line <pre>
mkdir "$D/h11"; printf '<html><body>\n<p>Use <code>&lt;p&gt;</code> for text.</p>\n<pre>\nline one &lt;div&gt;\n  &lt;span&gt;\n</pre>\n<pre class="x"><code>&lt;ul&gt;</code></pre>\n</body></html>\n' > "$D/h11/index.html"
sh "$H/close-record-lint.sh" "$D/h11" >/dev/null 2>&1 || { echo "escaped code example flagged"; exit 1; }
# an escaped placeholder outside code is still caught, even after a code block
mkdir "$D/h12"; printf '<html><body>\n<pre>&lt;p&gt;</pre>\n<p>Version &lt;version&gt; released</p>\n</body></html>\n' > "$D/h12/index.html"
out=$(sh "$H/close-record-lint.sh" "$D/h12") && { echo "escaped placeholder after code passed"; exit 1; }
echo "$out" | grep -q 'index.html:3:&lt;version&gt;' || { echo "escaped placeholder hit missing: $out"; exit 1; }
# lists and paragraphs without end tags are valid markup in text documents and in HTML
mkdir "$D/h8"; printf '# Notes\n<ul>\n<li>one\n<li>two\n</ul>\n<p>text\n<p>more\n' > "$D/h8/notes.md"
sh "$H/close-record-lint.sh" "$D/h8" >/dev/null 2>&1 || { echo "list without end tags flagged in markdown"; exit 1; }
mkdir "$D/h9"; printf '<html><body><ul><li>one<li>two</ul><table><tr><td>a<td>b</table></body></html>\n' > "$D/h9/index.html"
sh "$H/close-record-lint.sh" "$D/h9" >/dev/null 2>&1 || { echo "list without end tags flagged in html"; exit 1; }
# a symbolic link is skipped: its target is neither scanned nor printed
mkdir "$D/link1" "$D/outside"; printf 'TODO secret outside text\n' > "$D/outside/leak.md"
ln -s "$D/outside/leak.md" "$D/link1/linked.md"; printf '# Clean\n' > "$D/link1/real.md"
if out=$(sh "$H/close-record-lint.sh" "$D/link1" 2>"$D/link.err"); then rc=0; else rc=$?; fi
[ "$rc" -eq 0 ] || { echo "symlink target was scanned (exit $rc): $out"; exit 1; }
printf '%s' "$out" | grep -q 'secret outside text' && { echo "symlink target content printed"; exit 1; }
grep -q 'skipped symbolic link' "$D/link.err" || { echo "symlink skip not noted on stderr"; exit 1; }
# ordinary HTML tags, code fences with comparisons and closed status lines stay clean
mkdir "$D/ok1"; printf '# Tracker\nLine one<br>line two. Use <code>make</code> and <details>x</details>.\nStatus: CLOSED\na < b and c > d\n' > "$D/ok1/T.md"
sh "$H/close-record-lint.sh" "$D/ok1" >/dev/null 2>&1 || { echo "plain html or comparison failed the lint"; exit 1; }
echo ok
