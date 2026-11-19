#!/bin/sh
# Print roles silent past a threshold. Usage: liveness-check.sh <channel> <threshold-minutes> ROLE[=<working-copy-path>] ...
# Usage errors (fewer than 2 arguments, a threshold that is not a whole number of at most six digits, or a channel that is not a readable plain file) exit 2 with a message on stderr; verdicts otherwise always exit 0.
# A matching line is "- <ROLE> <YYYY-MM-DDTHH:MM> <text>" with a real date and a valid 24-hour time; an impossible stamp (month 13, 24:00, 12:60) is not a matching line at all. Ages are whole minutes between full local timestamps, so a role silent for more than a day is reported as such. A role name is compared literally, including any backslash. A leading UTF-8 BOM on the channel's first line is stripped before matching.
# FROZEN applies only when it is the first word after the stamp on the role's own last matching line (last matching line wins); a stamp with no following word is an ordinary line, not FROZEN. A stamp up to 5 minutes in the future clamps to age 0; a stamp further ahead is reported as silent with a "stamp in the future" note. A trailing CR (CRLF channel) is stripped before matching.
# Silent lines add " for <path>" when a working-copy path was given (one trailing slash on the path is ignored). A process counts when its argv has a field equal to the path (or starting with it plus "/" for a single-word path) or, where lsof is available, when its working directory is the path or inside it; processes are counted once. A count of 0 is a hint, not proof of death, and the silent line says so; a path with embedded spaces counts only an exact, contiguous run of argv fields (no "/" prefix match for multi-word paths). The count excludes the checker's own shell and its direct helper.
set -euf
U="usage: liveness-check.sh <channel> <threshold-minutes> ROLE[=<working-copy-path>] ..."
[ $# -ge 2 ] || { echo "$U" >&2; exit 2; }
CH=$1; T=$2; shift 2
case "$T" in ''|*[!0-9]*|???????*) echo "$U" >&2; exit 2;; esac
[ -f "$CH" ] && [ -r "$CH" ] || { echo "liveness-check: cannot read channel: $CH" >&2; exit 2; }
now=$(date +%Y-%m-%dT%H:%M)
STAMP='^[0-9][0-9][0-9][0-9]-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])T([01][0-9]|2[0-3]):[0-5][0-9]$'
for spec in "$@"; do
  role=${spec%%=*}; wc_path=${spec#*=}; [ "$wc_path" = "$spec" ] && wc_path=""; wc_path=${wc_path%/}
  last=$(ROLE="$role" STAMP="$STAMP" awk 'BEGIN{bom=sprintf("%c%c%c",239,187,191)} NR==1{sub("^"bom,"")} {sub(/\r$/,"")} $1=="-" && $2==ENVIRON["ROLE"] && $3 ~ ENVIRON["STAMP"] {l=$0} END{print l}' "$CH")
  [ -n "$last" ] || { echo "$role: no line ever"; continue; }
  stamp=$(printf '%s' "$last" | awk '{print $3}')
  age=$(awk -v a="$now" -v b="$stamp" 'function m(s,  y,mo,d,h,mi,era,yoe,doy,doe){y=substr(s,1,4)+0;mo=substr(s,6,2)+0;d=substr(s,9,2)+0;h=substr(s,12,2)+0;mi=substr(s,15,2)+0;if(mo<=2)y--;era=int(y/400);yoe=y-era*400;doy=int((153*(mo+(mo>2?-3:9))+2)/5)+d-1;doe=yoe*365+int(yoe/4)-int(yoe/100)+doy;return (era*146097+doe-719468)*1440+h*60+mi} BEGIN{printf "%d", m(a)-m(b)}')
  future=""; if [ "$age" -lt 0 ]; then if [ "$age" -ge -5 ]; then age=0; else future=1; age=$(( -age )); fi; fi
  frozen=$(printf '%s' "$last" | awk '{print $4}')
  [ "$frozen" = FROZEN ] && { echo "$role: FROZEN at $stamp, not counted"; continue; }
  procs=0; note=""
  if [ -n "$wc_path" ]; then
    argv_pids=$(ps -axo pid=,ppid=,args= | WCPATH="$wc_path" awk -v self="$$" '{pid=$1;ppid=$2} pid==self||ppid==self{next} {w=ENVIRON["WCPATH"];k=split(w,wa," ");for(i=3;i+k-1<=NF;i++){ok=1;for(x=1;x<=k;x++)if($(i+x-1)!=wa[x]){ok=0;break};if(ok){print pid;break};if(k==1&&index($i,w"/")==1){print pid;break}}}')
    cwd_pids=""
    if command -v lsof >/dev/null 2>&1; then
      real_wc=$wc_path; [ -d "$wc_path" ] && real_wc=$(cd "$wc_path" && pwd -P)
      cwd_pids=$(lsof -a -d cwd -FpRcn 2>/dev/null | WCPATH="$real_wc" awk -v self="$$" '/^p/{pid=substr($0,2);ppid="";cmd="";next} /^R/{ppid=substr($0,2);next} /^c/{cmd=substr($0,2);next} /^n/{n=substr($0,2);w=ENVIRON["WCPATH"]; if((n==w||index(n,w"/")==1)&&pid!=self&&ppid!=self&&cmd!="lsof"&&cmd!="awk"&&cmd!="ps")print pid}' || true)
    else
      note=" (cwd check unavailable: lsof not found)"
    fi
    procs=$(printf '%s\n%s\n' "$argv_pids" "$cwd_pids" | sed '/^$/d' | sort -u | wc -l | tr -d ' ')
    [ "$procs" -ne 0 ] || note="$note; no process found by argv or working directory, which does not prove the session is dead: confirm by pid before replacing it"
  fi
  if [ -n "$future" ]; then echo "$role: silent, stamp in the future ($stamp), processes=$procs${wc_path:+ for $wc_path}$note"
  elif [ "$age" -gt "$T" ]; then echo "$role: silent ${age}m since $stamp, processes=$procs${wc_path:+ for $wc_path}$note"; else echo "$role: ok (${age}m)"; fi
done
