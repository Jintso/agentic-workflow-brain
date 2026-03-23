> Part of [[Operations]]

# Monitoring & Error Handling

## Philosophy

This is a desktop app — "monitoring" means good error messages to the user, not dashboards.

## Error Handling Strategy

- Use `anyhow::Result` throughout — chain context with `.context("...")`
- Surface errors to the user via GTK4 error dialogs (never silently fail)
- Log to stderr in debug builds (`RUST_LOG=debug`)
- Never crash on recoverable errors (network timeout, missing asset, bad URL)

## Key Error Scenarios

| Scenario | Handling |
|----------|----------|
| Invalid GitHub URL | Validate before API call, show inline error |
| GitHub API rate limit | Show clear message, suggest adding token in settings |
| No matching asset for flavor | Prompt user to select manually or report ambiguity |
| Network timeout/failure | Show retry option, preserve user input |
| WoW path not found | Guide user to settings to configure path |
| Zip extraction failure | Show error, clean up temp files |

## Debug Mode

- `RUST_LOG=debug cargo run` for verbose output
- Log all GitHub API requests/responses in debug mode
- Log file operations (installs, config reads/writes)
