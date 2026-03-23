> Part of [[Product]]

# User Stories

Stories driving the Milestone 1 MVP.

---

## Install an Addon

**As a** Linux WoW player,
**I want to** paste a GitHub repository URL and select my WoW version,
**So that** the addon is automatically downloaded and installed to the correct AddOns folder.

**Acceptance Criteria:**
- I can paste any valid GitHub repo URL
- I can select from all supported WoW flavors (Retail, Classic Era, Cataclysm, etc.)
- The app downloads the correct release asset for my chosen flavor
- The addon appears in my in-game addon list after restarting WoW

---

## See My Installed Addons

**As a** Linux WoW player,
**I want to** see a list of all addons I've installed through AddonManager,
**So that** I have a clear overview of what's installed and at what version.

**Acceptance Criteria:**
- Each addon shows: name, installed version, WoW flavor, update status
- The list loads from disk on startup without requiring internet access

---

## Check for Updates

**As a** Linux WoW player,
**I want to** check if any of my installed addons have newer versions available,
**So that** I can keep my addons up to date without manually checking each GitHub repo.

**Acceptance Criteria:**
- The app queries GitHub releases for each tracked addon
- Addons with newer versions are clearly marked
- I can update a single addon or all outdated addons at once

---

## Configure WoW Paths

**As a** Linux WoW player,
**I want to** tell the app where my WoW installation is,
**So that** addons are installed to the right folder regardless of my Wine/Proton setup.

**Acceptance Criteria:**
- I can set a WoW root path (containing `_retail_/`, `_classic_/`, etc.)
- The app validates that the path looks like a WoW installation
- Auto-detection is attempted for common Lutris/Steam Proton locations
