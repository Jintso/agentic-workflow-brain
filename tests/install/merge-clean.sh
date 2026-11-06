# An upgrade across a change to the templates merges it into the brain's copies, its CLAUDE.md filled in by /init-brain and a template left as shipped, and shows what changed.
tool 2.0.0
printf '# CLAUDE.md\n\n[PLACEHOLDER]\n\n## Rules\n\n- One rule.\n' > tool/templates/CLAUDE.md
tool 2.0.1
installer > /dev/null
sed 's/\[PLACEHOLDER\]/Personal Homelab/' brain/CLAUDE.md > CLAUDE.md && mv CLAUDE.md brain/CLAUDE.md
echo '- A new rule.' >> tool/templates/CLAUDE.md
echo '**Date:**' >> tool/templates/Handoff-Template.md
tool 2.1.0
installer
cat brain/.claude/brain-version
echo '--- CLAUDE.md'
cat brain/CLAUDE.md
echo '--- templates/Handoff-Template.md'
cat brain/templates/Handoff-Template.md
echo '--- .merge files'
find brain -name '*.merge'
