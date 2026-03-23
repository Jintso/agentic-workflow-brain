> Part of [[BRAIN-INDEX]]

# Execution Plan — AddonManager

## Phase 1: Project Setup & Foundation
**Status:** in_progress
**Target:** Working Cargo project with GTK4 window

### Step 1.1: Initialize Cargo Project
- **Status:** completed
- **Effort:** S
- **Dependencies:** none
- **Description:** Scaffold a new Rust binary with GTK4, libadwaita, and core dependencies.
- [x] `cargo new addon-manager`
- [x] Add dependencies: `gtk4`, `libadwaita`, `tokio`, `reqwest`, `serde`, `serde_json`
- [x] Verify GTK4 + libadwaita window opens and compiles clean

### Step 1.2: Define Core Data Models
- **Status:** completed
- **Effort:** S
- **Dependencies:** Step 1.1
- **Description:** Define Rust structs for Addon, WoW version/flavor, and installation state.
- [x] `Addon` struct: name, source URL, installed version, latest version, wow_flavor
- [x] `WowFlavor` enum: Retail, ClassicEra, Classic (covers Cata/Mists — same `_classic_/` path)
- [x] `AddonState` enum: Installed, UpdateAvailable, Installing, CheckingForUpdates
- [x] Write unit tests for model serialization

### Step 1.3: WoW Installation Detection
- **Status:** completed
- **Effort:** M
- **Dependencies:** Step 1.2
- **Description:** Detect WoW install paths on Linux (native and via Wine/Proton) and map flavors to AddOns directories.
- [x] Scan common install paths (`~/.wine`, Lutris, Bottles prefixes)
- [x] Map WoW flavor to correct `Interface/AddOns` subdirectory
- [x] Allow manual path override in config
- [x] Store config in `~/.config/addon-manager/config.toml`

---

## Phase 2: GitHub Integration & Download Engine
**Status:** completed
**Target:** Can download and install an addon from a GitHub URL

### Step 2.1: GitHub Release API Client
- **Status:** completed
- **Effort:** M
- **Dependencies:** Step 1.1
- **Description:** Fetch release metadata from GitHub API for a given repo URL, respecting rate limits.
- [x] Parse GitHub repo URL into owner/repo
- [x] `GET /repos/{owner}/{repo}/releases/latest` via `reqwest`
- [x] Handle unauthenticated rate limiting (60 req/hr); surface error gracefully
- [x] Optionally support GitHub token in config for higher limits

### Step 2.2: Asset Selection by WoW Flavor
- **Status:** completed
- **Effort:** M
- **Dependencies:** Step 2.1, Step 1.2
- **Description:** Given a release's assets, select the correct zip for the target WoW flavor.
- [x] Parse asset filenames for flavor hints (e.g. `classic`, `bcc`, `wrath`, `cata`, `retail`)
- [x] Fall back to single-asset releases if no flavor tag present
- [x] Surface ambiguity to user when multiple assets match

### Step 2.3: Download & Install
- **Status:** completed
- **Effort:** M
- **Dependencies:** Step 2.2, Step 1.3
- **Description:** Download the zip asset, extract it, and place the addon folder(s) in the correct AddOns directory.
- [x] Stream download to temp file with progress reporting
- [x] Extract zip and identify top-level addon folder(s)
- [x] Copy to `{wow_path}/Interface/AddOns/`
- [x] Write metadata file (installed version, source URL, flavor) to `~/.config/addon-manager/addons.json`

---

## Phase 3: Basic GUI
**Status:** completed
**Target:** Working GTK4/libadwaita window showing installed addons

### Step 3.1: Main Window & Addon List
- **Status:** completed
- **Effort:** L
- **Dependencies:** Step 1.1, Step 1.2
- **Description:** Build the main application window with an AdwNavigationView or simple list showing installed addons.
- [x] AdwApplicationWindow with header bar
- [x] GtkListBox or AdwListBox showing addons (name, version, status badge)
- [x] Empty state view when no addons installed
- [x] Load addon list from `addons.json` on startup

### Step 3.2: Add Addon Dialog
- **Status:** completed
- **Effort:** M
- **Dependencies:** Step 3.1, Step 2.3
- **Description:** Dialog for adding a new addon via GitHub URL with WoW flavor selector.
- [x] AdwDialog with URL entry and flavor dropdown
- [x] Validate GitHub URL format before allowing submit
- [x] Show progress bar during download/install
- [x] Refresh addon list on success

### Step 3.3: WoW Path Settings
- **Status:** completed
- **Effort:** S
- **Dependencies:** Step 1.3, Step 3.1
- **Description:** Settings page for configuring WoW installation paths per flavor.
- [x] AdwPreferencesWindow or settings dialog
- [x] One path entry per detected/configured flavor
- [x] "Detect automatically" button

---

## Phase 4: Update Checking & v1 Polish
**Status:** completed
**Target:** Milestone 1 complete — download + update checks working

### Step 4.1: Update Check Engine
- **Status:** completed
- **Effort:** M
- **Dependencies:** Step 2.1, Step 2.3
- **Description:** Compare installed version tags against latest GitHub release for all tracked addons.
- [x] For each addon in `addons.json`, fetch latest release tag
- [x] Compare against stored installed version
- [x] Update `AddonState` to `UpdateAvailable` where applicable
- [x] Run checks in parallel with `tokio::spawn`

### Step 4.2: Update UI & One-Click Update
- **Status:** completed
- **Effort:** M
- **Dependencies:** Step 4.1, Step 3.1
- **Description:** Surface update availability in the addon list and allow one-click updating.
- [x] Show "Update Available" badge on addon rows
- [x] "Update All" button in header bar
- [x] Per-addon update button in row actions
- [x] Refresh list after update completes

### Step 4.3: Auto-check on Launch
- **Status:** completed
- **Effort:** S
- **Dependencies:** Step 4.1
- **Description:** Trigger update checks automatically when the app starts, non-blocking.
- [x] Spawn update check task on app startup
- [x] Show subtle loading indicator while checking
- [x] Do not block UI during check


#### Step 4.3.1: Polish
- ~~**Add: When adding custom path add "Save" button then close, more intuitive**~~
- ~~**Fix: Add auto detect of Heroic Game Launcher paths, i.e. `~/Games/Heroic/Prefixes/default/Battle.net/drive_c/Program Files (x86)/World of Warcraft`**~~
- ~~**Fix: After adding manual path addons are not detected, should be detected if they have no github link. Make it optional to add a github link and connect to the existing addon**~~
- ~~**Fix: Settings window should fit content, currently very small.**~~
- ~~**Fix: Handle the build warnings**~~
- ~~Fix: Use addon .toc file to get the Title property value that should be used in the AddonManger list view.~~
- ~~Fix: Update button not doing anything after adding a github url.~~
  ~~Example url; https://github.com/zarillion/handynotes-plugins
- ~~Fix: Some addons include multiple folders that get extracted to the root Addons folder. The app needs to somehow recognize this and consolidate them in the GUI.~~
  ~~Example of the BigWigs addon zip can be found here; `/home/jintzo/Downloads/BigWigs-v410.9/` please study it.~~
  ~~Maybe we can find the information needed in any of the files coming in the main addon folder, i.e. `BigWigs`.~~
- ~~Fix: Multiple zip assets match for update. Let the user choose the zip if that happens.~~
- ~~Fix: Title cleanup, remove non needed text fromt he title.~~
  ~~i.e. `.../Addons/MoveAny/MoveAny.toc` This part `M|cff3FC7EBove|rA|cff3FC7EBny|r` seems to be the title the rest is not needed.~~
- ~~Fix: Be able to change github url and also go to (open browser) set url with right click context.~~
- ~~Fix: Be able to select (right click context) complete ignore (remove from list) or mark as externally tracked (other app is managing it). Externally tracked would still show it and the latest .toc info.~~
- ~~Add: Use the addon .toc files to show dependecies and latest release date.~~
- ~~Fix: Right click context not triggering if the addon is not tracked?~~
- ~~Add: Toggle to hide externals from the list~~
- ~~Add: Name and Status sorting~~
- ~~Fix: Remove rounded edges around the table, cuts off when scrolling.~~
- ~~Fix: Enlarge App title and Add addon + button~~


### Step 4.4: v1 Release Prep
- **Status:** completed
- **Effort:** S
- **Dependencies:** Step 4.2, Step 4.3
- **Description:** Final polish, README, and optional GitHub repo publication.
- [x] Write README with install instructions and usage
- [x] Add `.desktop` file for app launcher integration
- [ ] Tag v1.0.0 release
- [ ] Decide on open-source publication
