#!/usr/bin/env bash
# check-links.sh — Verify the structural integrity of a brain.
#
# Scans BRAIN-INDEX.md, company/ and products/ (templates/ is skipped on purpose:
# it holds placeholder links) and reports:
#
#   BROKEN     a relative link whose target file does not exist
#   ANCHOR     a link's #anchor that matches no heading in its target file
#   WIKILINK   a leftover [[wikilink]]; this brain uses standard markdown links
#   NO-PARENT  a file missing the "> Part of [...](...)" line
#   ORPHAN     a file that no other file links to
#   CROSS-PRODUCT  a link from one product's folder into another's
#   MERGE      a merge install.sh left unresolved, CLAUDE.md.merge or
#              templates/*.merge, with the conflicts still marked in it
#
# Fenced code blocks (``` or ~~~) and inline code spans are skipped, so a
# file can show an example link or wikilink. Indented code blocks are not
# recognised: fence an example instead. Anchors follow GitHub's slugs; a setext
# (underlined) heading gives no anchor: write it with #.
#
# Usage:
#   scripts/check-links.sh                 # from the brain root
#   scripts/check-links.sh /path/to/brain
#
# Exit status: 0 clean, 1 issues found, 2 no brain found.
# Needs only bash, find, grep, sed, awk, sort.

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
: > "$TMP/anchor_refs"

files=0
links=0
ROOT_ABS="$(pwd -P)"

# Print a markdown file with fenced code blocks blanked out. A fence closes on
# the same character it opened with, at least as long.
strip_fences() {
  awk '
    {
      line = $0
      if (fence == "") {
        if (match(line, /^ ? ? ?(```+|~~~+)/)) {
          f = substr(line, RSTART, RLENGTH); sub(/^ +/, "", f)
          fence = f; print ""; next
        }
      } else {
        t = line; sub(/^ +/, "", t)
        if (substr(t, 1, length(fence)) == fence && substr(t, 1, 1) == substr(fence, 1, 1)) {
          rest = substr(t, length(fence) + 1)
          gsub(substr(fence, 1, 1), "", rest)
          if (rest ~ /^[ \t]*$/) fence = ""
        }
        print ""; next
      }
      print line
    }
  ' "$1"
}

# The same, with inline code spans blanked out too.
strip_code() {
  strip_fences "$1" | awk '
    {
      gsub(/``([^`]|`[^`])*``/, "")
      gsub(/`[^`]*`/, "")
      print
    }
  '
}

# Print the anchor of every heading in a markdown file, as GitHub builds it:
# links reduced to their text, lowercase, everything but letters, digits,
# spaces, hyphens and underscores dropped, each space a hyphen, and -1, -2 ...
# added to a repeated heading.
heading_slugs() {
  strip_fences "$1" | awk '
    /^ ? ? ?#+([ \t]|$)/ {
      s = $0
      sub(/^ */, "", s)
      match(s, /^#+/)
      if (RLENGTH > 6) next
      s = substr(s, RLENGTH + 1)
      sub(/^[ \t]+/, "", s)
      sub(/[ \t]+#+[ \t]*$/, "", s)
      sub(/[ \t]+$/, "", s)
      while (match(s, /\[[^]]*\]\([^)]*\)/)) {
        m = substr(s, RSTART, RLENGTH)
        sub(/\]\(.*$/, "", m)
        s = substr(s, 1, RSTART - 1) substr(m, 2) substr(s, RSTART + RLENGTH)
      }
      s = tolower(s)
      gsub(/[^[:alnum:] _-]/, "", s)
      gsub(/ /, "-", s)
      n = seen[s]++
      print (n ? s "-" n : s)
    }
  '
}

while IFS= read -r f; do
  files=$((files + 1))
  dir="$(dirname "$f")"
  strip_code "$f" > "$TMP/body"

  # --- links: every ](target) outside code, minus URLs and absolute paths
  grep -o '\]([^)]*)' "$TMP/body" 2>/dev/null | sed 's/^](//; s/)$//' | while IFS= read -r raw; do
    t="${raw%% *}"                 # drop an optional "title"
    t="${t#<}"; t="${t%>}"         # drop <angle brackets>
    case "$t" in
      ''|http://*|https://*|mailto:*|/*) continue ;;
    esac
    case "$t" in
      *'#'*) printf '%s|%s\n' "${t%%#*}" "${t#*#}" ;;  # path|anchor; path empty: this file
      *)     printf '%s|\n' "$t" ;;
    esac
  done > "$TMP/cur"

  while IFS='|' read -r t a; do
    if [ -z "$t" ]; then
      [ -n "$a" ] && printf '%s\t%s\t%s\t%s\n' "$f" "$f" "$a" "#$a" >> "$TMP/anchor_refs"
      continue
    fi
    links=$((links + 1))
    if [ -e "$dir/$t" ]; then
      abs="$(cd "$dir/$(dirname "$t")" && pwd -P)/$(basename "$t")"
      rel="${abs#"$ROOT_ABS"/}"
      printf '%s\n' "$rel" >> "$TMP/targets"
      case "$rel" in *.md)
        [ -n "$a" ] && printf '%s\t%s\t%s\t%s\n' "$f" "$rel" "$a" "$t#$a" >> "$TMP/anchor_refs"
      esac
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

  # --- leftover wikilinks outside code
  n="$(grep -o '\[\[[^]]*\]\]' "$TMP/body" 2>/dev/null | wc -l | tr -d ' ')"
  if [ "$n" -gt 0 ]; then
    printf 'WIKILINK   %s (%s found)\n' "$f" "$n" >> "$TMP/issues"
  fi

  # --- parent line
  if [ "$f" != "BRAIN-INDEX.md" ] && ! grep -q '^> Part of \[' "$TMP/body"; then
    printf 'NO-PARENT  %s\n' "$f" >> "$TMP/issues"
  fi
done < "$TMP/files"

# --- anchors: each one must match a heading in its target file
anchors="$(wc -l < "$TMP/anchor_refs" | tr -d ' ')"
cut -f2 "$TMP/anchor_refs" | sort -u | while IFS= read -r target; do
  heading_slugs "$target" | awk -v t="$target" '{ print t "\t" $0 }'
done > "$TMP/slugs"
awk -F'\t' '
  NR == FNR { have[$1 FS $2] = 1; next }
  !(($2 FS $3) in have) { printf "ANCHOR     %s -> %s\n", $1, $4 }
' "$TMP/slugs" "$TMP/anchor_refs" >> "$TMP/issues"

# --- orphans: markdown files nothing links to
sort -u "$TMP/targets" > "$TMP/targets.u"
while IFS= read -r f; do
  [ "$f" = "BRAIN-INDEX.md" ] && continue
  grep -Fxq "$f" "$TMP/targets.u" || printf 'ORPHAN     %s\n' "$f" >> "$TMP/issues"
done < "$TMP/files"

# --- merges the installer left beside CLAUDE.md or a template, on a conflict
for m in CLAUDE.md.merge templates/*.merge; do
  [ -f "$m" ] || continue
  n="$(grep -c '^<<<<<<< ' "$m")"
  case "$n" in
    0) printf 'MERGE      %s (no conflicts left: move it over %s)\n' "$m" "${m%.merge}" ;;
    1) printf 'MERGE      %s (1 conflict to resolve)\n' "$m" ;;
    *) printf 'MERGE      %s (%s conflicts to resolve)\n' "$m" "$n" ;;
  esac >> "$TMP/issues"
done

# --- report
issues="$(wc -l < "$TMP/issues" | tr -d ' ')"
echo "Brain link check: $files files, $links links, $anchors anchors"
if [ "$issues" -eq 0 ]; then
  echo "OK: no issues found."
  exit 0
fi
sort "$TMP/issues"
echo "$issues issue(s) found."
exit 1
