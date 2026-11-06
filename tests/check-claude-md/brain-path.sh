# In a repo's file, products/, company/ and templates/ paths are checked against the brain (2c8cf76).
brain alpha
repo alpha
mkdir brain/templates
echo '# Templates' > brain/templates/README.md
cat > alpha/CLAUDE.md <<'EOF'
# alpha

## Brain

- The plan `products/alpha/Execution-Plan.md`, the values `company/README.md`, the templates `templates/README.md`
- The old spec `products/alpha/Feature-Gone.md`
EOF
run check-claude-md.sh "$ROOT/brain"
