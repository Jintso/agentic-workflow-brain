# Where the brain and the template changed the same lines, the brain's CLAUDE.md is kept as it is, the merge goes to CLAUDE.md.merge with the conflict's line, and the new version is recorded.
tool 2.0.0
installer > /dev/null
echo 'Filled in.' >> brain/CLAUDE.md
echo '- A new rule.' >> tool/templates/CLAUDE.md
tool 2.1.0
installer
cat brain/.claude/brain-version
echo '--- CLAUDE.md'
cat brain/CLAUDE.md
echo '--- CLAUDE.md.merge'
cat brain/CLAUDE.md.merge
