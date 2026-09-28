# Assignment 2, Part 2 — Diabetes Health Indicators: Clustering

**Rmd:** `health_diabetes_ANALYSIS.Rmd`
**Report:** `../reports/health-diabetes-ANALYSIS.pdf`

Clustering analysis of the diabetes health-indicators dataset (BRFSS 2015):

- 5% random subset (3,535 of 70,692 rows) for tractability, z-score
  normalization, missing-value check, correlation matrix, histograms, IQR
  outlier detection, Hopkins clusterability statistic.
- Optimal-k search (silhouette) for k-means, PAM, CLARA and hierarchical
  clustering; elbow method and gap statistic.
- k-means (k = 2 and 3) with cluster + silhouette plots and `cclust` stripes;
  PAM (2, 3); CLARA via `eclust` (2, 3); hierarchical clustering with complete
  and Ward linkage, dendrograms, agglomerative coefficients.

## Data — NOT shipped

Download **`diabetes_binary_5050split_health_indicators_BRFSS2015.csv`** from
[Kaggle — Diabetes Health Indicators Dataset](https://www.kaggle.com/datasets/alexteboul/diabetes-health-indicators-dataset)
and place it in this folder next to the Rmd.

## Status

Recovered original file, **cleaned** 2026-09-27:

- duplicate `library(ggplot2)` removed; imports consolidated;
- **bug fix:** the IQR outlier loop named its bounds `min`/`max`, shadowing
  base R's `min()`/`max()` for every later chunk in the session — renamed to
  `lo_lim`/`hi_lim` (outlier counts unchanged);
- `set.seed(123)` kept *after* the subsample exactly as in the original (so the
  5% subset differs run to run while clustering steps are seeded) — flagged in
  the Rmd;
- the gap statistic was run on the unnormalized frame in the original and is
  kept as-is — flagged in the Rmd.

**Not executed** (R unavailable in this environment); knit in RStudio and
compare with the PDF report.

## Packages

`corrplot`, `stats`, `factoextra`, `ggplot2`, `gridExtra`, `ggplotify`,
`cluster`, `flexclust`, `fpc`, `ClusterR`, `ggpubr`, `dplyr`, `knitr`, `tidyr`
