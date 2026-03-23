> Part of [[BRAIN-INDEX]]

# Engineering

## Contents

- [[Architecture]] — System design and component overview
- [[Tech-Stack]] — Languages, frameworks, and crates
- [[Conventions]] — Coding standards and patterns
- [[ADR]] — Architecture Decision Records index

## Overview

AddonManager is a Rust binary using GTK4 and libadwaita for the GUI and `tokio` for async operations (downloads, API calls). It interacts with the GitHub Releases API and the local filesystem to manage WoW addon installations.

See [[Execution-Plan]] for current implementation roadmap.
