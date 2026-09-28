# =============================================================================
# STAT5703 Data Mining I - Assignment 1, Part 1: HR Data Visualization
# Yann OBROU
#
# RECONSTRUCTED script (2026-09-27). The original .R file for Assignment 1 was
# lost; this script was rebuilt from the graded reports
# (reports/Assignement_1_human_resource.pdf and reports/assignement-1-Part-2.docx,
# the latter containing the original code and console output).
#
# IMPORTANT: R is not available in this environment, so this script was NOT
# executed here. Run it in RStudio (working directory = this folder) and check
# that the printed numbers match the findings noted in the comments below.
#
# Data: ../data/HRDataset_v14.csv (311 rows x 36 columns)
# =============================================================================

library(dplyr)
library(tidyr)
library(ggplot2)
library(reshape2)

# ---------------------------------------------------------------------------
# Load and clean
# ---------------------------------------------------------------------------
hr_data <- read.csv("../data/HRDataset_v14.csv",
                    stringsAsFactors = FALSE,
                    fileEncoding = "UTF-8-BOM")  # strips the BOM on Employee_Name

# Data quirk (2026-09-27): the copy of the CSV shipped here stores an empty
# string in DateofTermination for active employees, while the file used for the
# original analysis stored "N/A-StillEmployed" (see head() output in the
# original appendix). Restoring that value reproduces the original
# 303-row clean dataset; without it, drop_na() would keep only 104 rows and
# none of the reported numbers would match.
hr_data$DateofTermination[hr_data$DateofTermination == ""] <- "N/A-StillEmployed"

cat("\nDimensions of the dataset (rows, columns):\n")
print(dim(hr_data))                       # 311 36

cat("\nCount of missing values by column:\n")
print(colSums(is.na(hr_data)))

hr_data_clean <- hr_data %>% drop_na()

cat("\nDimensions after removing rows with missing values:\n")
print(dim(hr_data_clean))                 # 303 36
cat("\nFirst row:\n")
print(head(hr_data_clean, 1))

# =============================================================================
# a) Is there any relationship between who a person works for and their
#    performance score?
# =============================================================================
ggplot(data = hr_data_clean,
       aes(x = as.factor(ManagerID), fill = PerformanceScore)) +
  geom_bar(position = "stack") +
  # NOTE: the original used the deprecated ..count.. notation; after_stat()
  # is the current equivalent.
  geom_text(stat = "count", aes(label = after_stat(count)),
            position = position_stack(vjust = 0.5)) +
  labs(title = "Employee Performance by Manager",
       x = "Manager ID", y = "Number of Employees",
       fill = "Performance Score") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Reported findings (match the crosstab below):
# - Manager 14 has the highest number of "Fully Meets" (19), followed by
#   Managers 18 and 19 (18 each).
# - Manager 12 has the most "Exceeds" (7).
# - Manager 12 also has the most PIPs (4); Managers 17, 11, 21, 39 have 2.
print(addmargins(table(hr_data_clean$ManagerID, hr_data_clean$PerformanceScore)))

# =============================================================================
# b) What is the overall diversity profile of the organization?
# =============================================================================
# --- by race / ethnicity ---
ggplot(hr_data_clean, aes(x = RaceDesc, fill = RaceDesc)) +
  geom_bar() +
  labs(title = "Ethnic Diversity Profile", x = "Race", y = "Count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5))

# --- by sex ---
ggplot(hr_data_clean, aes(x = Sex, fill = Sex)) +
  geom_bar() +
  labs(title = "Workforce by Sex", x = "Sex", y = "Count") +
  theme_minimal()

# --- by marital status ---
ggplot(hr_data_clean, aes(x = MaritalDesc, fill = MaritalDesc)) +
  geom_bar() +
  labs(title = "Workforce by Marital Status", x = "Marital Status", y = "Count") +
  theme_minimal()

# Reported findings:
# - Predominantly White workforce (183/303, ~60%), followed by Black or
#   African American (79). Asian representation is moderate (26); Two or more
#   races (11), American Indian or Alaska Native (3) and Hispanic (1) are minimal.
# - Sex split: 171 F / 132 M. Marital status: mostly Single (132) and
#   Married (122).
print(prop.table(table(hr_data_clean$RaceDesc)))
print(table(hr_data_clean$Sex))
print(table(hr_data_clean$MaritalDesc))

# =============================================================================
# c) What are our best recruiting sources if we want to ensure a diverse
#    organization?
# =============================================================================
ggplot(hr_data_clean, aes(x = RecruitmentSource, fill = RaceDesc)) +
  geom_bar(position = "fill") +   # percentage-based stacking
  labs(title = "Diversity of Recruitment Sources (Stacked Percentage)",
       x = "Recruitment Source", y = "Proportion", fill = "Race") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Reported findings:
# - The Diversity Job Fair is the most diverse source (0% White in this data,
#   all hires Black or African American), followed by Website, Indeed and
#   LinkedIn (the original report recommends LinkedIn).
# - Employee Referral and Google Search skew heavily White (~81% and ~74%),
#   i.e. poor channels for diversifying the workforce.
src_race <- prop.table(table(hr_data_clean$RecruitmentSource,
                             hr_data_clean$RaceDesc), margin = 1)
print(round(src_race, 3))

# =============================================================================
# d) Can we predict who is going to terminate and who isn't?
#    What level of accuracy can we achieve on this?
# =============================================================================
# --- Salary distribution by employment status ---
ggplot(hr_data_clean, aes(x = Salary, fill = factor(EmploymentStatus))) +
  geom_histogram(binwidth = 5000, alpha = 0.7, position = "identity") +
  labs(title = "Salary Distribution by Employment Status",
       x = "Salary", y = "Number of Employees", fill = "Employment Status") +
  theme_minimal()

# --- Engagement by employment status ---
ggplot(hr_data_clean,
       aes(x = factor(EmploymentStatus), y = EngagementSurvey,
           fill = factor(EmploymentStatus))) +
  geom_boxplot() +
  labs(title = "Employee Engagement by Employment Status",
       x = "Employment Status", y = "Engagement Score") +
  theme_minimal()

# --- Satisfaction by employment status ---
ggplot(hr_data_clean,
       aes(x = factor(EmploymentStatus), y = EmpSatisfaction,
           fill = factor(EmploymentStatus))) +
  geom_boxplot() +
  labs(title = "Employee Satisfaction by Employment Status",
       x = "Employment Status", y = "EmpSatisfaction") +
  theme_minimal()

# --- Absences by employment status ---
ggplot(hr_data_clean, aes(x = Absences, fill = factor(EmploymentStatus))) +
  geom_histogram(binwidth = 1, alpha = 0.7, position = "identity") +
  labs(title = "Distribution of Absences by Employment Status",
       x = "Absences", y = "Number of Employees", fill = "Employment Status") +
  theme_minimal()

# --- Performance score by employment status ---
# NOTE: the original appendix plotted a tile heatmap of a melted
# (EmploymentStatus, PerfScoreID) frame, which mixes types and is hard to read.
# This stacked bar shows the same relationship more clearly and supports the
# same finding.
ggplot(hr_data_clean, aes(x = EmploymentStatus, fill = PerformanceScore)) +
  geom_bar(position = "fill") +
  labs(title = "Performance Score by Employment Status (proportions)",
       x = "Employment Status", y = "Proportion", fill = "Performance Score") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 30, hjust = 1))

# Reported findings:
# - Terminated employees (voluntary or for cause) tend to have lower salaries
#   than active employees (means: Active ~$71k, Voluntary ~$64k).
# - Lower engagement/satisfaction and higher absences are associated with
#   termination; high absenteeism is a particularly strong signal for
#   involuntary termination (mean absences: Active 9.9, Voluntary 11.0,
#   For Cause 11.6).
# - Low performance scores are strongly associated with terminations.
print(aggregate(cbind(Salary, EngagementSurvey, EmpSatisfaction, Absences) ~
                  EmploymentStatus, data = hr_data_clean, mean))

# --- Simple predictive model: logistic regression ---
# The original report estimated 60%-85% accuracy from the visual patterns
# above. The model below quantifies it; its own train/test accuracy is printed
# when the script runs.
set.seed(42)
hr_model <- hr_data_clean
hr_model$Termd <- as.factor(hr_model$Termd)   # 1 = terminated, 0 = active

train_idx <- sample(seq_len(nrow(hr_model)), size = floor(0.7 * nrow(hr_model)))
train_set <- hr_model[train_idx, ]
test_set  <- hr_model[-train_idx, ]

term_model <- glm(Termd ~ Salary + EngagementSurvey + EmpSatisfaction +
                    Absences + PerfScoreID,
                  data = train_set, family = binomial)
print(summary(term_model))

pred_prob <- predict(term_model, newdata = test_set, type = "response")
pred_term <- factor(ifelse(pred_prob > 0.5, 1, 0), levels = c(0, 1))

cat("\nConfusion matrix (test set):\n")
print(table(Predicted = pred_term, Actual = test_set$Termd))
test_acc <- mean(pred_term == test_set$Termd)
cat(sprintf("\nTest accuracy: %.1f%%\n", 100 * test_acc))
cat(sprintf("Baseline (always predict majority class): %.1f%%\n",
            100 * max(prop.table(table(test_set$Termd)))))

# =============================================================================
# e) Are there areas of the company where pay is not equitable?
# =============================================================================
# --- Average salary by department (pie chart, as in the original report) ---
# NOTE: the original overwrote hr_data_clean with the summary; a separate
# object is used here so the detailed data stays available.
dept_salary <- hr_data_clean %>%
  group_by(Department) %>%
  summarise(mean_salary = mean(Salary, na.rm = TRUE), .groups = "drop")

ggplot(dept_salary, aes(x = "", y = mean_salary, fill = Department)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar(theta = "y") +
  geom_text(aes(label = round(mean_salary, 2)),
            position = position_stack(vjust = 0.5)) +
  labs(title = "Average Salary by Department", x = "", y = "Average Salary") +
  theme_void() +
  theme(legend.title = element_blank())

# --- Salary distribution by department ---
ggplot(hr_data_clean, aes(x = Department, y = Salary, fill = Department)) +
  geom_boxplot() +
  labs(title = "Salary Distribution by Department",
       x = "Department", y = "Salary") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 30, hjust = 1),
        legend.position = "none")

# --- Salary by department and sex ---
ggplot(hr_data_clean, aes(x = Department, y = Salary, fill = Sex)) +
  geom_boxplot() +
  labs(title = "Salary by Department and Sex",
       x = "Department", y = "Salary") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 30, hjust = 1))

# --- Salary by race ---
ggplot(hr_data_clean, aes(x = RaceDesc, y = Salary, fill = RaceDesc)) +
  geom_boxplot() +
  labs(title = "Salary Distribution by Race", x = "Race", y = "Salary") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 30, hjust = 1),
        legend.position = "none")

# Reported findings:
# - Large gaps in average salary across departments: Executive Office is far
#   above the rest (mean ~$250k, n = 1 -- interpret with caution), followed by
#   IT/IS and Software Engineering; Production has the lowest average.
# - Within departments, median salaries differ by sex in several departments
#   (e.g. Sales: F ~$72k vs M ~$66k; IT/IS: F ~$94.6k vs M ~$99k).
# - Overall median salaries by race are close (White ~$62.1k, Black or African
#   American ~$63.8k, Asian ~$64.8k), but some groups have very small samples.
print(dept_salary %>% arrange(desc(mean_salary)))
print(aggregate(Salary ~ Department + Sex, data = hr_data_clean, median))
print(aggregate(Salary ~ RaceDesc, data = hr_data_clean, median))
