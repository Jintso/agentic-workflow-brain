#!/usr/bin/env bash
# check-links.sh — Verify the structural integrity of a brain.
#
# Scans BRAIN-INDEX.md, company/ and products/ (templates/ is skipped on purpose:
# it holds placeholder links) and reports:
#
#   BROKEN     a relative link whose target file does not exist
#   WIKILINK   a leftover [[wikilink]]; this brain uses standard markdown links
#   NO-PARENT  a file missing the "> Part of [...](...)" line
#   ORPHAN     a file that no other file links to
#   CROSS-PRODUCT  a link from one product's folder into another's
#
# Usage:
#   scripts/check-links.sh                 # from the brain root
#   scripts/check-links.sh /path/to/brain
#
# Exit status: 0 clean, 1 issues found, 2 no brain found.
# Needs only bash, find, grep, sed, sort.

set -u

ROOT="${1:-.}"
cd "$ROOT" || { echo "Cannot cd to $ROOT" >&2; exit 2; }

SCAN=()
[ -f BRAIN-INDEX.md ] && SCAN+=(BRAIN-INDEX.md)
[ -d company ]        && SCAN+=(company)
[ -d products ]       && SCAN+=(products)

if [ ${#SCAN[@]} -eq 0 ]; then
  echo "No brain found in $(pwd): expected BRAIN-INDEX.md, company/ or products/." >&2
  exit 2
fi

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

find "${SCAN[@]}" -type f -name '*.md' | sed 's#^\./##' | sort > "$TMP/files"
: > "$TMP/targets"
: > "$TMP/issues"

files=0
links=0
ROOT_ABS="$(pwd -P)"

while IFS= read -r f; do
  files=$((files + 1))
  dir="$(dirname "$f")"

  # --- links: every ](target) in the file, minus URLs, anchors and absolute paths
  grep -o '\]([^)]*)' "$f" 2>/dev/null | sed 's/^](//; s/)$//' | while IFS= read -r raw; do
    t="${raw%% *}"                 # drop an optional "title"
    t="${t#<}"; t="${t%>}"         # drop <angle brackets>
    t="${t%%#*}"                   # drop #anchor
    case "$t" in
      ''|http://*|https://*|mailto:*|/*) continue ;;
    esac
    printf '%s\n' "$t"
  done > "$TMP/cur"

  while IFS= read -r t; do
    links=$((links + 1))
    if [ -e "$dir/$t" ]; then
      abs="$(cd "$dir/$(dirname "$t")" && pwd -P)/$(basename "$t")"
      rel="${abs#"$ROOT_ABS"/}"
      printf '%s\n' "$rel" >> "$TMP/targets"
      # products/<a>/... linking into products/<b>/... breaks self-containment
      case "$f" in products/*/*)
        src_p="${f#products/}"; src_p="${src_p%%/*}"
        case "$rel" in products/*/*)
          dst_p="${rel#products/}"; dst_p="${dst_p%%/*}"
          [ "$src_p" != "$dst_p" ] && printf 'CROSS-PRODUCT  %s -> %s\n' "$f" "$t" >> "$TMP/issues"
        esac
      esac
    else
      printf 'BROKEN     %s -> %s\n' "$f" "$t" >> "$TMP/issues"
    fi
  done < "$TMP/cur"

  # --- leftover wikilinks
  n="$(grep -o '\[\[[^]]*\]\]' "$f" 2>/dev/null | wc -l | tr -d ' ')"
  if [ "$n" -gt 0 ]; then
    printf 'WIKILINK   %s (%s found)\n' "$f" "$n" >> "$TMP/issues"
  fi

  # --- parent line
  if [ "$f" != "BRAIN-INDEX.md" ] && ! grep -q '^> Part of \[' "$f"; then
    printf 'NO-PARENT  %s\n' "$f" >> "$TMP/issues"
  fi
done < "$TMP/files"

# --- orphans: markdown files nothing links to
sort -u "$TMP/targets" > "$TMP/targets.u"
while IFS= read -r f; do
  [ "$f" = "BRAIN-INDEX.md" ] && continue
  grep -Fxq "$f" "$TMP/targets.u" || printf 'ORPHAN     %s\n' "$f" >> "$TMP/issues"
done < "$TMP/files"

# --- report
issues="$(wc -l < "$TMP/issues" | tr -d ' ')"
echo "Brain link check: $files files, $links links"
if [ "$issues" -eq 0 ]; then
  echo "OK: no issues found."
  exit 0
fi
sort "$TMP/issues"
echo "$issues issue(s) found."
exit 1
