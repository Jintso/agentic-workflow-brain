# Not checked: placeholders and globs, URLs, commands with spaces, options, bare names, a first part not at the root, fenced blocks, and a missing path git ignores.
brain alpha
repo alpha
git -c init.defaultBranch=main -C alpha init -q
echo 'src/generated.rs' > alpha/.gitignore
cat > alpha/CLAUDE.md <<'EOF'
# alpha

- `src/<module>.rs`, `src/*.rs`, `src/…`, `src/$NAME`, `src/{a,b}.rs`, `src/(old)`, `src/a?.rs`, `src/#1`
- `https://example.com/src/gone.rs`, `cargo run --bin src/gone`, `-src/gone`
- `gone.rs`, `origin/main`, `docs/gone.md`
- `src/generated.rs` is made by the build.

```
`src/gone.rs`
```
~~~
`src/gone.rs`
~~~
EOF
run check-claude-md.sh "$ROOT/brain"
