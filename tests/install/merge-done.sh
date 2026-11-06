# A brain whose CLAUDE.md already has the template's change, merged by hand, is kept as it is and asks for nothing.
tool 2.0.0
printf '# CLAUDE.md\n\n[PLACEHOLDER]\n\n## Rules\n\n- One rule.\n' > tool/templates/CLAUDE.md
tool 2.0.1
installer > /dev/null
sed 's/\[PLACEHOLDER\]/Personal Homelab/' brain/CLAUDE.md > CLAUDE.md && mv CLAUDE.md brain/CLAUDE.md
echo '- A new rule.' >> tool/templates/CLAUDE.md
echo '- A new rule.' >> brain/CLAUDE.md
tool 2.1.0
installer
