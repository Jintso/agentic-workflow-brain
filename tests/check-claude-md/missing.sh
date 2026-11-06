# A repo path that no longer exists is MISSING, with its file and line.
brain alpha
repo alpha
cat > alpha/CLAUDE.md <<'EOF'
# alpha

The entry point is `src/main.rs`.
The parser is `src/parse.rs`.
EOF
run check-claude-md.sh "$ROOT/brain"
