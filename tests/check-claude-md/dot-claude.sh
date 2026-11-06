# .claude/CLAUDE.md is read too, and so is the brain's own CLAUDE.local.md (2c8cf76).
brain alpha
repo alpha
mkdir alpha/.claude
printf 'See `src/gone.rs`.\n' > alpha/.claude/CLAUDE.md
printf 'See `products/gone/`.\n' > brain/CLAUDE.local.md
run check-claude-md.sh "$ROOT/brain"
