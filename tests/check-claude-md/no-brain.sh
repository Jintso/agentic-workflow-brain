# A folder without both BRAIN-INDEX.md and products/ is no brain: exit 2.
mkdir -p half/products
run check-claude-md.sh "$ROOT/half"
