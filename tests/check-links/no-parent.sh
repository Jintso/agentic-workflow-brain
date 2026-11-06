# A file without the "> Part of" line is NO-PARENT; BRAIN-INDEX.md needs none.
brain alpha
printf '# Notes\n' > brain/products/alpha/Notes.md
echo '- [Notes](Notes.md)' >> brain/products/alpha/README.md
run check-links.sh brain
