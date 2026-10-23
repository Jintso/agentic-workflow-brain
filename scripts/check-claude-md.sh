#!/usr/bin/env bash
# check-claude-md.sh — Report the paths a CLAUDE.md names that no longer exist.
#
# A CLAUDE.md is a map (CLAUDE.md, Organisation-Wide Conventions), and a map's
# pointers rot when files move. This checks the files Claude Code loads as
# project memory, CLAUDE.md, CLAUDE.local.md and .claude/CLAUDE.md, in the brain
# and at every product's code location: a path in the Code column of
# products/README.md that starts with ~ or /, in backticks or bare (a URL or
# "not started" isn't a location on this machine). A repo may have any of them:
# its Brain section goes into CLAUDE.local.md when a clone lives where the brain
# is not. Each backticked token outside a fenced block that looks like a path is
# checked:
#
#   repo path   its first part is a file or folder at the repo's root
#               (src/, docs/adr/README.md, .claude/agents/)
#   brain path  in a code repo's file, it starts with products/, company/
#               or templates/, and is checked against the brain root. If the
#               repo has a folder of that name too, either place will do.
#   local path  in a CLAUDE.local.md, it starts with ~/ or /. That file holds
#               paths on this machine, such as the Brain section's brain root.
#
# Skipped, as not checkable or not the repo's: home and absolute paths in any
# other file (a committed file may name paths on other machines), URLs,
# tokens with spaces (commands), globs and placeholders (* < > … $ { ( ? #),
# bare file names, tokens whose first part isn't at the root (origin/main),
# examples (tokens after "for example" or "e.g." on their line), and missing
# paths git ignores (build/, generated files).
#
# Reports:
#
#   MISSING   a path one of the files names that doesn't exist
#   DANGLING  one of the files is a symlink whose target doesn't exist
#   NO-FILE   a code location with none of the files
#   NO-REPO   a code location that isn't a folder on this machine
#
# Usage:
#   scripts/check-claude-md.sh                 # from the brain root
#   scripts/check-claude-md.sh /path/to/brain
#
# Exit status: 0 clean, 1 issues found, 2 no brain found.
# Needs only bash, grep, sed, awk, git.

set -u

brain="${1:-.}"
brain="${brain%/}"
if [ ! -f "$brain/BRAIN-INDEX.md" ] || [ ! -d "$brain/products" ]; then
  echo "No brain at $brain (needs BRAIN-INDEX.md and products/)." >&2
  exit 2
fi

names=(CLAUDE.md CLAUDE.local.md .claude/CLAUDE.md)

check() {  # $1 CLAUDE.md, $2 the root its paths are relative to, $3 "repo" or "brain"
  local file="$1" root="$2" kind="$3"
  awk '/^[[:space:]]*(```|~~~)/ { fenced = !fenced; next }
       !fenced { sub(/([Ee]\.g\.|[Ff]or example).*/, ""); print NR "\t" $0 }' "$file" |
  while IFS=$'\t' read -r n line; do
    grep -o '`[^`]*`' <<<"$line" | sed 's/^`//; s/`$//' | while IFS= read -r tok; do
      case "$tok" in
        ''|*' '*|*'*'*|*'<'*|*'>'*|*'…'*|*'$'*|*'{'*|*'('*|*'?'*|*'#'*|*'://'*|-*) continue ;;
        */*) ;;
        *) continue ;;
      esac
      if [[ "$tok" == [~/]* ]]; then
        [ "${file##*/}" = CLAUDE.local.md ] && [[ "$tok" != '~'[!/]* ]] || continue
        [ -e "${tok/#\~\//$HOME/}" ] || echo "MISSING  $file:$n  $tok"
        continue
      fi
      local path="${tok%/}" first="${tok%%/*}" bases=() base
      [ -e "$root/$first" ] && bases+=("$root")
      [ "$kind" = repo ] && [[ "$tok" =~ ^(products|company|templates)/ ]] && bases+=("$brain")
      [ ${#bases[@]} -gt 0 ] || continue
      for base in "${bases[@]}"; do
        [ -e "$base/$path" ] && continue 2
        git -C "$base" check-ignore -q -- "$path" 2>/dev/null && continue 2
      done
      echo "MISSING  $file:$n  $tok"
    done
  done
}

check_dir() {  # $1 the brain or a code location, $2 "brain" or "repo"
  local dir="$1" kind="$2" name f found=0
  if [ ! -d "$dir" ]; then
    echo "NO-REPO  $dir: not a folder on this machine"
    return
  fi
  for name in "${names[@]}"; do
    f="$dir/$name"
    if [ -L "$f" ] && [ ! -e "$f" ]; then
      echo "DANGLING $f: symlink to $(readlink "$f"), which doesn't exist"
      found=1
    elif [ -f "$f" ]; then
      check "$f" "$dir" "$kind"
      found=1
    fi
  done
  [ "$found" -eq 1 ] || echo "NO-FILE  $dir: no CLAUDE.md, CLAUDE.local.md or .claude/CLAUDE.md"
}

out=$(
  check_dir "$brain" brain
  grep -E '^\| \[' "$brain/products/README.md" | awk -F'|' '{ print $(NF-1) }' |
    while IFS= read -r cell; do
      if [[ "$cell" == *'`'* ]]; then
        grep -o '`[^`]*`' <<<"$cell" | tr -d '`'
      else
        sed 's/^[[:space:]]*//; s/[[:space:]]*$//' <<<"$cell"
      fi
    done | grep -E '^(~|/)' | sed "s|^~|$HOME|" | while IFS= read -r repo; do
      check_dir "$repo" repo
    done
)

if [ -n "$out" ]; then
  echo "$out"
  echo "CLAUDE.md path check: $(grep -c . <<<"$out") issue(s)."
  exit 1
fi
echo "CLAUDE.md path check: OK, every named path exists."
