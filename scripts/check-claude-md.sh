#!/usr/bin/env bash
# check-claude-md.sh — Report the paths a CLAUDE.md names that no longer exist.
#
# A CLAUDE.md is a map (CLAUDE.md, Organisation-Wide Conventions), and a map's
# pointers rot when files move. This checks the brain's own CLAUDE.md and the
# CLAUDE.md and CLAUDE.local.md at every product's code location: a path in the
# Code column of products/README.md that starts with ~ or /, in backticks or bare
# (a URL or "not started" isn't a location on this machine). A repo may have
# either file or both: its Brain section goes into CLAUDE.local.md when a clone
# lives where the brain is not. Each backticked token outside a fenced block
# that looks like a path is checked:
#
#   repo path   its first part is a file or folder at the repo's root
#               (src/, docs/adr/README.md, .claude/agents/)
#   brain path  in a code repo's file, it starts with products/, company/
#               or templates/, and is checked against the brain root
#
# Skipped, as not checkable or not the repo's: home and absolute paths, URLs,
# tokens with spaces (commands), globs and placeholders (* < > … $ { ( ? #),
# bare file names, tokens whose first part isn't at the root (origin/main), and
# missing paths git ignores (build/, generated files).
#
# Usage:
#   scripts/check-claude-md.sh                 # from the brain root
#   scripts/check-claude-md.sh /path/to/brain
#
# Exit status: 0 clean, 1 missing paths found, 2 no brain found.
# Needs only bash, grep, sed, awk, git.

set -u

brain="${1:-.}"
brain="${brain%/}"
if [ ! -f "$brain/BRAIN-INDEX.md" ] || [ ! -d "$brain/products" ]; then
  echo "No brain at $brain (needs BRAIN-INDEX.md and products/)." >&2
  exit 2
fi

check() {  # $1 CLAUDE.md, $2 the root its paths are relative to, $3 "repo" or "brain"
  local file="$1" root="$2" kind="$3"
  awk '/^[[:space:]]*(```|~~~)/ { fenced = !fenced; next } !fenced { print NR "\t" $0 }' "$file" |
  while IFS=$'\t' read -r n line; do
    grep -o '`[^`]*`' <<<"$line" | sed 's/^`//; s/`$//' | while IFS= read -r tok; do
      case "$tok" in
        ''|*' '*|*'*'*|*'<'*|*'>'*|*'…'*|*'$'*|*'{'*|*'('*|*'?'*|*'#'*|*'://'*|'~'*|/*|-*) continue ;;
        */*) ;;
        *) continue ;;
      esac
      local path="${tok%/}" first="${tok%%/*}" base="$root"
      if [ -e "$root/$first" ]; then
        base="$root"
      elif [ "$kind" = repo ] && [[ "$tok" =~ ^(products|company|templates)/ ]]; then
        base="$brain"
      else
        continue
      fi
      [ -e "$base/$path" ] && continue
      git -C "$base" check-ignore -q -- "$path" 2>/dev/null && continue
      echo "MISSING  $file:$n  $tok"
    done
  done
}

out=$(
  check "$brain/CLAUDE.md" "$brain" brain
  grep -E '^\| \[' "$brain/products/README.md" | awk -F'|' '{ print $(NF-1) }' |
    while IFS= read -r cell; do
      if [[ "$cell" == *'`'* ]]; then
        grep -o '`[^`]*`' <<<"$cell" | tr -d '`'
      else
        sed 's/^[[:space:]]*//; s/[[:space:]]*$//' <<<"$cell"
      fi
    done | grep -E '^(~|/)' | sed "s|^~|$HOME|" | while IFS= read -r repo; do
      found=0
      for name in CLAUDE.md CLAUDE.local.md; do
        [ -f "$repo/$name" ] || continue
        check "$repo/$name" "$repo" repo
        found=1
      done
      [ "$found" -eq 1 ] || echo "NO-FILE  $repo: no CLAUDE.md or CLAUDE.local.md"
    done
)

if [ -n "$out" ]; then
  echo "$out"
  echo "CLAUDE.md path check: $(grep -c . <<<"$out") issue(s)."
  exit 1
fi
echo "CLAUDE.md path check: OK, every named path exists."
