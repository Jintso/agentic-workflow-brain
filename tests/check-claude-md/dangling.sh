# A memory file that is a broken symlink is DANGLING, also when another one exists (2c8cf76).
brain alpha
repo alpha
ln -s ../shared/CLAUDE.md alpha/CLAUDE.md
printf '# Local\n\nThe entry point is `src/main.rs`.\n' > alpha/CLAUDE.local.md
run check-claude-md.sh "$ROOT/brain"
