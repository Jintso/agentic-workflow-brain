# /migrate — Import a Legacy Single-Product Vault

You are converting a brain made with the original `obsidian-brain` layout (numbered department folders at the root, `[[wikilinks]]`, one product per vault) into a product folder inside this brain. When the vault sits inside a code repository, you also move that repository's Claude Code entry points off the vault, so sessions started there use this brain.

## Brain Root

Every brain path in this command is relative to the **brain root**, not to the working directory. The brain root is the directory that holds both `BRAIN-INDEX.md` and `products/`, or, if the brain has not been initialised yet, the one the installer ran against (it holds `templates/` and `scripts/check-links.sh`). It is either the working directory or one attached with `--add-dir`. The old vault is never the brain root, even though it has a `BRAIN-INDEX.md` of its own. Run the link checker as `<brain root>/scripts/check-links.sh <brain root>`.

## Input

`/migrate /path/to/old-vault` — the path is required. Ask for it if missing.

**Never modify the source vault.** Copy and transform; leave the original untouched so the user can compare. Files in the code repository that lie outside the vault change only in Step 5, and only after the user agrees.

## Step 1: Inspect the Source

### The vault

Confirm the legacy layout is present: `BRAIN-INDEX.md`, `Execution-Plan.md`, `00_Company/`, `01_Engineering/`, `02_Product/`, `03_Operations/`, `Handoffs/`. Missing pieces are fine; note them.

Take the product name from the `BRAIN-INDEX.md` title and the one-line description under it. Propose a slug (lowercase kebab-case) and confirm it. It must not match an existing folder in `products/`.

### The code repository

A legacy vault usually sits inside the product's code repository, often as `brain/`. Check whether the vault's parent directory is one: a `.git` folder, source files, a build manifest. If it is, that directory is the product's **code location**. Inspect it before copying anything:

1. **Symlinks into the vault.** List the repository root and its `.claude/` folder with `ls -la`. A listing of regular files hides symlinks, and legacy setups rely on them. Note every entry that resolves into the vault. The usual two are `CLAUDE.md` and `.claude/commands`.
2. **Product-specific commands.** In the vault's `.claude/commands/`, a command is product-specific when the brain root's `.claude/commands/` has no command of that name. The rest are old brain commands, which the brain's own replace.
3. **Hooks and permission rules.** Note where `.claude/settings.json` and `.claude/settings.local.json` live, and any hook whose command uses a path inside the vault.
4. **Per-project memory.** Claude Code keeps memory per working directory under `~/.claude/projects/`, in a folder named after the code location with every `/` replaced by `-`, the leading one included: `/home/me/code/app` → `~/.claude/projects/-home-me-code-app/memory/`. Note memory files that mention vault paths, wikilinks or the old command locations. If the session is not allowed to read that folder, say so in the report and give the user the path to check.
5. **Public or private, and other clones.** As in `/add-product` Phase 1, *Inspect the Code Location*, item 4. Step 5 decides from this where the *Brain* section goes.
6. **The clone against its remote, and the vault against the code.** Compare the clone with its remote first, as `/add-product` Phase 1 does, and never pull without a yes. The vault describes the product as it was when it was last updated: check its claims about commands, file names, versions and features against the code, as in `/add-product` item 2, and record the mismatches as findings in the new `Feature-Priorities.md`. Nothing in the copied files is corrected silently.

If the vault stands alone, skip this part and Step 5.

## Step 2: Make Sure the Brain Exists

The old `00_Company/` folder describes one product, not an organisation with several. Its content goes into the product folder in Step 3, whichever case applies here.

- **No `BRAIN-INDEX.md` at the brain root:** ask questions 1–3 of the organisation interview in `.claude/commands/init-brain.md` (Phase 1), then create the shared structure from its Phase 2. If the organisation builds only this product, offer the old `Vision.md` and `Values.md` as the starting text for `company/`.
- **Brain already exists:** leave `company/` as it is.

## Step 3: Map and Copy

| Old | New (`products/<slug>/`) |
|-----|--------------------------|
| `BRAIN-INDEX.md` | `README.md` — rewrite as a product index (see `/add-product` Phase 2) using its *Current Status* section. `**Code:**` is the code location from Step 1, and *Latest commit* the commit Step 1 read |
| `CLAUDE.md` | not copied; copy its project-specific rules (coding conventions, packaging, design, workflow) into `engineering/Conventions.md`. Step 5 handles the code repository's own `CLAUDE.md` |
| `Execution-Plan.md` | `Execution-Plan.md` |
| `00_Company/Company.md` | not copied; fold its overview into `README.md` |
| `00_Company/Vision.md`, `Values.md` | same names at the product root, listed under *Quick Links* in `README.md` |
| `01_Engineering/Engineering.md` | `engineering/README.md` |
| `01_Engineering/*.md` | `engineering/*.md` |
| `01_Engineering/ADR/ADR.md` | `engineering/adr/README.md` |
| `01_Engineering/ADR/*.md` | `engineering/adr/*.md` |
| `02_Product/Product.md` | not copied; fold its description into `README.md` |
| `02_Product/MVP-Scope.md`, `Feature-Priorities.md`, `User-Stories.md` | same names at the product root |
| `02_Product/Feature-*.md` | `features/Feature-*.md`, indexed in a new `features/README.md` |
| `03_Operations/Operations.md` | `operations/README.md` |
| `03_Operations/*.md` | `operations/*.md` |
| `Handoffs/Handoffs.md` | `handoffs/README.md` |
| `Handoffs/*.md` | `handoffs/*.md` |
| `.claude/commands/` | not copied; Step 5 handles the product-specific ones |
| `Templates/` | not copied; shared templates are already installed in `templates/` |
| `Assets/` | `assets/` |
| `.obsidian/` | not copied |

## Step 4: Convert Links

In every copied file, outside code spans and fenced code blocks:

1. `[[Name]]` → `[Name](relative/path/Name.md)`. Find `Name.md` in the new product tree and compute the path relative to the file containing the link. `[[Name|Alias]]` → `[Alias](...)`.
2. Folder-index names map to the new READMEs: `[[Engineering]]` → `engineering/README.md`, `[[Operations]]` → `operations/README.md`, `[[Handoffs]]` → `handoffs/README.md`, `[[ADR]]` → `engineering/adr/README.md`. `[[BRAIN-INDEX]]`, `[[Product]]` and `[[Company]]` → the product `README.md`, which now holds their content.
3. `[[CLAUDE]]` → `../../CLAUDE.md`, or drop the link if it was only decorative.
4. **Parent lines follow the file's new location, not its old link.** A file at the product root points to the product `README.md`; a file in a folder points to that folder's `README.md`; a folder `README.md` points to the product `README.md`; `engineering/adr/README.md` points to `engineering/README.md`; `engineering/Plan-*.md` points to `../Execution-Plan.md`.
5. Links to templates (`[[Handoff-Template]]`) → the file in `templates/` at the brain root.
6. Unresolvable links: replace with the plain name and list them in the report.

## Step 5: Move the Code Repository Onto the Brain

Product sessions start in the code repository with the brain attached (see *Code Location* in `CLAUDE.md`). Whatever Claude Code loads there must point at this brain, not at the vault.

Show the user what Step 1 found and what you propose for each item below. **Ask before changing anything in the code repository.** Do not commit; tell the user what is left to commit.

1. **`CLAUDE.md`.** If the repository's root `CLAUDE.md` is a symlink into the vault, or carries the vault's session protocol, replace it with a real file:
   - **Keep** the project facts and every project-specific rule.
   - **Drop** the old session protocol and the wikilink and vault-layout rules.
   - **Add** one line saying the vault folder is a legacy vault, superseded on today's date, that is not to be read for session context or written to.
   - **Add** the *Brain* section from `/add-product` Phase 3, step 4, to the file its table chooses. It holds absolute paths on this machine: if any clone lives where this brain is not, including a public repository, it goes into `CLAUDE.local.md` with an entry in `.gitignore`, and the committed `CLAUDE.md` gets no local path. Recommend one and say why.
2. **Product-specific commands.** They belong in the code repository's `.claude/commands/` as real files, so they load when a session starts there. If that path is a symlink into the vault, replace the symlink with a real folder holding only the product-specific commands. Fix paths inside them that point into the vault. If there is no code repository, put them in `.claude/commands/<slug>/` at the brain root, which makes them `/<slug>:<name>`.
3. **Hooks and permission rules.** Leave settings files that already sit in the code repository's own `.claude/` where they are: they load when a session starts there. If they sit inside the vault, or a hook uses a path inside the vault, propose the corrected version.
4. **Per-project memory.** It keeps loading in sessions started in the code repository. Propose edits to the files noted in Step 1 so they name the new locations. They lie outside both directories, so the user has to approve each edit.

**Replacing a symlink:** remove the link itself (`rm path`, no trailing slash), then create the real file or folder. Never write through it: that changes the vault. Check with `ls -la` first. Claude Code asks before any change under a repository's `.claude/` folder. If that is refused, give the user the exact commands to run with `!`.

## Step 6: Register and Verify

1. Register the product as in `/add-product` Phase 3, steps 1–3: the `products/README.md` row, the `BRAIN-INDEX.md` bullet, and `company/Vision.md` if it lists products. Step 5 above replaces its step 4.
2. Run the link checker and fix everything it reports.
3. Report:
   - files migrated, links converted, links that could not be resolved, and anything skipped
   - what changed in the code repository, what was left as found, and what the user still has to commit
   - memory files updated, or proposed and declined
4. Give the start command for product work, as in `/add-product` Phase 4, and suggest `/resume <slug>`. Remind the user the source vault is untouched and can be deleted once they are happy.
