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
#   Turns     the time inside Claude's completed turns: the union of the
#             transcript's turn_duration intervals (the turn running this
#             script isn't one yet). It includes a turn's waits on agents
#             or on the user's answer, so it isn't pure working time.
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

# Each turn_duration record closes a turn: [its timestamp - durationMs, its timestamp].
# Turns can overlap or nest (a message queued behind a running turn, a turn that waits
# on background agents), so the time inside turns is the union of those intervals.
records=$(grep '"subtype":"turn_duration"' "$transcript")
turns=0
turn_s=0
if [ -n "$records" ]; then
  turns=$(printf '%s\n' "$records" | wc -l)
  turn_s=$(paste \
      <(printf '%s\n' "$records" | grep -o '"timestamp":"[^"]*"' | cut -d'"' -f4 | "$DATE" -f - +%s) \
      <(printf '%s\n' "$records" | grep -o '"durationMs":[0-9]*' | cut -d: -f2) \
    | awk '{ printf "%.3f %.3f\n", $1 - $2 / 1000, $1 }' | sort -n \
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
echo "Turns:    $in_turns inside $turns completed turns"
echo "Handoff:  **Time:** $start → $end: $duration, $in_turns of it inside Claude's $turns turns (\`scripts/session-times.sh\`)"
