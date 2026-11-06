#!/usr/bin/env bash
set -euo pipefail

# install.sh — Install Agentic Workflow Brain into a directory
#
# Usage:
#   ./install.sh /path/to/brain     # that directory becomes the brain root (created if missing)
#   ./install.sh                    # current directory
#
# Copies:
#   .claude/commands/*.md   → <brain>/.claude/commands/   always overwritten (these are the tool)
#   scripts/*.sh            → <brain>/scripts/            always overwritten
#   templates/*.md          → <brain>/templates/          only files that don't exist yet
#   templates/CLAUDE.md     → <brain>/CLAUDE.md           only if missing
#   VERSION                 → <brain>/.claude/brain-version  always: the version installed
#
# Re-run it to upgrade the commands and scripts without touching your content.
# A kept CLAUDE.md or template may lack what the new commands expect. The
# installer says so when the templates changed since the version recorded in
# the brain; it compares them with git, from that version's tag in this clone.
# With no record or no tag, it says so whenever a kept file differs from the
# one it ships. See README.md, Upgrading, and CHANGELOG.md.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BRAIN_DIR="${1:-.}"

if [ ! -f "$SCRIPT_DIR/VERSION" ]; then
    echo "No VERSION file in $SCRIPT_DIR: this copy of the tool is incomplete." >&2
    exit 1
fi
VERSION="$(cat "$SCRIPT_DIR/VERSION")"

mkdir -p "$BRAIN_DIR"
BRAIN_DIR="$(cd "$BRAIN_DIR" && pwd)"
RECORD="$BRAIN_DIR/.claude/brain-version"
PREVIOUS=""
if [ -f "$RECORD" ]; then PREVIOUS="$(cat "$RECORD")"; fi

echo "🧠 Agentic Workflow Brain — Installer"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Brain:   $BRAIN_DIR"
if [ -n "$PREVIOUS" ]; then
    echo "Version: $VERSION, over $PREVIOUS"
else
    echo "Version: $VERSION"
fi
echo ""

# Commands
COMMANDS_DIR="$BRAIN_DIR/.claude/commands"
mkdir -p "$COMMANDS_DIR"
echo "Slash commands:"
INSTALLED=0
for cmd_file in "$SCRIPT_DIR"/.claude/commands/*.md; do
    cp "$cmd_file" "$COMMANDS_DIR/"
    echo "  ✅ /$(basename "$cmd_file" .md)"
    INSTALLED=$((INSTALLED + 1))
done

# Scripts
mkdir -p "$BRAIN_DIR/scripts"
echo ""
echo "Scripts:"
for script_file in "$SCRIPT_DIR"/scripts/*.sh; do
    cp "$script_file" "$BRAIN_DIR/scripts/"
    chmod +x "$BRAIN_DIR/scripts/$(basename "$script_file")"
    echo "  ✅ scripts/$(basename "$script_file")"
done

# Templates (never overwrite the user's edits)
KEPT=0
mkdir -p "$BRAIN_DIR/templates"
echo ""
echo "Templates:"
for tmpl_file in "$SCRIPT_DIR"/templates/*.md; do
    name="$(basename "$tmpl_file")"
    [ "$name" = "CLAUDE.md" ] && continue
    if [ -e "$BRAIN_DIR/templates/$name" ]; then
        echo "  ⏭  templates/$name (exists, kept)"
        cmp -s "$tmpl_file" "$BRAIN_DIR/templates/$name" || KEPT=1
    else
        cp "$tmpl_file" "$BRAIN_DIR/templates/$name"
        echo "  ✅ templates/$name"
    fi
done

# CLAUDE.md
echo ""
if [ -f "$BRAIN_DIR/CLAUDE.md" ]; then
    echo "  ⏭  CLAUDE.md (exists, kept)"
    cmp -s "$SCRIPT_DIR/templates/CLAUDE.md" "$BRAIN_DIR/CLAUDE.md" || KEPT=1
else
    cp "$SCRIPT_DIR/templates/CLAUDE.md" "$BRAIN_DIR/CLAUDE.md"
    echo "  ✅ CLAUDE.md placed at the brain root; /init-brain fills in the placeholders"
fi

# The version this brain now has, for the next upgrade to compare with
printf '%s\n' "$VERSION" > "$RECORD"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Done. $INSTALLED commands installed, version $VERSION recorded in .claude/brain-version."
echo ""

# Did the templates change since the version this brain had? Only git can tell,
# from that version's tag in this clone. A git error counts as a change.
CHANGED=unknown
if [ -n "$PREVIOUS" ] && git -C "$SCRIPT_DIR" rev-parse -q --verify "refs/tags/v$PREVIOUS" >/dev/null 2>&1; then
    if git -C "$SCRIPT_DIR" diff --quiet "v$PREVIOUS" -- templates/ 2>/dev/null; then
        CHANGED=no
    else
        CHANGED=yes
    fi
fi
if [ "$KEPT" -eq 1 ] && [ "$CHANGED" != no ]; then
    if [ "$CHANGED" = yes ]; then
        echo "Upgrading from $PREVIOUS: the templates changed since. Your CLAUDE.md and"
        echo "templates were kept, so merge what's new. To see it:"
        echo "  git -C \"$SCRIPT_DIR\" diff v$PREVIOUS -- templates/"
    elif [ -n "$PREVIOUS" ]; then
        echo "Upgrading from $PREVIOUS: this copy of the tool has no tag v$PREVIOUS to compare"
        echo "the templates with, so they may have changed. Your CLAUDE.md and templates"
        echo "were kept: merge what the releases since $PREVIOUS ask for."
    else
        echo "Upgrading? Your CLAUDE.md and templates were kept, and the new commands may"
        echo "cite sections they lack. This brain had no version recorded: if it was"
        echo "installed before 2.0.0, see Installed Before 2.0.0? in the changelog."
    fi
    echo "What each release asks of you: $SCRIPT_DIR/CHANGELOG.md"
    echo "How to merge: Upgrading in $SCRIPT_DIR/README.md"
    echo ""
fi
echo "Next steps:"
echo "  cd $BRAIN_DIR"
echo "  claude"
echo "  /init-brain          # new brain"
echo "  /migrate <old-vault> # or import an obsidian-brain vault"
echo ""
if [ ! -d "$BRAIN_DIR/.git" ]; then
    echo "Tip: version the brain with git so every session's changes are tracked:"
    echo "  git -C \"$BRAIN_DIR\" init"
fi
