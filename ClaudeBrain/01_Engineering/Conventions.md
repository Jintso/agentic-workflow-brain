> Part of [[Engineering]]

# Conventions

## Rust Style

- Follow `rustfmt` defaults — run `cargo fmt` before committing
- Use `clippy` — `cargo clippy -- -D warnings` should pass clean
- Prefer `anyhow::Result` for error propagation in application code
- Use `thiserror` for library-style error types if needed later
- No `unwrap()` or `expect()` in production paths — propagate errors

## Module Structure

```
src/
  main.rs          — app entry point, GtkApplication setup
  app.rs           — AddonManager application struct
  ui/
    window.rs      — main window
    add_dialog.rs  — add addon dialog
    settings.rs    — preferences window
  addon/
    mod.rs         — Addon, WowFlavor, AddonState types
    registry.rs    — read/write addons.json
    installer.rs   — download, extract, install
  github/
    client.rs      — GitHub API calls
    resolver.rs    — asset selection logic
  config.rs        — config.toml read/write
```

## GTK4 / GObject Patterns

- Use `glib::clone!` macro for capturing references in signal handlers
- Async UI updates via `glib::spawn_future_local` — never block the main thread
- Keep UI logic in `ui/` modules, business logic out of UI code

## Naming

- Structs: `PascalCase`
- Functions/methods: `snake_case`
- Constants: `SCREAMING_SNAKE_CASE`
- Files: `snake_case.rs`
- WoW flavors in config/JSON: lowercase strings (`"retail"`, `"classic_era"`, `"cataclysm"`)

## Testing

- Unit test pure logic (asset name parsing, version comparison, config serialization)
- Integration tests for filesystem operations use `tempdir`
- No tests required for GTK UI code (test the logic beneath it)

## Git

- Commit messages: imperative mood, e.g. `Add GitHub release fetching`
- One logical change per commit
- Branch naming: `feature/`, `fix/`, `chore/`
