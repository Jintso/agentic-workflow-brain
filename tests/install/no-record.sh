# A brain with no .claude/brain-version, as one installed before 2.0.0, gets the hint and the changelog's list of earlier template changes.
tool 2.0.0
installer > /dev/null
echo 'Filled in.' >> brain/CLAUDE.md
rm brain/.claude/brain-version
installer
