#!/usr/bin/env bash
# session-times.sh — A Claude Code session's start, end and duration, read from its transcript.
#
# Times in the brain are measured, never estimated (CLAUDE.md, Organisation-Wide
# Conventions). This prints:
#
#   Start     the first timestamp in the session's transcript
#   End       the clock now, for the session running this shell; for any other
#             session, its transcript's last record
#   Duration  End minus Start, wall clock
#   Turns     the time inside Claude's turns, as the union of their intervals.
#             A turn runs from its first record (the prompt, or the agent's or
#             peer's message that started it, marked turnOrigin) to the
#             turn_duration record that closes it, or, where none does before
#             the next turn starts, to its last record before that start: a
#             headless session (claude -p) writes no closing records. The last
#             turn with no closing record, such as the one running this script,
#             counts up to End, and the line says so. It includes a turn's waits
#             on agents or on the user's answer, so it isn't pure working time.
#             turn_duration's own durationMs counts only where no turnOrigin
#             record comes before it (a transcript older than that field): it
#             can count from an earlier turn's start. One turn of four minutes
#             recorded 547, back to a prompt nine hours before it.
#   Handoff   the same as one line for a handoff's **Time:** field
#
# Usage:
#   scripts/session-times.sh                # the session running this shell
#   scripts/session-times.sh <session-id>   # any session on this machine
#
# It reads Claude Code's local transcript, <config dir>/projects/<project>/<id>.jsonl.
# That format isn't a public interface: if a Claude Code update changes it and this
# prints nothing, a handoff writes `not recorded`.
#
# Exit status: 0 printed, 1 no session id, no transcript for it, or no GNU date.
# Needs only bash, find, grep, cut, paste, sort, wc, awk, and GNU date (for -d and
# -f): on macOS, `gdate` from coreutils (brew install coreutils).

set -u

DATE='date'
if ! date -d @0 +%s >/dev/null 2>&1; then
  if command -v gdate >/dev/null 2>&1; then
    DATE=gdate
  else
    echo "Needs GNU date: on macOS, brew install coreutils for gdate." >&2
    exit 1
  fi
fi

id="${1:-${CLAUDE_CODE_SESSION_ID:-}}"
if [ -z "$id" ]; then
  echo "No session id: pass one, or run this inside Claude Code (CLAUDE_CODE_SESSION_ID)." >&2
  exit 1
fi

projects="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/projects"
transcript=$(find "$projects" -maxdepth 2 -name "$id.jsonl" 2>/dev/null | head -n 1)
if [ -z "$transcript" ]; then
  echo "No transcript for session $id under $projects." >&2
  exit 1
fi

first=$(grep -o -m 1 '"timestamp":"[^"]*"' "$transcript" | head -n 1 | cut -d'"' -f4)
if [ -z "$first" ]; then
  echo "No timestamp in $transcript." >&2
  exit 1
fi

start_s=$("$DATE" -d "$first" +%s)
if [ "$id" = "${CLAUDE_CODE_SESSION_ID:-}" ]; then
  end_s=$("$DATE" +%s)
else  # a past session, or one running elsewhere: the clock now would be the wrong end
  # Its last record, leaving out the file-history snapshots Claude Code writes after the
  # conversation's last message, sometimes minutes later.
  last=$(grep -v '^{"type":"file-history-snapshot"' "$transcript" | grep -o '"timestamp":"[^"]*"' \
    | cut -d'"' -f4 | sort | tail -n 1)
  end_s=$("$DATE" -d "$last" +%s)
fi

# Every record with a timestamp, in the transcript's order, as its kind, a value and
# its time: O starts a turn (turnOrigin, with its turnIndex), C closes one
# (turn_duration, with durationMs), R is any other. Left out are the file-history
# snapshots, as for End, and the queue-operations a prompt writes as it is queued:
# for a headless prompt that is just before its own turn starts.
# A turn's later records (a message queued into it) carry the same turnIndex, so it
# starts at the first. A closing record closes the open turn; one with no open turn
# falls back to [its timestamp - durationMs, its timestamp]. A turn still open when
# another starts ends at the last record before that start: a headless session
# (claude -p) writes no closing records, and an interrupted turn may have none.
# Turns can still overlap, so the time inside them is the union of the intervals.
records=$(grep -v -e '^{"type":"file-history-snapshot"' -e '^{"type":"queue-operation"' "$transcript" \
  | awk 'match($0, /"timestamp":"[^"]*"/) {
           t = substr($0, RSTART + 13, RLENGTH - 14); k = "R"; v = "-"
           if (index($0, "\"subtype\":\"turn_duration\"")) {
             k = "C"; v = match($0, /"durationMs":[0-9]+/) ? substr($0, RSTART + 13, RLENGTH - 13) : 0
           } else if (index($0, "\"turnOrigin\"")) {
             k = "O"; if (match($0, /"turnIndex":[0-9]+/)) v = substr($0, RSTART + 12, RLENGTH - 12)
           }
           print k "\t" v "\t" t
         }')
turns=0
turn_s=0
running=0
if [ -n "$records" ]; then
  intervals=$(paste <(cut -f1,2 <<<"$records") <(cut -f3 <<<"$records" | "$DATE" -f - +%s.%3N) \
    | awk -v end="$end_s" '
        $1 == "O" { if (open && ($2 == "-" || $2 != cur)) { printf "%.3f %.3f\n", start, last; open = 0 }
                    if ($2 == "-") start = $3; else { if (!($2 in first)) first[$2] = $3; start = first[$2] }
                    cur = $2; open = 1 }
        $1 == "C" { if (open) printf "%.3f %.3f\n", start, $3; else printf "%.3f %.3f\n", $3 - $2 / 1000, $3
                    open = 0 }
                  { if ($3 > last) last = $3 }
        END       { if (open) printf "%.3f %.3f running\n", start, end }')
  case "$intervals" in *running) running=1 ;; esac
  turns=$(awk 'NF && $3 != "running" { n++ } END { print n + 0 }' <<<"$intervals")
  turn_s=$(printf '%s\n' "$intervals" | sort -n \
    | awk 'NF == 0 { next }
           !seen++ { s = $1; e = $2; next }
           $1 > e { t += e - s; s = $1; e = $2; next }
           $2 > e { e = $2 }
           END { if (seen) t += e - s; printf "%d\n", t }')
fi

span() {  # seconds -> "2 h 05 min" or "45 min"
  local m=$(( $1 / 60 ))
  if [ "$m" -ge 60 ]; then printf '%d h %02d min' $(( m / 60 )) $(( m % 60 )); else printf '%d min' "$m"; fi
}

start=$("$DATE" -d "@$start_s" '+%F %T %Z')
end=$("$DATE" -d "@$end_s" '+%F %T %Z')
duration=$(span $(( end_s - start_s )))
in_turns=$(span "$turn_s")

echo "Start:    $start"
echo "End:      $end"
echo "Duration: $duration"
if [ "$running" = 1 ]; then
  if [ "$id" = "${CLAUDE_CODE_SESSION_ID:-}" ]; then upto="the clock"; else upto="its last record"; fi
  echo "Turns:    $in_turns inside $turns completed turns and the running one, counted up to $upto"
  echo "Handoff:  **Time:** $start → $end: $duration, $in_turns of it inside Claude's $turns turns and the running one (\`scripts/session-times.sh\`)"
else
  echo "Turns:    $in_turns inside $turns completed turns"
  echo "Handoff:  **Time:** $start → $end: $duration, $in_turns of it inside Claude's $turns turns (\`scripts/session-times.sh\`)"
fi
