# A repo whose only memory file is CLAUDE.local.md is no NO-FILE, and its paths are checked (650e898).
brain alpha
repo alpha
printf '## Brain\n\n- Product folder: `products/alpha/`\n- Old notes: `src/notes.md`\n' > alpha/CLAUDE.local.md
run check-claude-md.sh "$ROOT/brain"
