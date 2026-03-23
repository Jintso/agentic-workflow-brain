> Part of [[Engineering]]

# Architecture

## High-Level Overview

```
┌─────────────────────────────────────────┐
│              GTK4 / libadwaita UI        │
│  (Main Window · Add Dialog · Settings)  │
└──────────────────┬──────────────────────┘
                   │
┌──────────────────▼──────────────────────┐
│              Application Core            │
│  AddonManager struct (GTK Application)  │
└──────┬──────────────────────────────────┘
       │
┌──────▼──────────┐    ┌───────────────────┐
│  AddonRegistry  │    │   GitHub Client   │
│  (addons.json)  │    │  (reqwest/tokio)  │
└──────┬──────────┘    └────────┬──────────┘
       │                        │
┌──────▼──────────┐    ┌────────▼──────────┐
│  Local FS Layer │    │  Release Resolver │
│  (install/read) │    │  (asset matching) │
└─────────────────┘    └───────────────────┘
```

## Key Components

### UI Layer (GTK4/libadwaita)
- `AdwApplicationWindow` — main window
- Addon list view with status badges
- Add Addon dialog (URL + flavor input)
- Settings/preferences for WoW paths

### Application Core
- Central `AddonManager` struct owns all state
- Bridges UI signals to business logic
- Manages async task lifecycle via `tokio`

### AddonRegistry
- Reads/writes `~/.config/addon-manager/addons.json`
- Tracks: addon name, source URL, installed version, wow flavor, install path
- Single source of truth for installed addon state

### GitHub Client
- Wraps `reqwest` for GitHub API calls
- Parses release metadata, extracts version tags
- Handles rate limiting gracefully

### Release Resolver
- Given a repo's releases and a `WowFlavor`, selects the correct asset zip
- Contains heuristics for common naming conventions

### Local FS Layer
- Handles zip extraction and file placement
- Maps `WowFlavor` → correct `Interface/AddOns/` path
- See [[Tech-Stack]] for WoW path details

## Data Flow: Installing an Addon

1. User enters GitHub URL + selects WoW flavor → Add Dialog
2. GitHub Client fetches latest release metadata
3. Release Resolver selects correct asset zip
4. Download streamed to temp file
5. Zip extracted, addon folder placed in `Interface/AddOns/`
6. AddonRegistry updated with installed version metadata
7. UI list refreshed

## Config Files

- `~/.config/addon-manager/config.toml` — WoW paths, GitHub token
- `~/.config/addon-manager/addons.json` — installed addon registry
