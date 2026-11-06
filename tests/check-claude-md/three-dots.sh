# Gap 18: a token holding ... is a placeholder, as one holding … is.
brain alpha
repo alpha
printf 'Every path a brain command mentions (`BRAIN-INDEX.md`, `products/...`, `products/…`) is relative to the brain root.\n' > alpha/CLAUDE.md
run check-claude-md.sh "$ROOT/brain"
