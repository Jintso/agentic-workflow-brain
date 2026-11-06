# VERSION is major.minor.patch, the newest entry in CHANGELOG.md is that version, and every entry's heading has a date.
repo="$SCRIPTS/.."
v=$(cat "$repo/VERSION")
case "$v" in
  [0-9]*.[0-9]*.[0-9]*) echo "VERSION is major.minor.patch" ;;
  *) echo "VERSION is not major.minor.patch: $v" ;;
esac
newest=$(grep -m 1 -E '^## [0-9]+\.[0-9]+\.[0-9]+ ' "$repo/CHANGELOG.md" | cut -d' ' -f2)
if [ "$newest" = "$v" ]; then echo "the newest entry in CHANGELOG.md is VERSION"; else echo "CHANGELOG.md's newest entry is $newest, VERSION is $v"; fi
grep -E '^## [0-9]' "$repo/CHANGELOG.md" | grep -v -E '^## [0-9]+\.[0-9]+\.[0-9]+ — [0-9]{4}-[0-9]{2}-[0-9]{2}$' || echo "every entry's heading has a date"
