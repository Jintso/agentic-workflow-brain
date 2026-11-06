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
#   templates/*.md          → <brain>/templates/          if missing, else merged (below)
#   templates/CLAUDE.md     → <brain>/CLAUDE.md           if missing, else merged (below)
#   VERSION                 → <brain>/.claude/brain-version  always: the version installed
#
# Re-run it to upgrade. The commands and scripts are replaced. A CLAUDE.md or
# template the brain has holds your own text, so it is kept, and what the
# template changed since the version recorded in the brain is merged into it:
# three ways, with git merge-file, and that version's template, from its tag in
# this clone, as the base. A clean merge is written. A conflict leaves the file
# as it is and writes the merge, its conflicts marked, to <file>.merge beside it.
# With no record or no tag there is no base, and the installer says when a kept
# file differs from the one it ships. See README.md, Upgrading, and CHANGELOG.md.

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

# Templates and CLAUDE.md hold the user's own text: one the brain has is kept, and
# the template's changes since the recorded version are merged into it. The base
# is that version's tag in this clone; without it, nothing can be merged.
BASE=""
if [ -n "$PREVIOUS" ] && git -C "$SCRIPT_DIR" rev-parse -q --verify "refs/tags/v$PREVIOUS" >/dev/null 2>&1; then
    BASE="v$PREVIOUS"
fi
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
: > "$WORK/merged"
: > "$WORK/conflicts"
KEPT=0  # a kept file differs from the shipped one, with no base to merge them

keep() {  # $1 the shipped template, $2 its path in the tool, $3 the brain's copy, relative to the brain
    local shipped="$1" path="$2" name="$3" mine="$BRAIN_DIR/$3" n=0 lines
    if cmp -s "$shipped" "$mine"; then
        echo "  ⏭  $name (exists, kept)"
        return
    fi
    if [ -z "$BASE" ]; then
        echo "  ⏭  $name (exists, kept)"
        KEPT=1
        return
    fi
    # The template at the base; empty if the tool didn't ship it then
    git -C "$SCRIPT_DIR" show "$BASE:$path" > "$WORK/base" 2>/dev/null || : > "$WORK/base"
    if cmp -s "$WORK/base" "$shipped"; then  # the template hasn't changed since
        echo "  ⏭  $name (exists, kept)"
        return
    fi
    git merge-file -p -L "$name" -L "template $PREVIOUS" -L "template $VERSION" \
        "$mine" "$WORK/base" "$shipped" > "$WORK/out" 2>/dev/null || n=$?
    if [ "$n" -eq 0 ] && cmp -s "$WORK/out" "$mine"; then
        echo "  ⏭  $name (exists, has the changes since $PREVIOUS)"
    elif [ "$n" -eq 0 ]; then
        diff -u --label "$name, before" --label "$name, merged" "$mine" "$WORK/out" >> "$WORK/merged" || true
        cat "$WORK/out" > "$mine"
        echo "  🔀 $name (exists, merged the changes since $PREVIOUS)"
    elif [ "$n" -lt 128 ]; then  # n conflicts; git merge-file exits negative on an error
        cp "$WORK/out" "$mine.merge"
        lines="$(grep -n '^<<<<<<< ' "$mine.merge" | cut -d: -f1 | paste -s -d, - | sed 's/,/, /g')"
        if [ "$n" -eq 1 ]; then
            echo "  $name.merge: 1 conflict, at line $lines" >> "$WORK/conflicts"
        else
            echo "  $name.merge: $n conflicts, at lines $lines" >> "$WORK/conflicts"
        fi
        echo "  ⚠️  $name (exists, kept: the merge has conflicts, in $name.merge)"
    else
        echo "  ⏭  $name (exists, kept: the merge failed)"
        KEPT=1
    fi
}

mkdir -p "$BRAIN_DIR/templates"
echo ""
echo "Templates:"
for tmpl_file in "$SCRIPT_DIR"/templates/*.md; do
    name="$(basename "$tmpl_file")"
    [ "$name" = "CLAUDE.md" ] && continue
    if [ -e "$BRAIN_DIR/templates/$name" ]; then
        keep "$tmpl_file" "templates/$name" "templates/$name"
    else
        cp "$tmpl_file" "$BRAIN_DIR/templates/$name"
        echo "  ✅ templates/$name"
    fi
done

# CLAUDE.md
echo ""
if [ -f "$BRAIN_DIR/CLAUDE.md" ]; then
    keep "$SCRIPT_DIR/templates/CLAUDE.md" templates/CLAUDE.md CLAUDE.md
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

# What the merges did
if [ -s "$WORK/merged" ]; then
    echo "Upgrading from $PREVIOUS: the templates changed since, and their changes were"
    echo "merged into your copies:"
    echo ""
    cat "$WORK/merged"
    echo ""
fi
if [ -s "$WORK/conflicts" ]; then
    echo "Upgrading from $PREVIOUS: you and the template changed the same lines, so your"
    echo "copy was kept as it is, and the merge waits beside it with the conflicts marked:"
    cat "$WORK/conflicts"
    echo "Resolve each between its <<<<<<< and >>>>>>> lines, then move the file over"
    echo "yours, without .merge. Or ask Claude in the brain to do both: /sync reports"
    echo "the file until then."
    echo "What each release asks of you: $SCRIPT_DIR/CHANGELOG.md"
    echo ""
fi

# A kept file differs from the shipped one, and there was no base to merge with
if [ "$KEPT" -eq 1 ]; then
    if [ -n "$BASE" ]; then
        echo "Upgrading from $PREVIOUS: a merge failed, so your CLAUDE.md and templates"
        echo "were kept, and may lack what's new. To see it:"
        echo "  git -C \"$SCRIPT_DIR\" diff $BASE -- templates/"
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
