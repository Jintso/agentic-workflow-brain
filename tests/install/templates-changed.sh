# An upgrade across a change to the templates asks for a merge, names both versions, and records the new one.
tool 2.0.0
installer > /dev/null
echo 'Filled in.' >> brain/CLAUDE.md
echo '- A new rule.' >> tool/templates/CLAUDE.md
tool 2.1.0
installer
cat brain/.claude/brain-version
