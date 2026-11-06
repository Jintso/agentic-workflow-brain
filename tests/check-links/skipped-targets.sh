# URLs, mail links and absolute paths aren't checked; a title or <angle brackets> are dropped, and an #anchor is split from its file (the anchor case checks it).
brain alpha
cat >> brain/products/alpha/README.md <<'EOF'
- [Site](https://example.com/Gone.md) and [plain](http://example.com)
- [Mail](mailto:someone@example.com)
- [Section](#alpha)
- [Absolute](/gone/Gone.md)
- [Titled](Execution-Plan.md "The plan")
- [Angled](<Execution-Plan.md>)
- [Anchored](Execution-Plan.md#execution-plan)
EOF
run check-links.sh brain
