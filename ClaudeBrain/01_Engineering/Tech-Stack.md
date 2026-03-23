> Part of [[Engineering]]

# Tech Stack

## Language & Build

| Tool | Version | Purpose |
|------|---------|---------|
| Rust | stable | Primary language |
| Cargo | (bundled) | Build system, dependency management |

## GUI

| Crate | Purpose |
|-------|---------|
| `gtk4` | GTK4 Rust bindings |
| `libadwaita` | GNOME HIG widgets (AdwApplicationWindow, AdwDialog, etc.) |

Follow GNOME HIG and libadwaita patterns. Use `AdwPreferencesWindow` for settings, `AdwDialog` for add/confirm flows.

## Async & Networking

| Crate | Purpose |
|-------|---------|
| `tokio` | Async runtime for downloads and API calls |
| `reqwest` | HTTP client (GitHub API + asset downloads) |

GTK4 main loop and tokio runtime must coexist — use `glib::spawn_future_local` or a dedicated tokio runtime thread with channel-based UI updates.

## Serialization & Config

| Crate | Purpose |
|-------|---------|
| `serde` + `serde_json` | Addon registry (`addons.json`) |
| `toml` + `serde` | User config (`config.toml`) |

## Utilities

| Crate | Purpose |
|-------|---------|
| `zip` | Extract downloaded addon archives |
| `dirs` | Cross-platform config dir (`~/.config/`) |
| `anyhow` | Error handling |

## WoW Version Paths (Linux/Wine)

Each WoW flavor installs to a different subdirectory:

| Flavor | Directory |
|--------|-----------|
| Retail (The War Within) | `_retail_/Interface/AddOns/` |
| Classic Era | `_classic_era_/Interface/AddOns/` |
| Cataclysm Classic | `_classic_/Interface/AddOns/` |
| Mists of Pandaria Classic | `_classic_/Interface/AddOns/` |

The WoW root is user-configured (e.g., a Wine/Proton prefix path). See [[Architecture]] for config details.

## Related Decisions

- See [[ADR]] for key architectural decisions as they are made.
