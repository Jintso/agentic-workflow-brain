# Agentic Workflow Brain

Persistent, multi-product project memory for Claude Code. A brain is a folder of plain markdown files: no cloud, no packages, no required app. Any editor, forge, or note tool that renders markdown can browse it. Claude Code reads it at the start of a session and updates it at the end, so no context is lost between sessions.

## What This Is

Ten **Claude Code slash commands** plus a folder convention. Together they give Claude a structured long-term memory for an organisation and every product it builds.

- **One brain, many products.** Shared context (vision, values) lives once. Each product gets a self-contained folder with its own roadmap, architecture, decisions and session history.
- **Continuity through handoffs.** Every session ends with a handoff document. Every session starts by reading the latest one.
- **Plain markdown, standard links.** Files link with ordinary relative links, so the brain renders on GitHub, in VS Code, in Obsidian, Logseq, Foam, or `less`. A dependency-free shell script verifies the links.

## Commands

| Command | What it does |
|---------|-------------|
| `/init-brain` | Interactive wizard. Creates the shared structure and the first product. |
| `/add-product` | Interviews you about a product and generates its self-contained folder. |
| `/resume [product]` | Loads context, shows progress, recommends what to work on. |
| `/wrap-up` | Captures session work, writes a handoff, updates the execution plan. |
| `/status [product\|all]` | Portfolio dashboard across products, or a deep dive on one. |
| `/plan [product] <step>` | Breaks an execution plan step into concrete tasks. |
| `/sprint [product\|all]` | Plans a week of work with daily themes and effort estimates. |
| `/feature [product] <name>` | Full feature lifecycle: spec, plan, implement, update brain. |
| `/sync` | Audits brain health, runs the link checker, repairs what it can. |
| `/migrate <path>` | Imports a vault made with the original single-product layout. |

Commands that act on one product pick it from the argument, from the conversation so far, or automatically when only one exists. Otherwise they list the products and ask.

## Setup

### Prerequisites

- **Claude Code** installed and authenticated ([setup guide](https://code.claude.com/docs/en/setup))
- **Git**, to clone this repo and, ideally, to version your brain

### Install

```bash
git clone https://github.com/Jintso/agentic-workflow-brain.git
cd agentic-workflow-brain
./install.sh /path/to/your/brain      # created if it doesn't exist
```

This copies into the brain directory:

- 10 slash commands → `.claude/commands/`
- Templates → `templates/`
- The link checker → `scripts/check-links.sh`
- `CLAUDE.md`, if none exists

Re-running the installer upgrades the commands and script and leaves your templates and `CLAUDE.md` alone.

### Create Your Brain

```bash
cd /path/to/your/brain
claude
```

Then type `/init-brain`. The wizard asks about your organisation, then about your first product, and generates real content for every file. Add more products any time with `/add-product`.

### Where to Put the Brain

**Its own repository** (recommended, especially with several products). Start Claude from the brain and give it access to whichever code base you're working on:

```bash
cd ~/brain
claude --add-dir ~/code/addon-manager
```

**Shorter start command.** Typing that every session gets old. Add one shell alias per product so a session is one word away:

```bash
# bash / zsh (~/.bashrc or ~/.zshrc)
alias brain-addons='cd ~/brain && claude --add-dir ~/code/addon-manager'
alias brain-shop='cd ~/brain && claude --add-dir ~/code/webshop'
```

```fish
# fish (~/.config/fish/config.fish)
alias brain-addons 'cd ~/brain && claude --add-dir ~/code/addon-manager'
alias brain-shop 'cd ~/brain && claude --add-dir ~/code/webshop'
```

Then `brain-addons` opens Claude in the brain with that product's code attached, and `/resume addon-manager` is the first thing you type.

**Inside a code repository.** Run `./install.sh .` at the repo root. The brain files sit next to the code, and `claude` started from the root sees both. Use this for a single product whose code and brain should travel together.

## Daily Workflow

```
/resume addon-manager   ← Start of session: loads context, shows progress
... work ...            ← Claude has full product context
/wrap-up                ← End of session: writes the handoff for next time
```

## Brain Structure

```
BRAIN-INDEX.md                Entry point: organisation, portfolio, shared links
CLAUDE.md                     Claude's operating instructions for this brain

company/                      Shared context
  README.md
  Vision.md
  Values.md

products/
  README.md                   Portfolio table: status, phase, last session, code location
  addon-manager/              One self-contained folder per product
    README.md                 Product index: description, code location, current status
    Execution-Plan.md         Phased roadmap with step statuses and task checklists
    MVP-Scope.md              What ships first, and what doesn't
    Feature-Priorities.md     Ranked features, linking to their specs
    User-Stories.md           Who needs what, and why
    features/                 One spec per feature
    engineering/              Architecture, tech stack, conventions, plans, adr/
    operations/               Environments, CI/CD, monitoring
    handoffs/                 handoff-001.md, handoff-002.md, sprint plans
    assets/                   Images, PDFs, reference files (optional)
  another-product/
    ...

templates/                    Shared templates for handoffs, ADRs, feature specs
scripts/check-links.sh        Structural integrity check
```

## Conventions

These are what make the brain navigable by both people and agents. `CLAUDE.md` carries them, and `scripts/check-links.sh` enforces them.

- **Relative markdown links only.** `[Architecture](engineering/Architecture.md)`, never `[[Architecture]]`. Paths are relative to the file that contains them.
- **Every file has a parent line.** The first line of every file except `BRAIN-INDEX.md` and `CLAUDE.md` is `> Part of [Parent](path.md)`.
- **Every folder has a `README.md`** that links to everything inside it. Forges render it when you browse the folder.
- **Products are self-contained.** Nothing in `products/a/` links into `products/b/`. Shared material goes in `company/`. A product folder can be archived or moved out without breaking anything.
- **Code is referenced, not linked.** `src/main.rs` in backticks. The code is not part of the brain.
- **Naming:** folders lowercase kebab-case, documents PascalCase with hyphens, handoffs and ADRs numbered per product.

## Verifying the Brain

```bash
scripts/check-links.sh            # from the brain root
scripts/check-links.sh ~/brain    # or point it somewhere
```

It scans `BRAIN-INDEX.md`, `company/` and `products/` and reports broken links, leftover wikilinks, files without a parent line, orphans nothing links to, and cross-product links. Exit code 1 on issues, so it works as a pre-commit hook or CI step for the brain repo. `/sync` and `/wrap-up` run it for you.

## Migrating From obsidian-brain

If you have a vault from the original single-product version (numbered `00_Company/` folders, wikilinks), install this into a new directory and run:

```
/migrate /path/to/old-vault
```

It copies the vault into `products/<slug>/`, renames folder indexes to `README.md`, converts every wikilink to a relative link, and registers the product. The source vault is never modified.

## Customization

The commands are markdown files in `.claude/commands/`. Edit them freely:

- Change the product folder layout in `add-product.md`
- Adjust the handoff format in `wrap-up.md` and `templates/Handoff-Template.md`
- Add departments (`design/`, `research/`) or remove ones you don't need
- Add organisation-wide rules to `CLAUDE.md`
- Add your own slash commands

If you add top-level brain folders beyond `company/` and `products/`, add them to the `SCAN` list in `scripts/check-links.sh`.

## Tips

- **Don't skip `/wrap-up`.** It is what makes `/resume` useful.
- **Run `/sync` weekly** to keep the link graph clean.
- **Version the brain with git.** Every session then has a diff you can read.
- **Use whatever viewer you like.** Obsidian's graph view, VS Code's markdown preview, or GitHub's file browser all work, because it's just markdown and relative links.
- **Pin the entry points** in your editor: `BRAIN-INDEX.md` and the product `README.md` you're working on.

## License

MIT. See [LICENSE](LICENSE). Clone it, fork it, change it, ship it; just keep the copyright notice.
