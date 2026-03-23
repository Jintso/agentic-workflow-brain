> Part of [[Company]]

# Values

Principles that guide every technical and product decision in AddonManager.

## 1. Native First
Use GTK4 and libadwaita properly. Follow GNOME HIG. The app should feel like it belongs on the Linux desktop, not like a port.

## 2. Correctness Over Features
Installing the wrong addon version for a WoW flavor is worse than not installing at all. Always validate, always confirm when ambiguous.

## 3. Minimal Dependencies
Rust's ecosystem is rich but dependency sprawl is real. Prefer stdlib or well-maintained crates. Avoid pulling in crates for trivial tasks.

## 4. Respect the User's System
- Never write outside of `~/.config/addon-manager/` and the configured WoW paths
- Never delete addon files without explicit user confirmation
- Config files should be human-readable TOML

## 5. Open by Default (When Ready)
If this is published, it should be easy to contribute to: clear architecture, documented ADRs, and a welcoming README.
