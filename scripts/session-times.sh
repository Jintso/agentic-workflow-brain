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
#             turn_duration record that closes it. A turn with no closing record
#             yet, such as the one running this script, counts up to End, and
#             the line says so. It includes a turn's waits on agents or on the
#             user's answer, so it isn't pure working time.
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

DATE=date
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

# The records that start a turn (turnOrigin, with its turnIndex) and close one
# (turn_duration, with durationMs), in the transcript's order. A turn's later records
# (a message queued into it) carry the same turnIndex, so it starts at the first.
# Each closing record closes the turn started last; one with no such turn falls back to
# [its timestamp - durationMs, its timestamp]. Turns can still overlap, so the time
# inside them is the union of the intervals.
records=$(grep -e '"subtype":"turn_duration"' -e '"turnOrigin"' "$transcript")
turns=0
turn_s=0
running=0
if [ -n "$records" ]; then
  turns=$(printf '%s\n' "$records" | grep -c '"subtype":"turn_duration"')
  intervals=$(paste \
      <(printf '%s\n' "$records" | awk '{ print (index($0, "\"subtype\":\"turn_duration\"") ? "C" : "O") }') \
      <(printf '%s\n' "$records" \
        | awk 'match($0, /"timestamp":"[^"]*"/) { print substr($0, RSTART + 13, RLENGTH - 14) }' \
        | "$DATE" -f - +%s.%3N) \
      <(printf '%s\n' "$records" \
        | awk '{ if (match($0, /"durationMs":[0-9]+/)) print substr($0, RSTART + 13, RLENGTH - 13)
                 else if (match($0, /"turnIndex":[0-9]+/)) print substr($0, RSTART + 12, RLENGTH - 12)
                 else print "-" }') \
    | awk -v end="$end_s" '
        $1 == "O" { if ($3 == "-") start = $2; else { if (!($3 in first)) first[$3] = $2; start = first[$3] }
                    open = 1; next }
        open      { printf "%.3f %.3f\n", start, $2; open = 0; next }
                  { printf "%.3f %.3f\n", $2 - $3 / 1000, $2 }
        END       { if (open) printf "%.3f %.3f running\n", start, end }')
  case "$intervals" in *running) running=1 ;; esac
  turn_s=$(printf '%s\n' "$intervals" | sort -n \
    | awk 'NR == 1 { s = $1; e = $2; next }
           $1 > e { t += e - s; s = $1; e = $2; next }
           $2 > e { e = $2 }
           END { if (NR) t += e - s; printf "%d\n", t }')
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
