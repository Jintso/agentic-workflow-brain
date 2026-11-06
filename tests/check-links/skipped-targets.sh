# URLs, mail links, anchors and absolute paths aren't checked; a title, <angle brackets> or an #anchor after a file are dropped.
brain alpha
cat >> brain/products/alpha/README.md <<'EOF'
- [Site](https://example.com/Gone.md) and [plain](http://example.com)
- [Mail](mailto:someone@example.com)
- [Section](#execution-plan)
- [Absolute](/gone/Gone.md)
- [Titled](Execution-Plan.md "The plan")
- [Angled](<Execution-Plan.md>)
- [Anchored](Execution-Plan.md#phase-1)
EOF
run check-links.sh brain
