# A session where the user has said nothing yet prints nothing and exits 0.
f="$HOME/.claude/projects/p/s1.jsonl"
mkdir -p "${f%/*}"
printf '{"type":"assistant","message":{"role":"assistant","content":[{"type":"text","text":"Hi."}]},"timestamp":"2026-11-06T09:00:00.000Z","sessionId":"s1"}\n' > "$f"
run user-words.sh s1
