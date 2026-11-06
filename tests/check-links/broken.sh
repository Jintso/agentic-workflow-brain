# A link to a file that doesn't exist is BROKEN; one that climbs with ../ to a file that does is not.
brain alpha
printf -- '- [Gone](Gone.md)\n- [Products](../README.md)\n' >> brain/products/alpha/README.md
run check-links.sh brain
