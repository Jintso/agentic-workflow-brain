# A copy of the tool without git can't compare the templates of two versions: a brain whose CLAUDE.md differs gets the hint.
tool 2.0.0
installer > /dev/null
echo 'Filled in.' >> brain/CLAUDE.md
tool 2.1.0
rm -rf tool/.git
installer
