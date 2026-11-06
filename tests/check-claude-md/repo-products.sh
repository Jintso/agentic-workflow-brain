# A repo with its own products/ folder: a products/ path may be in the repo or in the brain, and is MISSING only in neither (2c8cf76).
brain alpha
repo alpha
mkdir alpha/products
echo 'list' > alpha/products/list.md
cat > alpha/CLAUDE.md <<'EOF'
# alpha

The product list is `products/list.md`. The brain's folder is `products/alpha/`.
Neither has `products/gone.md`.
EOF
run check-claude-md.sh "$ROOT/brain"
