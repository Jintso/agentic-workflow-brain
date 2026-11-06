# Links and wikilinks in fences (``` and ~~~, closed only by the same, at least as long) and in code spans are skipped (gap 4, 6c3eeaa).
brain alpha
cat >> brain/products/alpha/README.md <<'EOF'

An example: `[Spec](Gone.md)` and ``[[Gone]] with a ` inside``.

```markdown
[Spec](features/Feature-Gone.md)
[[Gone]]
```

~~~
[Spec](Gone.md)
```
[Still fenced](Gone.md)
~~~

````
```
[Still fenced](Gone.md)
```
````
EOF
run check-links.sh brain
