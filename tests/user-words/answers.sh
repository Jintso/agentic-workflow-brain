# Answers to Claude's questions print each question with its answer, and the user's note under it.
f="$HOME/.claude/projects/p/s1.jsonl"
mkdir -p "${f%/*}"
cat > "$f" <<'JSONL'
{"type":"user","message":{"role":"user","content":[{"type":"tool_result","tool_use_id":"q1","content":"Your questions have been answered."}]},"toolUseResult":{"questions":[],"answers":{"Which colour?":"Blue (Recommended)","Ship today?":"Not yet"},"annotations":{"Ship today?":{"notes":"After the review."}}},"timestamp":"2026-11-06T11:00:00.000Z","sessionId":"s1"}
{"type":"user","message":{"role":"user","content":[{"type":"tool_result","tool_use_id":"q2","content":"Answered."}]},"toolUseResult":"a plain string result","timestamp":"2026-11-06T11:00:05.000Z","sessionId":"s1"}
JSONL
run user-words.sh s1
