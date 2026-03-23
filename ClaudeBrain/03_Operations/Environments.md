> Part of [[Operations]]

# Environments

## Development

- **OS:** Linux (CachyOS / Arch-based)
- **Rust:** stable toolchain via `rustup`
- **GTK4 + libadwaita:** system packages (e.g. `gtk4`, `libadwaita` from pacman)
- **Build:** `cargo build` / `cargo run`
- **Test:** `cargo test`

## Runtime

- **Target:** Linux desktop (any distro with GTK4 + libadwaita)
- **WoW:** Running via Wine, Lutris, or Steam Proton
- **Config dir:** `~/.config/addon-manager/`
- **No internet required at startup** — update checks are on-demand

## Required System Libraries

- `gtk4` >= 4.x
- `libadwaita` >= 1.x
- `pkg-config` (for Cargo build scripts)

## Future Distribution

When/if open-sourced, consider:
- Flatpak (bundles GTK4/libadwaita — no system dep issues)
- AUR package for Arch/CachyOS users
- Binary releases via GitHub Actions

See [[CI-CD]] for pipeline plans.
