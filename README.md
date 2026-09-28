# Data Mining I — STAT5703 (Carleton University, Winter 2025)

Course projects in R covering the core data-mining workflow: data cleaning,
exploratory analysis and visualization, dimensionality reduction (PCA/ICA),
association rule mining, clustering, and supervised learning (regression,
trees, random forests).

> **Status note (2026-09-27).** The Assignment 1 `.R` sources were lost and have
> been **reconstructed** from the graded reports; the Assignment 2 and final
> project `.Rmd` files were recovered and **cleaned** (duplicate `library()`
> calls removed, one variable-shadowing bug fixed — see notes in the files).
> R is not installed in this environment, so **none of the code was executed
> here**. Each script/Rmd states this in its header: run it in RStudio and
> compare the outputs with the expected values cited in the comments and in
> `reports/`.

## Projects

| Folder | Assignment | Topic |
|---|---|---|
| `assignment1-hr-visualization/` | A1, Part 1 | HR analytics: manager vs performance, diversity profile, recruiting sources, termination prediction, pay equity (`HRDataset_v14.csv`) |
| `assignment1-association-rules/` | A1, Part 2 | Market basket analysis with **arules** on bakery transactions (`bread_basket.csv`) |
| `assignment2-red-wine-pca-ica/` | A2, Part 1 | EDA + PCA + ICA on the UCI red wine quality dataset |
| `assignment2-diabetes-clustering/` | A2, Part 2 | Clustering (k-means, PAM, CLARA, hierarchical) on diabetes health indicators |
| `final-project-auto-prices/` | Final project (Group 4) | Automobile price analysis: cleaning, EDA, clustering, PCA, linear regression + 10-fold CV, decision tree, random forest |
| `reports/` | — | Original graded reports (PDF/DOCX), unchanged |
| `data/` | — | Datasets recovered for Assignment 1 |

## Data sources

| File | Source | Notes |
|---|---|---|
| `data/HRDataset_v14.csv` | Course dataset (Brightspace) | 311 × 36 HR records; shipped in this repo |
| `data/bread_basket.csv` | Bakery transactions, CC0 public domain (course dataset) | 20,507 rows / 9,465 transactions; shipped in this repo |
| `winequality-red.csv` | [UCI ML Repository — Wine Quality](https://archive.ics.uci.edu/dataset/53/wine+quality) | **Not** shipped (not recovered). Download and place next to the Rmd; the file is `;`-separated |
| `diabetes_binary_5050split_health_indicators_BRFSS2015.csv` | [Kaggle — Diabetes Health Indicators Dataset](https://www.kaggle.com/datasets/alexteboul/diabetes-health-indicators-dataset) (BRFSS 2015) | **Not** shipped (not recovered). Place next to the Rmd |
| `imports-85.data` | [UCI ML Repository — Automobile](https://archive.ics.uci.edu/dataset/10/automobile) | **Not** shipped (not recovered). Header-less file; the Rmd assigns column names. Place next to the Rmd |

Each project folder's README repeats the exact filename expected and where to get it.

## How to run

1. Install R (≥ 4.0) and RStudio.
2. Install the packages listed at the top of each script/Rmd (each file loads
   everything it needs in its first chunk).
3. For Assignment 2 / final project, download the dataset noted above into the
   project folder.
4. Open the `.R`/`.Rmd` and run. Assignment 1 scripts assume the working
   directory is their own folder and read data from `../data/`.

## Reproducibility caveats

- `assignment1-hr-visualization`: the CSV copy here stores `""` instead of
  `"N/A-StillEmployed"` in `DateofTermination` for active employees (the
  original file had the latter — see the original appendix). The script
  restores that value before `drop_na()` to reproduce the original 303-row
  clean dataset; this is documented in the script.
- `assignment1-association-rules`: `read.transactions()` emits "EOF within
  quoted string" warnings (a few item labels contain apostrophes) — the
  original run showed the same warnings; top-item supports are unaffected.
- `assignment2-diabetes-clustering`: `set.seed(123)` is kept *after* the 5%
  subsample, exactly as in the original, so the subset differs run to run
  while the clustering steps are seeded. The gap statistic was run on the
  unnormalized frame in the original and is kept as-is; both are flagged in
  the Rmd.
