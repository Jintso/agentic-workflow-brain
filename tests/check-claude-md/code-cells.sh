# A Code cell with a ~/ or / path, in backticks or bare, is a location, and one that isn't a folder is NO-REPO (2c8cf76); a URL or "not started" is not checked.
brain alpha beta="$ROOT/beta" gamma='`~/gone`' delta='not started' epsilon='`https://example.com/epsilon`'
repo alpha
repo beta
printf 'See `src/main.rs`.\n' > alpha/CLAUDE.md
printf 'See `src/gone.rs`.\n' > beta/CLAUDE.md
run check-claude-md.sh "$ROOT/brain"
