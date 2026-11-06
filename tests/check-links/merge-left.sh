# A merge the installer left beside CLAUDE.md or a template is reported as MERGE with its conflicts to resolve, and one resolved but not moved says so.
brain
printf '# CLAUDE.md\n\n<<<<<<< CLAUDE.md\nMine.\n=======\nNew.\n>>>>>>> template 2.3.0\n' > brain/CLAUDE.md.merge
mkdir -p brain/templates
printf '# Handoff\n\n**Date:**\n' > brain/templates/Handoff-Template.md.merge
run check-links.sh brain
