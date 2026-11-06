# A leftover [[wikilink]] is WIKILINK, once per file with the count.
brain alpha
printf 'See [[Execution-Plan]] and [[README]].\n' >> brain/products/alpha/README.md
run check-links.sh brain
