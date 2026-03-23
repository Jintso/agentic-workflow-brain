# Obsidian Brain

Persistent project memory for Claude Code, stored as markdown files in your Obsidian vault. No cloud, no npm packages, no dependencies beyond Claude Code itself.

## What This Is

A set of 8 **Claude Code slash commands** that give Claude a structured "brain" inside your Obsidian vault. The brain persists across sessions through handoff documents — every session picks up exactly where the last one left off.

**The brain is just markdown files with wikilinks.** Obsidian gives you the visual interface (graph view, backlinks, search). Claude Code gives you the AI that reads, updates, and reasons about the brain.

## Commands

| Command | What it does |
|---------|-------------|
| `/init-brain` | Interactive wizard — creates 25-40 structured markdown files tailored to your project |
| `/resume` | Loads brain context, shows progress, recommends what to work on |
| `/wrap-up` | Captures session work, creates handoff doc, updates execution plan |
| `/status` | Full project dashboard — progress bars, blockers, health metrics |
| `/plan [step]` | Breaks an execution plan step into concrete tasks |
| `/sprint` | Plans a week of work with daily themes and effort estimates |
| `/sync` | Audits brain health — finds orphan files, broken links, stale content |
| `/feature [name]` | End-to-end feature lifecycle — spec, plan, implement, update brain |

## Setup

### Prerequisites

- **Claude Code** installed and authenticated ([setup guide](https://code.claude.com/docs/en/setup))
- **Obsidian** with an existing vault
- **Git** (to clone this repo and track your brain)

### Install

```bash
# Clone this repo
git clone https://github.com/YOUR_USERNAME/obsidian-brain.git

# Run the installer, pointing at your vault
cd obsidian-brain
chmod +x install.sh
./install.sh /path/to/your/obsidian-vault
```

This copies:
- 8 slash commands → `your-vault/.claude/commands/`
- Templates → `your-vault/Templates/`
- CLAUDE.md → `your-vault/CLAUDE.md` (if one doesn't exist)

### Create Your Brain

```bash
cd /path/to/your/obsidian-vault
claude
```

Then type:

```
/init-brain
```

The wizard asks about your project and generates the full brain structure. Watch the files appear in Obsidian in real time.

## Daily Workflow

```
/resume          ← Start of session (loads context, shows progress)
... work ...     ← Claude has full project context
/wrap-up         ← End of session (creates handoff for next time)
```

## Brain Structure

After `/init-brain`, your vault gains:

```
BRAIN-INDEX.md              ← Central hub linking everything
CLAUDE.md                   ← Claude's operating instructions
Execution-Plan.md           ← Phased roadmap with task checklists

00_Company/                 ← Vision, values, identity
01_Engineering/             ← Architecture, tech stack, conventions, ADRs
02_Product/                 ← MVP scope, features, user stories
03_Operations/              ← Environments, CI/CD, monitoring

Handoffs/                   ← Session continuity documents
Templates/                  ← Reusable templates
Assets/                     ← Images, PDFs, reference files
```

Every file is interconnected with `[[wikilinks]]`. Open Obsidian's graph view to see the knowledge graph.

## Customization

The commands are just markdown files in `.claude/commands/`. Edit them freely:

- Change the brain folder structure in `init-brain.md`
- Adjust the handoff format in `wrap-up.md`
- Add new departments or remove ones you don't need
- Modify the execution plan format
- Add your own slash commands

## Tips

- **Pin key files** in Obsidian: `BRAIN-INDEX.md` and `Execution-Plan.md`
- **Use graph view** — color-code folders to see departments at a glance
- **Run `/sync` weekly** to keep the brain healthy
- **Don't skip `/wrap-up`** — it's what makes `/resume` useful
- **Mobile access** — use Obsidian Sync or Syncthing to review your brain anywhere

## License

MIT — do whatever you want with it.
