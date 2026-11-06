# A parent line inside a fence doesn't count: the file is NO-PARENT (gap 4, 6c3eeaa).
brain alpha
cat > brain/products/alpha/Notes.md <<'EOF'
```
> Part of [alpha](README.md)
```

# Notes
EOF
echo '- [Notes](Notes.md)' >> brain/products/alpha/README.md
run check-links.sh brain
