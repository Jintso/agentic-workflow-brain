# A link from one product's folder into another's is CROSS-PRODUCT; a link into company/ is fine.
brain alpha beta
printf -- '- [Beta plan](../beta/Execution-Plan.md)\n- [Company](../../company/README.md)\n' >> brain/products/alpha/README.md
run check-links.sh brain
