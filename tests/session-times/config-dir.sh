# With CLAUDE_CONFIG_DIR set, the transcripts are under it, not under ~/.claude.
rec prompt 10:00:00 1
rec close  10:10:00 600000
mv .claude other
CLAUDE_CONFIG_DIR="$ROOT/other" run session-times.sh s1
