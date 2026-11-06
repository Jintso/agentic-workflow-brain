# Gap 19: a path in backticks is checked even where the sentence says it isn't there; written after "for example", or without backticks, it isn't.
brain alpha
repo alpha
cat > alpha/CLAUDE.md <<'EOF'
# alpha

The old parser, `src/legacy/`, is *not* in this tree.
A `./file` mount silently becomes an empty directory.
For example `src/legacy/` and `./file`: so written, neither is checked, nor is src/legacy/ outside backticks.
EOF
run check-claude-md.sh "$ROOT/brain"
