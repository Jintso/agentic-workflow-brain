# Changelog

What each release changed, newest first. A release that asks something of you when you upgrade says so under **Upgrade**: which parts of `templates/CLAUDE.md` or the templates changed, or which command to run. Since 2.2.0 the installer merges the templates' changes into your brain itself, and leaves you only a conflict. The installer records the version it installed in your brain's `.claude/brain-version`, so the entries to read are the ones after that version.

Versions are `major.minor.patch`:

- **major:** an existing brain needs more than a merge, such as a new layout that `/migrate` moves it to
- **minor:** a command gains behaviour, or a template or a rule in `templates/CLAUDE.md` changes
- **patch:** a fix that asks nothing of you

## 2.3.0 — 2026-11-06

### Added

- `check-links.sh` reports a merge the installer left on a conflict, `CLAUDE.md.merge` or `templates/*.merge`, as `MERGE`, with the conflicts still marked in it. `/sync` shows them, proposes a resolution that keeps your text, and writes it over your file once you agree

### Upgrade

- Nothing to merge by hand: this release changes no template

## 2.2.0 — 2026-11-06

The installer merges what the templates changed into your `CLAUDE.md` and templates.

### Added

- On an upgrade, the installer merges what the templates changed since your brain's version into your `CLAUDE.md` and templates: three ways, with `git merge-file`, and the template of your brain's version as the base. It writes a clean merge and shows what it changed. Where you and the template changed the same lines, it leaves your file as it is and writes the merge, with its conflicts marked, to `<file>.merge` beside it. Before, it kept them and printed the `git diff` to merge by hand

### Fixed

- `session-times.sh` wrote "1 turns", and in a session's first turn "0 completed turns and the running one"

### Upgrade

- Nothing to merge by hand: this release changes no template. The installer of this release already merges, so a brain that skipped an earlier entry's merge gets those lines now, unless they conflict with yours. It needs your brain's version as a tag in the clone you install from

## 2.1.1 — 2026-11-06

### Fixed

- `templates/CLAUDE.md` named `company/handoffs/`, which `/wrap-up` creates only at the first session that changes the brain itself. Until then `check-claude-md.sh` reported it as `MISSING`, in every new brain too. The line now points at `company/README.md`, which lists the handoffs once there are any

### Upgrade

- If you merged the `company/README.md` line of *Where Things Are* from 2.1.0, take this wording instead. If you didn't merge it yet, merge this one

## 2.1.0 — 2026-11-06

A record for sessions that change the brain itself, and one rule for when the brain is committed.

### Added

- `/wrap-up` writes a handoff for brain-level work, in `company/handoffs/`: changes to `company/`, the templates, the brain's `CLAUDE.md`, its installed commands, its git setup, or repairs across products. It creates the folder on first use. A session that also worked on a product writes both handoffs
- `/resume brain` briefs from the brain's latest handoff, and the product list shows it
- `/resume` reports commits that a session left unpushed
- `/sync` checks the brain's handoff chain

### Changed

- Every command that writes the brain commits the files it wrote when it finishes, and only `/wrap-up` pushes, once at the end of the session. Before, the rule said only "in the same session", and some commands committed and pushed at once while others waited for `/wrap-up`

### Upgrade

- Merge three lines of `templates/CLAUDE.md` into your brain's `CLAUDE.md`: *Session Protocol*, step 2; *The Brain in Git*, the first bullet; *Where Things Are*, the `company/README.md` line. The installer shows them with `git diff`. The commands follow the new rule without the merge

## 2.0.0 — 2026-11-06

The multi-product brain, rebuilt from 1.0.0 on 2026-09-25 and released for the first time. One brain holds every product of an organisation, each in `products/<slug>/`, and a product session starts in its code repo with the brain attached.

### Added

- Ten commands: `/init-brain`, `/add-product`, `/migrate`, `/resume`, `/wrap-up`, `/plan`, `/feature`, `/sprint`, `/status`, `/sync`
- `/add-product` reads what exists before it asks: the code, the repo's docs and history, and a document kept outside the repo
- `/migrate` imports a 1.0.0 vault into `products/<slug>/`, and leaves the old vault as it was
- Three scripts: `check-links.sh` (the link graph), `check-claude-md.sh` (the paths each `CLAUDE.md` names) and `session-times.sh` (a session's measured times, for the handoff)
- A brain kept in git: `/resume` pulls it, and `/wrap-up` commits and pushes only the session's own files
- `Execution-Plan-Archive.md` in each product, for finished phases
- `tests/run.sh`, regression cases for the scripts and the installer, run by CI on Ubuntu and macOS
- `VERSION`, this changelog, and `.claude/brain-version` in the brain

### Changed

- Standard markdown links instead of wikilinks, and a `README.md` in every folder instead of numbered folders
- `templates/CLAUDE.md` is a map: the rules that hold on every edit, and a pointer for the rest
- The installer asks for a merge only when the templates changed since the version a brain has. Before, it asked whenever a brain's `CLAUDE.md` differed from the template, which after `/init-brain` is always

### Upgrade

- **From 1.0.0:** install into a new directory and run `/migrate /path/to/old-vault`, as the README's *Migrating From obsidian-brain, 1.0.0* says
- **From an install made between 2026-09-25 and this release:** your brain has no `.claude/brain-version`, so the installer can't tell which templates you have. Merge the changes after your install date from *Installed Before 2.0.0?* below

## Installed Before 2.0.0?

Between the rebuild and 2.0.0, `main` was the release, and six commits changed what the installer keeps in your brain instead of replacing. If you installed between two of them, merge what came after. `git -C <this repo> show <commit> -- templates/` shows each one.

| Date | Commit | What changed |
|------|--------|--------------|
| 2026-11-06 | `0d45104` | `CLAUDE.md`: *Session Protocol* pulls the brain at the start and commits and pushes it at the end; a new section, *The Brain in Git* |
| 2026-10-22 | `650e898` | `CLAUDE.md`, *Naming*: the folder example is `addon-manager/`, which `check-claude-md.sh` doesn't read as a path |
| 2026-10-22 | `d196916` | `CLAUDE.md` rewritten as a map: *Where Things Are* replaces *Layout*; new are *Compact Instructions*, *Content* (a summary under each title, templates, status that holds only the present), the archive rule for finished phases, the fork rule, and two standing conventions (times are measured; a `CLAUDE.md` is a map). `Handoff-Template.md`: *Duration* becomes *Time*, from `session-times.sh`. `templates/README.md`: the installer places `CLAUDE.md` |
| 2026-09-29 | `2a4b880` | `CLAUDE.md`, *Code Location*: the *Brain* section goes into `CLAUDE.local.md` whenever a clone of the repo lives where the brain is not |
| 2026-09-28 | `8121d60` | `CLAUDE.md`, *Code Location*: the *Brain* section goes into `CLAUDE.local.md` when the repo is public. Replaced by `2a4b880` |
| 2026-09-28 | `7311f58` | `CLAUDE.md`: a new section, *Brain Root*; a product is also found from the working directory; *Code Location* starts product sessions in the code repo with the brain attached |

## 1.0.0 — 2026-03-25

*obsidian-brain*: one product per vault, eight commands (`/init-brain`, `/resume`, `/wrap-up`, `/plan`, `/feature`, `/sprint`, `/status`, `/sync`), numbered folders such as `00_Company/`, and wikilinks. Tagged afterwards, on 2026-11-06, so that the vaults `/migrate` imports have a version.
