# Home and absolute paths are checked in CLAUDE.local.md (83ee28a) and skipped in CLAUDE.md; /wrap-up is a command, not a path (5de9d51).
brain alpha
repo alpha
cat > alpha/CLAUDE.local.md <<EOF
## Brain

- Brain root: \`~/brain\`, also \`$ROOT/brain\`
- Old brain root: \`~/old-brain\`, also \`/nowhere/old-brain\`
- Start with \`/resume alpha\`, end with \`/wrap-up\`; \`/alpha:deploy\` deploys.
EOF
cat > alpha/CLAUDE.md <<'EOF'
# alpha

On the server it lives in `~/srv/alpha` and `/srv/alpha/`.
EOF
run check-claude-md.sh "$ROOT/brain"
