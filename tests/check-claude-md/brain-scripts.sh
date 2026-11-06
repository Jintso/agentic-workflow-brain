# Gap 18: scripts/ is a brain path too, so a repo with its own scripts/ may name the brain's; one in neither is MISSING.
brain alpha
repo alpha
mkdir brain/scripts alpha/scripts
echo '#!/bin/sh' > brain/scripts/check-links.sh
echo '#!/bin/sh' > alpha/scripts/build.sh
cat > alpha/CLAUDE.md <<'EOF'
# alpha

Build with `scripts/build.sh`. The brain's link checker is `scripts/check-links.sh`.
Neither has `scripts/gone.sh`.
EOF
run check-claude-md.sh "$ROOT/brain"
