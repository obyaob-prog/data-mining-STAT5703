# Final Project (Group 4) — Automobile Price Analysis

**Rmd:** `final_project_data_mining.Rmd`
**Report:** `../reports/final-project-data-mining.docx`

End-to-end data-mining case study on the UCI Automobile (`imports-85`) dataset
(205 cars × 26 attributes), predicting `price`:

- **Cleaning:** `"?"` → `NA`, numeric/categorical typing, mean imputation for
  numerics, mode ("four") imputation for `num_of_doors`, duplicate check.
- **EDA:** distributions of numeric features, count plots of categoricals,
  price vs body style / make boxplots, engine size / horsepower / city MPG vs
  price scatterplots, top-20 makes by average price, correlation heatmap.
- **Encoding:** categoricals → integer codes for modeling.
- **Unsupervised:** IQR outlier detection on scaled data, Hopkins statistic,
  silhouette-based k search, k-means (k = 2) and CLARA (k = 3) with silhouette
  plots, PCA (scree plot + biplot).
- **Supervised:** 70/30 split; linear regression with test MAE and 10-fold CV
  R²; `rpart` decision tree (MAE, R²); random forest (500 trees; MAE, R²);
  actual-vs-predicted plots for all three.

## Data — NOT shipped

Download **`imports-85.data`** (header-less) from the
[UCI ML Repository — Automobile](https://archive.ics.uci.edu/dataset/10/automobile)
and place it in this folder next to the Rmd. The Rmd assigns the 26 column
names itself.

## Status

Recovered original file, **cleaned** 2026-09-27: the original repeated
`library()` calls in almost every chunk (`corrplot` was loaded twice) — all
imports are now consolidated in the first chunk. Analysis code is identical.
**Not executed** (R unavailable in this environment); knit in RStudio and
compare with the DOCX report.

## Packages

`corrplot`, `stats`, `factoextra`, `ggplot2`, `gridExtra`, `ggplotify`,
`cluster`, `flexclust`, `fpc`, `ClusterR`, `ggpubr`, `dplyr`, `knitr`, `tidyr`,
`caret`, `rpart`, `rpart.plot`, `randomForest`
