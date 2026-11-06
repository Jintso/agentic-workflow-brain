# A repo whose CLAUDE.md names a file, a folder and a brain path that exist: OK, exit 0.
brain alpha
repo alpha
cat > alpha/CLAUDE.md <<'EOF'
# alpha

The entry point is `src/main.rs`, under `src/`. The plan is `products/alpha/Execution-Plan.md` in the brain.
EOF
run check-claude-md.sh "$ROOT/brain"
