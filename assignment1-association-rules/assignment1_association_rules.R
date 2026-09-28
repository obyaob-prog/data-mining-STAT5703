# =============================================================================
# STAT5703 Data Mining I - Assignment 1, Part 2: Association Rule Mining
# Yann OBROU
#
# RECONSTRUCTED script (2026-09-27). The original .R file for Assignment 1 was
# lost; this script was rebuilt from the graded reports
# (reports/Assignement_1_basket.pdf and reports/assignement-1-Part-2.docx,
# the latter containing the original code and console output).
#
# IMPORTANT: R is not available in this environment, so this script was NOT
# executed here. Run it in RStudio (working directory = this folder) and check
# that the printed supports / rules match the findings noted in the comments.
#
# Data: ../data/bread_basket.csv -- 20,507 rows (one row per purchased item),
# 9,465 transactions, columns: Transaction_Number, Item, date_time,
# period_of_day, weekday_or_weekend. CC0 public domain bakery dataset.
# =============================================================================

library(arules)
library(arulesViz)
library(dplyr)
library(ggplot2)

# ---------------------------------------------------------------------------
# 1. Data preprocessing: convert to arules transactions
# ---------------------------------------------------------------------------
basket <- read.csv("../data/bread_basket.csv", stringsAsFactors = FALSE)

# Keep the columns needed for market basket analysis, drop NAs / empty items
basket_items <- basket[, c("Transaction_Number", "Item")]
basket_items <- na.omit(basket_items)
basket_items <- basket_items[basket_items$Item != "", ]

# Aggregate: one comma-separated item list per transaction (duplicates within a
# transaction are collapsed with unique(), as in the original)
transactions_df <- basket_items %>%
  group_by(Transaction_Number) %>%
  summarise(Items = paste(unique(Item), collapse = ","), .groups = "drop")

# NOTE: the original wrote this intermediate file to the working directory and
# read it back with read.transactions(). A tempfile is used here instead so the
# repo stays clean; the parsing is identical.
tmp_basket <- tempfile(fileext = ".csv")
write.table(transactions_df$Items, tmp_basket,
            row.names = FALSE, col.names = FALSE, quote = FALSE, sep = ",")
transactions <- read.transactions(tmp_basket, format = "basket", sep = ",")

# NOTE: read.transactions() reports "EOF within quoted string" warnings because
# a few item labels contain apostrophes (e.g. "'Coffee granules '"). The
# original run showed the same warnings; the parsed set has 104 items and
# 9,465 transactions, and the top-item supports below are unaffected.
print(transactions)
inspect(transactions[1:5])

# ---------------------------------------------------------------------------
# 2. Frequent item analysis (Apriori, min support = 0.04, as per the brief)
# ---------------------------------------------------------------------------
frequentItems <- apriori(transactions,
                         parameter = list(supp = 0.04,
                                          target = "frequent itemsets"))
inspect(sort(frequentItems, by = "support", decreasing = TRUE))

# Reported frequent itemsets (support / count, 9,465 transactions):
# {Coffee} 0.4782 / 4526 -- best seller
# {Bread}  0.3269 / 3094 -- best seller
# {Tea}    0.1425 / 1349
# {Cake}   0.1039 / 983
# {Bread, Coffee} 0.0900 / 852  <- most frequent duo
# {Pastry} 0.0860 / 814
# {Sandwich} 0.0718 / 680
# {Medialuna} 0.0617 / 584
# {Hot chocolate} 0.0583 / 552
# {Cake, Coffee} 0.0547 / 518
# {Cookies} 0.0543 / 514
# {Coffee, Tea} 0.0499 / 472
# {Coffee, Pastry} 0.0474 / 449

itemFrequencyPlot(transactions, topN = 5,
                  type = "absolute",
                  col = "steelblue",
                  main = "Top 5 Most Frequent Items")

# ---------------------------------------------------------------------------
# 3. Association rule mining (brief: initial support = 0.04, >= 4 rules with
#    lift > 1)
# ---------------------------------------------------------------------------
rules <- apriori(transactions,
                 parameter = list(supp = 0.04, conf = 0.05, target = "rules"))
rules_sorted <- sort(rules, by = "lift", decreasing = TRUE)
rules_lift1 <- subset(rules_sorted, lift > 1)

cat("\nRules with support >= 0.04 and lift > 1:\n")
inspect(rules_lift1)

# Expected (4 rules, all with lift > 1):
# {Pastry} => {Coffee}  supp 0.0474  conf 0.5516  lift 1.1535
# {Cake}   => {Coffee}  supp 0.0547  conf 0.5270  lift 1.1020
# {Coffee} => {Cake}    supp 0.0547  conf 0.1144  lift 1.1020
# {Coffee} => {Pastry}  supp 0.0474  conf 0.0992  lift 1.1535

# ---------------------------------------------------------------------------
# 4. The original report's adjusted run (the brief allows adjusting support
#    "if needed"): support = 0.02, confidence = 0.2, single-item LHS restricted
#    to frequent items, lift > 1 -- reproduces the 8-rule table in the report.
# ---------------------------------------------------------------------------
frequent_items <- unique(unlist(LIST(items(frequentItems), decode = TRUE)))

rules_adj <- apriori(transactions,
                     parameter = list(supp = 0.02, conf = 0.2,
                                      target = "rules"))
rules_adj <- sort(rules_adj, by = "confidence", decreasing = TRUE)
rules_adj <- subset(rules_adj,
                    size(lhs) == 1 & lhs %in% frequent_items & lift > 1)

cat("\nAdjusted run (supp = 0.02, conf = 0.2), rules with lift > 1:\n")
inspect(head(rules_adj, 20))

# Expected (sorted by confidence):
# {Medialuna}     => {Coffee}  supp 0.0351  conf 0.5685  lift 1.1889
# {Pastry}        => {Coffee}  supp 0.0474  conf 0.5516  lift 1.1535
# {Sandwich}      => {Coffee}  supp 0.0382  conf 0.5324  lift 1.1133
# {Cake}          => {Coffee}  supp 0.0547  conf 0.5270  lift 1.1020
# {Cookies}       => {Coffee}  supp 0.0282  conf 0.5195  lift 1.0863
# {Hot chocolate} => {Coffee}  supp 0.0296  conf 0.5072  lift 1.0608
# {Pastry}        => {Bread}   supp 0.0292  conf 0.3391  lift 1.0373
# {Cake}          => {Tea}     supp 0.0238  conf 0.2289  lift 1.6060
#
# Reading: Coffee is the hub item (highest-confidence associations);
# surprisingly Medialuna has the best confidence; Pastry goes with Bread and
# Cake goes with Tea (highest lift, 1.61).

# ---------------------------------------------------------------------------
# 5. Visualize the rules
# ---------------------------------------------------------------------------
# NOTE: the original call passed control = list(type = "items"), which
# arulesViz rejects ("Unknown control parameters"). Dropped here.
plot(rules_lift1, method = "graph")

# ---------------------------------------------------------------------------
# 6. What would a buyer of Bread / Coffee buy next? (exploratory, from report)
# ---------------------------------------------------------------------------
rules_bread <- subset(sort(rules_adj, by = "confidence", decreasing = TRUE),
                      lhs %pin% "Bread")
cat("\nRules with LHS = {Bread}:\n")
inspect(head(rules_bread, 10))
# Expected: {Bread} => {Coffee} (conf 0.275, lift 0.58 -- below 1, i.e. bought
# together often but not a positive association), {Bread} => {Pastry}
# (conf 0.089, lift 1.037), {Bread} => {Tea} (lift 0.60), {Bread} => {Cake}
# (lift 0.69).

rules_coffee <- subset(sort(rules_adj, by = "confidence", decreasing = TRUE),
                       lhs %pin% "Coffee")
cat("\nRules with LHS = {Coffee}:\n")
inspect(head(rules_coffee, 10))
# Expected: {Coffee} => {Cake} (lift 1.10), {Coffee} => {Pastry} (lift 1.15),
# {Coffee} => {Sandwich} (lift 1.11), {Coffee} => {Medialuna} (lift 1.19),
# {Coffee} => {Hot chocolate} (lift 1.06), {Coffee} => {Cookies} (lift 1.09).

# ---------------------------------------------------------------------------
# 7. Transaction trends
# ---------------------------------------------------------------------------
cat("\nTransactions by weekday/weekend (item rows):\n")
print(table(basket$weekday_or_weekend))
# Reported: weekday 12807, weekend 7700

cat("\nTransactions by period of day (item rows):\n")
print(table(basket$period_of_day))
# Reported: morning 8404, afternoon 11569, evening 520, night 14 --
# afternoons are the peak sales period.

# Period of day for each of the top-5 items (item rows)
top5 <- c("Coffee", "Bread", "Tea", "Cake", "Pastry")
cat("\nTop-5 items by period of day:\n")
print(table(basket$Item[basket$Item %in% top5],
            basket$period_of_day[basket$Item %in% top5]))
# Reported (morning / afternoon / evening):
# Coffee  2561 / 2823 / 87   -- morning-driven
# Bread   1610 / 1661 / 54
# Tea      456 /  930 / 49
# Cake     264 /  731 / 30
# Pastry   604 /  242 / 10   -- morning-driven
