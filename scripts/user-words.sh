#!/usr/bin/env bash
# user-words.sh — What the user said in a Claude Code session, word for word, read from its transcript.
#
# A handoff quotes the user's decisions in their own words (CLAUDE.md, Compact
# Instructions), and a compaction summary paraphrases them. The transcript holds
# every word the user sent, so this prints them, oldest first, each under a line
# with its local time and kind:
#
#   prompt    a message the user sent while Claude was idle
#   queued    a message the user sent while Claude was working, delivered mid-turn
#   command   a slash command the user ran, with its arguments
#   answer    the user's answers to Claude's questions (AskUserQuestion), each
#             question with its answer, and any note the user added
#
# Left out: everything Claude Code itself writes into the conversation (a skill's
# text, system reminders, task notifications, other agents' messages), tool
# results, and Claude's own replies. What was done lives in git and the forge, not
# here: this is only what was said.
#
# Usage:
#   scripts/user-words.sh                # the session running this shell
#   scripts/user-words.sh <session-id>   # any session on this machine
#
# It reads Claude Code's local transcript, <config dir>/projects/<project>/<id>.jsonl.
# That format isn't a public interface: if a Claude Code update changes it and this
# prints nothing, quote from the conversation instead, and say so.
#
# Exit status: 0 printed (perhaps nothing, if the user said nothing yet), 1 no
# session id, no transcript for it, or no jq. Needs bash, find, and jq 1.6 or later.

set -u

if ! command -v jq >/dev/null 2>&1; then
  echo "Needs jq 1.6 or later: https://jqlang.org/download/" >&2
  exit 1
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

# A record the user wrote: a prompt (origin human), a message queued into a running
# turn (a queued_command attachment whose origin is human), or the answers to a
# question (a tool result carrying toolUseResult.answers). A slash command's prompt
# holds its name and arguments in tags; the skill text it expands to is a separate
# record, marked isMeta, with no human origin. Lines that aren't JSON are skipped.
jq -R -r '
  def human: (if type == "string" then (fromjson? // {}) else . end) | (.kind? // "") == "human";
  def text: if type == "string" then . else [.[]? | select(.type? == "text") | .text] | join("\n") end;
  def when: (.timestamp // "") | sub("\\.[0-9]+Z$"; "Z") | (fromdateiso8601? // null)
            | if . == null then "(no time)" else strflocaltime("%F %T %Z") end;
  def command:
    if test("<command-name>") then
      [ (capture("<command-name>(?<n>[^<]*)</command-name>").n // ""),
        (capture("<command-args>(?<a>[^<]*)</command-args>"; "s").a // "") ]
      | map(select(. != "")) | join(" ")
    else null end;
  def entry($kind; $body): "\(when)  \($kind)\n\($body)\n";

  fromjson? // empty
  | if .type == "user" and (.origin? | human) and (.isMeta? | not) then
      (.message.content | text) as $t
      | ($t | command) as $c
      | if $c != null then entry("command"; $c) else entry("prompt"; $t) end
    elif .type == "attachment" and .attachment.type? == "queued_command"
         and (.attachment.origin? | human) then
      entry("queued"; .attachment.prompt | text)
    elif .type == "user" and (.toolUseResult | type) == "object"
         and (.toolUseResult.answers | type) == "object" then
      .toolUseResult as $r
      | entry("answer";
          [ $r.answers | to_entries[]
            | "Q: \(.key)\nA: \(.value)"
              + (($r.annotations[.key].notes? // "") | if . != "" then "\nNote: \(.)" else "" end)
          ] | join("\n"))
    else empty end
' "$transcript"
