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
#   scripts/check-links.sh  → <brain>/scripts/            always overwritten
#   templates/*.md          → <brain>/templates/          only files that don't exist yet
#   templates/CLAUDE.md     → <brain>/CLAUDE.md           only if missing
#
# Re-run it to upgrade the commands without touching your content.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BRAIN_DIR="${1:-.}"

mkdir -p "$BRAIN_DIR"
BRAIN_DIR="$(cd "$BRAIN_DIR" && pwd)"

echo "🧠 Agentic Workflow Brain — Installer"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Brain: $BRAIN_DIR"
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
cp "$SCRIPT_DIR/scripts/check-links.sh" "$BRAIN_DIR/scripts/"
chmod +x "$BRAIN_DIR/scripts/check-links.sh"
echo ""
echo "Scripts:"
echo "  ✅ scripts/check-links.sh"

# Templates (never overwrite the user's edits)
mkdir -p "$BRAIN_DIR/templates"
echo ""
echo "Templates:"
for tmpl_file in "$SCRIPT_DIR"/templates/*.md; do
    name="$(basename "$tmpl_file")"
    [ "$name" = "CLAUDE.md" ] && continue
    if [ -e "$BRAIN_DIR/templates/$name" ]; then
        echo "  ⏭  templates/$name (exists, kept)"
    else
        cp "$tmpl_file" "$BRAIN_DIR/templates/$name"
        echo "  ✅ templates/$name"
    fi
done

# CLAUDE.md
echo ""
if [ -f "$BRAIN_DIR/CLAUDE.md" ]; then
    echo "  ⏭  CLAUDE.md (exists, kept)"
else
    cp "$SCRIPT_DIR/templates/CLAUDE.md" "$BRAIN_DIR/CLAUDE.md"
    echo "  ✅ CLAUDE.md placed at the brain root; /init-brain fills in the placeholders"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Done. $INSTALLED commands installed."
echo ""
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
