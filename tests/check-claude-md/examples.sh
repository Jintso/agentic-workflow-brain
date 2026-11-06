# Tokens after "for example" or "e.g." on their line are skipped (2c8cf76), and so is the Naming example addon-manager/ (650e898).
brain alpha
repo alpha
cat >> brain/CLAUDE.md <<'EOF'

- Folders: lowercase kebab-case (`addon-manager/`, `engineering/`).
- Implementation plans: `engineering/Plan-<Step-Name>.md`, for example `products/alpha/engineering/Plan-Login.md`.
EOF
cat > alpha/CLAUDE.md <<'EOF'
# alpha

The entry point is `src/main.rs`.
A module goes in its own file, e.g. `src/parser.rs`.
Its test sits beside it. For example `src/parser_test.rs`, and E.g. `src/lexer.rs`.
Before the example a path counts: `src/old.rs`, for example `src/new.rs`.
EOF
run check-claude-md.sh "$ROOT/brain"
