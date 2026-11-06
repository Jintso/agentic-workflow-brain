# A file nothing links to is an ORPHAN, in a product's folder and in company/.
brain alpha
printf '> Part of [alpha](README.md)\n\n# Notes\n' > brain/products/alpha/Notes.md
printf '> Part of [Company](README.md)\n\n# Values\n' > brain/company/Values.md
run check-links.sh brain
