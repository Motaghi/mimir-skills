#!/bin/sh
# Exit 1 if a closed docs folder still holds draft markers, unfilled placeholders or banned words. Usage: close-record-lint.sh <docs-dir> [banned-list-file]. Exit 2 means the input could not be scanned (e.g. missing docs dir, unreadable file, bad pattern, or bad arguments).
# Scans regular text documents: .md, .markdown, .txt, .rst, .adoc, .html, .htm. Symbolic links are skipped (a note goes to stderr), so a link cannot pull in or print a file from outside the folder.
# Draft markers: TBD, TODO, TO DO, IN PROGRESS, PENDING, "Status: DRAFT", and {{...}} template fields.
# Placeholders: <word> or <two words> in angle brackets. In text documents a bracketed name is markup, not a placeholder, when the same file closes it with </name>, when it is a void element such as <br>, or when it is an element whose end tag is optional (<li>, <p>, <td> and so on, so lists without end tags pass). In .html and .htm files a bracketed name is markup when it is a known HTML element; any other bare <name>, and the escaped form &lt;name&gt;, is reported as a placeholder.
set -eu
[ $# -ge 1 ] || { echo "usage: close-record-lint.sh <docs-dir> [banned-list-file]" >&2; exit 2; }
DIR=$1; BANNED=${2:-}; PAT='TBD|TODO|TO DO|IN PROGRESS|PENDING|status:[[:space:]]*draft|\{\{[^}]*\}\}'
case "$DIR" in -*) DIR="./$DIR" ;; esac
[ -d "$DIR" ] || { echo "close-record-lint: no such directory: $DIR" >&2; exit 2; }
if [ -n "$BANNED" ]; then
  [ -f "$BANNED" ] || { echo "close-record-lint: no such banned list: $BANNED" >&2; exit 2; }
  extra=$(tr -d '\r' < "$BANNED" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//' | grep -v '^#' | grep -v '^$' | paste -sd'|' -)
  [ -n "$extra" ] && PAT="$PAT|$extra"
fi
echo | grep -qE "$PAT" 2>/dev/null || [ $? -eq 1 ] || { echo "close-record-lint: invalid pattern in $BANNED" >&2; exit 2; }
ERR=$(mktemp "${TMPDIR:-/tmp}/crl-err.XXXXXX"); trap 'rm -f "$ERR"' EXIT
NAMES="\\( -name '*.md' -o -name '*.markdown' -o -name '*.txt' -o -name '*.rst' -o -name '*.adoc' -o -name '*.html' -o -name '*.htm' \\)"
skipped=$(eval "find \"\$DIR\" -type l $NAMES -print" 2>>"$ERR" || true)
[ -z "$skipped" ] || printf 'close-record-lint: skipped symbolic link: %s\n' $skipped >&2
hits=$(eval "find \"\$DIR\" -type f $NAMES -print0" 2>>"$ERR" | xargs -0 grep -HniE "$PAT" 2>>"$ERR" || true)
AWKPROG='
  BEGIN { n=split("br hr img input meta link area base col embed source track wbr param li p dt dd tr td th tbody thead tfoot option optgroup colgroup rt rp html head body", v, " "); for (i=1;i<=n;i++) void[v[i]]=1
    n=split("a abbr address area article aside audio b base bdi bdo blockquote body br button canvas caption cite code col colgroup data datalist dd del details dfn dialog div dl dt em embed fieldset figcaption figure footer form h1 h2 h3 h4 h5 h6 head header hgroup hr html i iframe img input ins kbd label legend li link main map mark menu meta meter nav noscript object ol optgroup option output p param picture pre progress q rp rt ruby s samp script search section select slot small source span strong style sub summary sup table tbody td template textarea tfoot th thead time title tr track u ul var video wbr", k, " "); for (i=1;i<=n;i++) known[k[i]]=1 }
  { lines[FNR]=$0; s=$0
    while (match(s, /<\/[A-Za-z][A-Za-z0-9_-]*>/)) { closed[tolower(substr(s,RSTART+2,RLENGTH-3))]=1; s=substr(s,RSTART+RLENGTH) } }
  END { for (i=1;i<=FNR;i++) { s=lines[i]
    while (match(s, /<[A-Za-z][A-Za-z0-9_ -]*>/)) { tok=substr(s,RSTART,RLENGTH); n=tolower(substr(tok,2,RLENGTH-2)); s=substr(s,RSTART+RLENGTH)
      if (n in closed || n in void || (html && n in known)) continue
      printf "%s:%d:%s\n", FILENAME, i, tok }
    if (html) { r=lines[i]; vis=""
      while (r != "") {
        if (depth > 0) { if (match(r, /<\/(code|pre)>/)) { r=substr(r,RSTART+RLENGTH); depth-- } else r="" }
        else if (match(r, /<(code|pre)(>| [^>]*>)/)) { vis=vis substr(r,1,RSTART-1); r=substr(r,RSTART+RLENGTH); depth++ }
        else { vis=vis r; r="" } }
      s=vis; while (match(s, /&lt;[A-Za-z][A-Za-z0-9_ -]*&gt;/)) { printf "%s:%d:%s\n", FILENAME, i, substr(s,RSTART,RLENGTH); s=substr(s,RSTART+RLENGTH) } } } }'
angle_text=$(eval "find \"\$DIR\" -type f \\( -name '*.md' -o -name '*.markdown' -o -name '*.txt' -o -name '*.rst' -o -name '*.adoc' \\) -print0" 2>>"$ERR" | xargs -0 -n1 awk -v html=0 "$AWKPROG" 2>>"$ERR" || true)
angle_html=$(eval "find \"\$DIR\" -type f \\( -name '*.html' -o -name '*.htm' \\) -print0" 2>>"$ERR" | xargs -0 -n1 awk -v html=1 "$AWKPROG" 2>>"$ERR" || true)
angle=$(printf '%s\n%s' "$angle_text" "$angle_html" | sed '/^$/d')
[ -s "$ERR" ] && { cat "$ERR" >&2; echo "close-record-lint: scan error"; exit 2; }
[ -n "$angle" ] && hits=$(printf '%s\n%s' "$hits" "$angle" | sed '/^$/d')
[ -z "$hits" ] && { echo "close-record-lint: clean"; exit 0; }
printf '%s\n' "$hits"; echo "close-record-lint: FAIL"; exit 1
