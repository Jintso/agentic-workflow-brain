# A prompt sent as parts (text beside an image) prints its text; a line that isn't JSON is skipped.
f="$HOME/.claude/projects/p/s1.jsonl"
mkdir -p "${f%/*}"
cat > "$f" <<'JSONL'
not json at all
{"type":"user","origin":{"kind":"human"},"message":{"role":"user","content":[{"type":"text","text":"Look at this:"},{"type":"image","source":{"type":"base64","data":"AAAA"}},{"type":"text","text":"the second line."}]},"timestamp":"2026-11-06T12:00:00.000Z","sessionId":"s1"}
JSONL
run user-words.sh s1
