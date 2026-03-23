#!/usr/bin/env bash
set -euo pipefail

# install.sh — Install brain commands into an Obsidian vault
#
# Usage:
#   ./install.sh /path/to/your/obsidian-vault
#   ./install.sh  (uses current directory)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAULT_DIR="${1:-.}"

# Resolve to absolute path
VAULT_DIR="$(cd "$VAULT_DIR" && pwd)"

echo "🧠 Obsidian Brain — Command Installer"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Vault: $VAULT_DIR"
echo ""

# Check vault looks like an Obsidian vault
if [ ! -d "$VAULT_DIR/.obsidian" ]; then
    echo "⚠️  Warning: No .obsidian/ folder found in $VAULT_DIR"
    echo "   This might not be an Obsidian vault."
    read -rp "   Continue anyway? (y/N) " confirm
    if [[ "$confirm" != [yY] ]]; then
        echo "Aborted."
        exit 1
    fi
fi

# Create .claude/commands directory in the vault
COMMANDS_DIR="$VAULT_DIR/.claude/commands"
mkdir -p "$COMMANDS_DIR"

# Copy command files
echo "Installing slash commands..."
COMMANDS_SRC="$SCRIPT_DIR/.claude/commands"
INSTALLED=0

for cmd_file in "$COMMANDS_SRC"/*.md; do
    if [ -f "$cmd_file" ]; then
        filename="$(basename "$cmd_file")"
        cp "$cmd_file" "$COMMANDS_DIR/$filename"
        echo "  ✅ /$(basename "$filename" .md)"
        ((INSTALLED++))
    fi
done

# Copy templates
TEMPLATES_DIR="$VAULT_DIR/Templates"
if [ ! -d "$TEMPLATES_DIR" ]; then
    mkdir -p "$TEMPLATES_DIR"
    echo ""
    echo "Installing templates..."
    for tmpl_file in "$SCRIPT_DIR/templates/"*Template*.md; do
        if [ -f "$tmpl_file" ]; then
            cp "$tmpl_file" "$TEMPLATES_DIR/"
            echo "  ✅ $(basename "$tmpl_file")"
        fi
    done
fi

# Copy CLAUDE.md template if none exists
if [ ! -f "$VAULT_DIR/CLAUDE.md" ]; then
    cp "$SCRIPT_DIR/templates/CLAUDE.md" "$VAULT_DIR/CLAUDE.md"
    echo ""
    echo "  ✅ CLAUDE.md template placed at vault root"
    echo "     (Edit this file to match your project)"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Done! $INSTALLED commands installed."
echo ""
echo "Next steps:"
echo "  1. cd $VAULT_DIR"
echo "  2. claude"
echo "  3. /init-brain"
echo ""
echo "This will start the interactive wizard to create your brain."
echo "Browse the results in Obsidian's graph view."
