# Assignment 1, Part 2 — Association Rule Mining (Bakery)

**Script:** `assignment1_association_rules.R`
**Data:** `../data/bread_basket.csv` (shipped in this repo; CC0 public domain)

Market basket analysis with **arules** / **arulesViz**:

1. Converts the basket data to `transactions` via `Transaction_Number`
   (one comma-separated item list per transaction).
2. Frequent itemsets with Apriori at support = 0.04 — Coffee (0.478) and Bread
   (0.327) are the best sellers; {Bread, Coffee} (0.090) is the top duo.
3. Association rules at support = 0.04 with lift > 1 (≥ 4 rules, per the
   brief): `{Pastry}⇒{Coffee}`, `{Cake}⇒{Coffee}`, `{Coffee}⇒{Cake}`,
   `{Coffee}⇒{Pastry}`.
4. The report's adjusted run (support = 0.02, confidence = 0.2 — the brief
   allows adjusting support "if needed") reproducing the 8-rule table:
   Coffee is the hub item; Medialuna has the highest confidence (0.57);
   `{Cake}⇒{Tea}` has the highest lift (1.61).
5. Rule graph plot, "what next after Bread/Coffee" exploration, and
   transaction trends (weekday vs weekend, period of day, top-5 items by
   period — afternoons peak; Coffee and Pastry are morning-driven).

## Status

Reconstructed 2026-09-27 from the graded reports — the original `.R` file was
lost. **Not executed** (R unavailable in this environment); run in RStudio with
this folder as the working directory and verify against the findings in the
comments and `../reports/Assignement_1_basket.pdf`.

## Notes

- `read.transactions()` prints "EOF within quoted string" warnings (a few item
  labels contain apostrophes, e.g. `'Coffee granules '`) — the original run
  showed the same warnings; the supports are unaffected.
- The intermediate basket file is written to a tempfile instead of the working
  directory (the original wrote `transactions_cleaned.csv` next to the script).

## Packages

`arules`, `arulesViz`, `dplyr`, `ggplot2`
