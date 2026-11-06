# Only the user's own words print: a skill's text, reminders, notifications, agents' messages, tool results and replies don't.
f="$HOME/.claude/projects/p/s1.jsonl"
mkdir -p "${f%/*}"
cat > "$f" <<'JSONL'
{"type":"user","origin":{"kind":"human"},"message":{"role":"user","content":"<command-message>resume</command-message>\n<command-name>/resume</command-name>\n<command-args>game</command-args>"},"timestamp":"2026-11-06T10:00:00.000Z","sessionId":"s1"}
{"type":"user","isMeta":true,"message":{"role":"user","content":"# /resume — the skill's text"},"timestamp":"2026-11-06T10:00:00.010Z","sessionId":"s1"}
{"type":"user","message":{"role":"user","content":"<system-reminder>\nA reminder.\n</system-reminder>"},"timestamp":"2026-11-06T10:00:01.000Z","sessionId":"s1"}
{"type":"assistant","message":{"role":"assistant","content":[{"type":"text","text":"Which step?"}]},"timestamp":"2026-11-06T10:00:05.000Z","sessionId":"s1"}
{"type":"user","origin":{"kind":"human"},"message":{"role":"user","content":"Step 2, and say \"why\" in one line."},"timestamp":"2026-11-06T10:01:00.000Z","sessionId":"s1"}
{"type":"user","message":{"role":"user","content":[{"type":"tool_result","tool_use_id":"t1","content":"ok"}]},"toolUseResult":{"stdout":"ok"},"timestamp":"2026-11-06T10:01:10.000Z","sessionId":"s1"}
{"type":"queue-operation","operation":"enqueue","content":"Also check the tests.","timestamp":"2026-11-06T10:01:20.000Z","sessionId":"s1"}
{"type":"attachment","attachment":{"type":"queued_command","prompt":"Also check the tests.","commandMode":"prompt","origin":{"kind":"human"}},"timestamp":"2026-11-06T10:01:30.000Z","sessionId":"s1"}
{"type":"attachment","attachment":{"type":"queued_command","prompt":"<task-notification>\ndone\n</task-notification>","commandMode":"task-notification","origin":{"kind":"task-notification"}},"timestamp":"2026-11-06T10:01:40.000Z","sessionId":"s1"}
{"type":"attachment","attachment":{"type":"queued_command","prompt":"<agent-message from=\"a1\">report</agent-message>","commandMode":"prompt","origin":{"kind":"peer","from":"a1"}},"timestamp":"2026-11-06T10:01:50.000Z","sessionId":"s1"}
{"type":"attachment","attachment":{"type":"queued_command","prompt":"An origin written as a string.","commandMode":"prompt","origin":"{\"kind\":\"human\"}"},"timestamp":"2026-11-06T10:02:00.000Z","sessionId":"s1"}
JSONL
run user-words.sh s1
