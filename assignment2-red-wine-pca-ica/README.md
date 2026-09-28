# Assignment 2, Part 1 — Red Wine Quality: PCA & ICA

**Rmd:** `Red_wine_analysis.Rmd`
**Report:** `../reports/RED_WINE_PCA_ICA.pdf`

EDA, Principal Component Analysis and Independent Component Analysis of the
UCI red wine quality dataset (1,599 wines × 11 physicochemical properties +
quality score):

- EDA: quality distribution (pie + bar), correlation heatmap, histograms with
  densities, feature-vs-quality scatterplots with trend lines, boxplots by
  quality.
- PCA on standardized features (`prcomp` + `factoextra`): scree plot, individual
  factor map, variable contributions, PC1/PC2 colored by quality.
- ICA (`ica::icafast`, 5 components): component trace plots, pairs scatterplot,
  density plots.

## Data — NOT shipped

Download **`winequality-red.csv`** (semicolon-separated) from the
[UCI ML Repository — Wine Quality](https://archive.ics.uci.edu/dataset/53/wine+quality)
and place it in this folder next to the Rmd.

## Status

Recovered original file, **cleaned** 2026-09-27: duplicate `library(factoextra)`
/ `library(ica)` calls removed and all imports consolidated in the first chunk;
one stray `.` line in the prose removed. Analysis code is identical.
**Not executed** (R unavailable in this environment); knit in RStudio and
compare with the PDF report.

## Packages

`tidyverse`, `DT`, `ggplot2`, `corrplot`, `skimr`, `FactoMineR`, `factoextra`,
`ica`, `ggpubr`, `GGally`, `plotly`, `ellipse`, `gt`, `dplyr`
