# /migrate — Import a Legacy Single-Product Vault

You are converting a brain made with the original `obsidian-brain` layout (numbered department folders at the root, `[[wikilinks]]`, one product per vault) into a product folder inside this brain.

## Input

`/migrate /path/to/old-vault` — the path is required. Ask for it if missing.

**Never modify the source vault.** Copy and transform; leave the original untouched so the user can compare.

## Step 1: Inspect the Source

Confirm the legacy layout is present: `BRAIN-INDEX.md`, `Execution-Plan.md`, `00_Company/`, `01_Engineering/`, `02_Product/`, `03_Operations/`, `Handoffs/`. Missing pieces are fine; note them.

Take the product name from the `BRAIN-INDEX.md` title and the one-line description under it. Propose a slug (lowercase kebab-case) and confirm it. It must not match an existing folder in `products/`.

## Step 2: Make Sure the Brain Exists

- **No `BRAIN-INDEX.md` here:** create the shared structure from Phase 2 of `.claude/commands/init-brain.md`. Use the old `00_Company/Vision.md` and `Values.md` as the source for `company/`. Ask for the organisation name.
- **Brain already exists:** ask whether to merge the old `00_Company/` content into `company/` or drop it. Product-specific vision belongs in the new product README, not in `company/`.

## Step 3: Map and Copy

| Old | New (`products/<slug>/`) |
|-----|--------------------------|
| `BRAIN-INDEX.md` | `README.md` — rewrite as a product index (see `/add-product` Phase 2) using its *Current Status* section |
| `CLAUDE.md` | not copied; move project-specific coding conventions into `engineering/Conventions.md` |
| `Execution-Plan.md` | `Execution-Plan.md` |
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
| `Templates/` | not copied; shared templates are already installed in `templates/` |
| `Assets/` | `assets/` |
| `.obsidian/` | not copied |

## Step 4: Convert Links

In every copied file:

1. `[[Name]]` → `[Name](relative/path/Name.md)`. Find `Name.md` in the new product tree and compute the path relative to the file containing the link. `[[Name|Alias]]` → `[Alias](...)`.
2. Folder-index names map to the new READMEs: `[[Engineering]]` → `engineering/README.md`, `[[Product]]` → the product `README.md`, `[[Operations]]` → `operations/README.md`, `[[Handoffs]]` → `handoffs/README.md`, `[[ADR]]` → `engineering/adr/README.md`, `[[BRAIN-INDEX]]` → the product `README.md`, `[[Company]]` → `../../company/README.md`.
3. `[[CLAUDE]]` → `../../CLAUDE.md`, or drop the link if it was only decorative.
4. `> Part of [[X]]` → `> Part of [X Title](path)` following the same mapping.
5. Links to templates (`[[Handoff-Template]]`) → `../../templates/Handoff-Template.md`.
6. Unresolvable links: replace with the plain name and list them in the report.

## Step 5: Register and Verify

1. Register the product as in `/add-product` Phase 3 (`products/README.md` row, `BRAIN-INDEX.md` bullet).
2. Run `scripts/check-links.sh` and fix everything it reports.
3. Report: files migrated, links converted, links that could not be resolved, and anything skipped.
4. Suggest `/resume <slug>`. Remind the user the source vault is untouched and can be deleted once they are happy.
