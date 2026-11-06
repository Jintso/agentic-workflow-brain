# Agentic Workflow Brain

Persistent, multi-product project memory for Claude Code. A brain is a folder of plain markdown files: no cloud, no packages, no required app. Any editor, forge, or note tool that renders markdown can browse it. Claude Code reads it at the start of a session and updates it at the end, so no context is lost between sessions.

## What This Is

Ten **Claude Code slash commands** plus a folder convention. Together they give Claude a structured long-term memory for an organisation and every product it builds.

- **One brain, many products.** Shared context (vision, values) lives once. Each product gets a self-contained folder with its own roadmap, architecture, decisions and session history.
- **Continuity through handoffs.** Every session ends with a handoff document. Every session starts by reading the latest one.
- **Built for long sessions.** `CLAUDE.md` is a short map whose *Compact Instructions* tell a compaction what to keep: decisions, open items, and references copied exactly. A product's status holds only the present, and finished phases move to an archive, so `/resume` reads what matters now.
- **Plain markdown, standard links.** Files link with ordinary relative links, so the brain renders on GitHub, in VS Code, in Obsidian, Logseq, Foam, or `less`. A dependency-free shell script verifies the links.

## Commands

| Command | What it does |
|---------|-------------|
| `/init-brain` | Interactive wizard. Creates the shared structure and the first product. |
| `/add-product` | Reads the product's code and any spec kept elsewhere, checks the docs against the code, interviews you about the rest, and generates its self-contained folder. |
| `/resume [product]` | Pulls the brain and the product's code if they are in git, loads context, shows progress, recommends what to work on. `/resume brain` picks up the last session that changed the brain itself. |
| `/wrap-up` | Captures session work, writes a handoff with the session's measured times (the brain's own in `company/handoffs/` when the session changed the brain itself), updates the execution plan, replaces the product's status, then commits what is left and pushes the brain. The only command that pushes. |
| `/status [product\|all]` | Portfolio dashboard across products, or a deep dive on one. |
| `/plan [product] <step>` | Breaks an execution plan step into concrete tasks. |
| `/sprint [product\|all]` | Plans a week of work with daily themes and effort estimates. |
| `/feature [product] <name>` | Full feature lifecycle: spec, plan, implement, update brain. |
| `/sync` | Audits brain health, runs the link and `CLAUDE.md` path checks, repairs what it can. |
| `/migrate <path>` | Imports a vault made with the original single-product layout. |

Commands that act on one product pick it from the argument, from the conversation so far, from the working directory when it is a product's code location, or automatically when only one exists. Otherwise they list the products and ask.

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
- Templates → `templates/`, those you don't have yet
- Three scripts → `scripts/`: the link checker, the `CLAUDE.md` path check, and the session clock
- `CLAUDE.md`, if none exists
- The version it installed → `.claude/brain-version`

Re-running the installer upgrades the commands and scripts, and merges what the templates changed into your templates and `CLAUDE.md`, keeping your own text.

### Versions

Each release has a version, `major.minor.patch`, a tag such as `v2.0.0`, and an entry in [CHANGELOG.md](CHANGELOG.md). *Major* means an existing brain needs more than a merge, *minor* that a command gains behaviour or a template changes, *patch* that nothing is asked of you. An entry that asks something of you says so under **Upgrade**. `main` is the latest release. To install an earlier one, `git checkout v2.0.0` before running the installer.

### Upgrading

Pull this repo and re-run `./install.sh /path/to/your/brain`. The commands and scripts are replaced, and the installer prints the new version over the one your brain had.

Your `CLAUDE.md` and templates hold your own text, so they are kept, and what the templates changed since the version in `.claude/brain-version` is merged into them. It is a three-way merge, as `git merge` does one, with the template of your brain's version as the base, so your text stays and the template's changes come in. The installer shows what each merge changed. In a brain kept in git, commit them like any other change.

Where you and the template changed the same lines, the installer can't choose. It leaves your file as it is and writes the merge beside it, as `CLAUDE.md.merge` for example, with each conflict between `<<<<<<<` and `>>>>>>>` lines. Resolve them, then move the file over yours. `/sync` reports the `.merge` file until you do, and offers to resolve it. Or ask Claude in the brain:

```
Resolve the conflicts in CLAUDE.md.merge: keep my organisation's text and take the template's new rules.
Show me the result, then move it over CLAUDE.md.
```

The merge needs your brain's version as a tag in this clone, so install from a git clone, not from a downloaded archive. Without the tag, or in a brain installed before 2.0.0, which has no `.claude/brain-version`, the installer keeps your files as they are and says so. The changelog entries after your version then say what to merge, and its *Installed Before 2.0.0?* lists the template changes by date. Merge them by hand, or ask Claude in the brain:

```
Compare CLAUDE.md with <this repo>/templates/CLAUDE.md, and templates/ with <this repo>/templates/.
Merge in what's new and keep my organisation's text. Show me the diff before saving.
```

Then run `/sync`.

### Create Your Brain

```bash
cd /path/to/your/brain
claude
```

Then type `/init-brain`. The wizard asks about your organisation, then about your first product, and generates real content for every file. Add more products any time with `/add-product`.

### Where to Put the Brain

**Its own repository** (recommended, especially with several products). The brain and each code base are then separate directories, and a session needs both: one is the working directory, the other is attached with `--add-dir`.

**On several machines.** Make the brain a git repository with a private remote, and clone it to the same path on every machine, so the *Brain* sections in your code repos hold everywhere. `/resume` then pulls the brain and the product's code repo before it reads, so a session on one machine starts from what another pushed. Each command that writes the brain commits the files it wrote, and `/wrap-up` commits the rest and pushes, once per session. No command stages another session's files or force-pushes; if two machines diverge, `/wrap-up` stops and asks. Keep credentials out of the brain even when the remote is private.

### How to Start a Session

**Product work: start in the code repo and attach the brain.**

```bash
cd ~/code/addon-manager
CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1 claude --add-dir ~/brain
```

Claude Code treats the working directory and an attached directory differently, and the code repo is the one that needs to be the working directory:

| | Loads from the working directory | Loads from an attached directory |
|---|---|---|
| Slash commands (`.claude/commands/`) | yes | yes |
| Hooks and permission rules (`.claude/settings.json`) | yes | no |
| `CLAUDE.md` | yes | only with `CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1` |

Started this way, the code repo's hooks, permission rules and `CLAUDE.md` all apply, the brain's commands are available, and the environment variable brings in the brain's `CLAUDE.md`. `/resume` with no argument picks the product whose code location is the working directory.

The commands find the brain on their own: every brain path is relative to the **brain root**, the directory holding `BRAIN-INDEX.md` and `products/`, wherever it is attached. `/add-product` also offers to add a short *Brain* section to the code repo, so a session finds the brain even without the environment variable. The section holds paths on your machine. If the repo is cloned anywhere the brain is not (it is public, or cloned on a server, another PC, or for an agent), the section goes into `CLAUDE.local.md`, which is added to `.gitignore`, so the paths are neither published nor pushed to the other clones. Only a private repo used on this one machine gets it in `CLAUDE.md`.

**A repo that tracks its own work.** If a repo already keeps `TODO.md`, `HANDOFF.md` or plan files, `/add-product` asks which place leads from now on, since two lists of open work drift apart. Usually the brain takes over. When something that cannot see the brain reads the repo's record, such as an agent working in a clone on another machine, the repo keeps leading: the product folder then holds the milestone, the priorities and short handoffs that point at the repo's resume point, and `/resume`, `/wrap-up` and `/feature` defer to the repo.

**A spec kept elsewhere.** A product may start as a document: a spec on a wiki, a design note, a page on a server in your network. `/add-product` asks for one even when there is code, reads it before the interview, and drafts its answers from it. Its open points become findings, and personal data in it, such as names and amounts, stays out of the brain. Then it asks where the requirements live from now on. Usually the brain takes over: each section is carried into the product folder, with a table of where it went, and the document is frozen with a note pointing to the brain. If people or an agent work from the document, it keeps leading and the brain holds the plan and the decisions.

**Portfolio work: start in the brain.** `/status all`, `/sprint all`, `/sync`, `/add-product`, `/migrate` and `/init-brain` need no code repo:

```bash
cd ~/brain
claude
```

**Shorter start command.** Add one shell alias per product so a session is one word away:

```bash
# bash / zsh (~/.bashrc or ~/.zshrc)
alias addons='cd ~/code/addon-manager && CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1 claude --add-dir ~/brain'
alias shop='cd ~/code/webshop && CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1 claude --add-dir ~/brain'
```

```fish
# fish (~/.config/fish/config.fish)
alias addons 'cd ~/code/addon-manager && env CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1 claude --add-dir ~/brain'
alias shop 'cd ~/code/webshop && env CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1 claude --add-dir ~/brain'
```

Then `addons` opens Claude in that product's code with the brain attached, and `/resume` is the first thing you type.

**Inside a code repository.** Run `./install.sh .` at the repo root. The brain files sit next to the code, and `claude` started from the root sees both. Use this for a single product whose code and brain should travel together.

## Daily Workflow

```
addons                  ← Shell alias: Claude starts in the code repo, brain attached
/resume                 ← Start of session: loads context, shows progress
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
  handoffs/                   Sessions that changed the brain itself, not a product

products/
  README.md                   Portfolio table: status, phase, last session, code location
  addon-manager/              One self-contained folder per product
    README.md                 Product index: description, code location, current status
    Execution-Plan.md         Phased roadmap with step statuses and task checklists
    Execution-Plan-Archive.md Finished phases, moved out whole, and status history
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
scripts/                      check-links.sh, check-claude-md.sh, session-times.sh
```

## Conventions

These are what make the brain navigable by both people and agents. `CLAUDE.md` carries them, and the two check scripts enforce the structural ones.

- **Relative markdown links only.** `[Architecture](engineering/Architecture.md)`, never `[[Architecture]]`. Paths are relative to the file that contains them.
- **Every file has a parent line.** The first line of every file except `BRAIN-INDEX.md` and `CLAUDE.md` is `> Part of [Parent](path.md)`.
- **Every folder has a `README.md`** that links to everything inside it. Forges render it when you browse the folder.
- **Products are self-contained.** Nothing in `products/a/` links into `products/b/`. Shared material goes in `company/`. A product folder can be archived or moved out without breaking anything.
- **Code is referenced, not linked.** `src/main.rs` in backticks. The code is not part of the brain.
- **Naming:** folders lowercase kebab-case, documents PascalCase with hyphens, handoffs and ADRs numbered per product.
- **Status is the present only.** A product's *Current Status*, its portfolio row and its index line are replaced at each `/wrap-up`, never appended to. A phase whose steps are all done moves whole to `Execution-Plan-Archive.md` and leaves one line in the plan. The handoffs are the record of each session.
- **Times are measured, never estimated.** A start, end or duration comes from `date` stamps written at the time, or from a recorded timestamp: a commit, a log line, the session transcript. `scripts/session-times.sh` reads a session's start, end and time inside Claude's turns from Claude Code's local transcript, and `/wrap-up` copies its line into the handoff. The transcript format isn't a public interface, so if the script finds nothing, the handoff says `not recorded`. It needs GNU `date`: on macOS, `brew install coreutils`.
- **A `CLAUDE.md` is a map,** the brain's and every code repo's: inline only the rules that hold on every action and the *Compact Instructions*, everything else a one-line pointer to the file that holds it, and no copied status or counts.

## Verifying the Brain

```bash
scripts/check-links.sh            # from the brain root
scripts/check-links.sh ~/brain    # or point it somewhere
```

It scans `BRAIN-INDEX.md`, `company/` and `products/` and reports broken links, leftover wikilinks, files without a parent line, orphans nothing links to, and cross-product links. It also reports a `CLAUDE.md.merge` or `templates/*.merge` that the installer left on a conflict. Fenced code blocks and inline code are skipped, so a file can show an example link. Exit code 1 on issues, so it works as a pre-commit hook or CI step for the brain repo. `/sync` and `/wrap-up` run it for you.

```bash
scripts/check-claude-md.sh        # from the brain root
```

It reads the files Claude Code loads as project memory (`CLAUDE.md`, `CLAUDE.local.md`, `.claude/CLAUDE.md`) in the brain and at every product's code location (the *Code* column of `products/README.md`), and reports each path in backticks that no longer exists, so a pointer doesn't outlive the file it points to. It also reports a symlinked file whose target is gone, a code location with none of the files, and one that isn't on this machine. Home and absolute paths are checked only in `CLAUDE.local.md`, the one file that holds paths on this machine, such as the brain root. Placeholders, commands, URLs, examples (after "for example" or "e.g." on their line) and git-ignored paths are skipped. `/sync` runs it.

## Migrating From obsidian-brain, 1.0.0

If you have a vault from the original single-product version, 1.0.0 (numbered `00_Company/` folders, wikilinks), install this into a new directory and run:

```
/migrate /path/to/old-vault
```

It copies the vault into `products/<slug>/`, renames folder indexes to `README.md`, converts every wikilink to a relative link, and registers the product. The old `00_Company/` vision and values become the product's own `Vision.md` and `Values.md`. The source vault is never modified.

A legacy vault usually sits inside the product's code repository, with `CLAUDE.md` and `.claude/commands` at the repository root symlinked into it. `/migrate` finds those and, after asking, moves the repository onto the brain:

- `CLAUDE.md` becomes a real file that keeps the project's own rules. The pointer to the brain goes into it, or into `CLAUDE.local.md` when the repo is public or cloned elsewhere
- product-specific slash commands move into the repository's own `.claude/commands/`
- hooks and permission rules stay where they are, since they load when a session starts in the repository
- per-project memory that mentions the old vault is updated

Nothing in the code repository is committed for you.

## Customization

The commands are markdown files in `.claude/commands/`. Edit them freely:

- Change the product folder layout in `add-product.md`
- Adjust the handoff format in `wrap-up.md` and `templates/Handoff-Template.md`
- Add departments (`design/`, `research/`) or remove ones you don't need
- Add organisation-wide rules to `CLAUDE.md`
- Add your own slash commands

If you add top-level brain folders beyond `company/` and `products/`, add them to the `SCAN` list in `scripts/check-links.sh`.

## Testing the Scripts

`tests/run.sh` runs a case for each thing the three scripts and the installer were built or fixed to do, and exits 1 if any output differs from the one recorded. CI runs it on Ubuntu and on macOS, with a Mac's own bash 3.2, for every pull request, and `shellcheck` over every shell file:

```bash
tests/run.sh                    # every case
tests/run.sh session-times      # one script's cases
tests/run.sh --update           # record the output again, then review it with git diff
```

A case is `tests/<script>/<case>.sh`, which builds a small brain, repo, transcript or copy of the tool in an empty temporary folder and runs the script on it, next to `<case>.expected`. Its first line says what it checks. The tests need only bash and what the scripts need, and `install.sh` doesn't copy them into the brain. When you change a script, add a case for the change. Run the script on a real brain too: a fixture holds only what someone thought of.

## Tips

- **Don't skip `/wrap-up`.** It is what makes `/resume` useful.
- **Run `/sync` weekly** to keep the link graph clean.
- **Version the brain with git.** Every session then has a diff you can read, and with a remote the brain follows you between machines (see *Where to Put the Brain*).
- **Use whatever viewer you like.** Obsidian's graph view, VS Code's markdown preview, or GitHub's file browser all work, because it's just markdown and relative links.
- **Pin the entry points** in your editor: `BRAIN-INDEX.md` and the product `README.md` you're working on.

## License

MIT. See [LICENSE](LICENSE). Clone it, fork it, change it, ship it; just keep the copyright notice.
