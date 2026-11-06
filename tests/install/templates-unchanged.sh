# Gap 21: an upgrade that changes only commands asks for no merge, though the brain's CLAUDE.md differs from the template.
tool 2.0.0
installer > /dev/null
echo 'Filled in.' >> brain/CLAUDE.md
echo 'Pull first.' >> tool/.claude/commands/resume.md
tool 2.0.1
installer
