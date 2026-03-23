> Part of [[Operations]]

# CI/CD

## Current State

No CI pipeline yet — this is a personal project starting from scratch.

## Planned (When Open-Sourced)

- **GitHub Actions** for:
  - `cargo build` + `cargo test` on push
  - `cargo clippy -- -D warnings` lint check
  - `cargo fmt --check` format check
  - Release builds on tag push (`v*`)

## Release Process (Manual for Now)

1. `cargo build --release`
2. Test binary locally against real WoW installation
3. Tag with `git tag v1.0.0`
4. (Future) GitHub Actions builds and attaches binary to release

See [[Environments]] for build requirements.
