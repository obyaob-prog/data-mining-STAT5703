# Assignment 1, Part 1 — HR Data Visualization

**Script:** `assignment1_hr_visualization.R`
**Data:** `../data/HRDataset_v14.csv` (shipped in this repo)

Answers the five questions from the assignment brief using ggplot2/base-R
visualizations on the Human Resources dataset (303 employees after cleaning):

- **a)** Manager vs performance score — stacked bar of `PerformanceScore` by
  `ManagerID` (Manager 14 leads on "Fully Meets" with 19; Manager 12 leads on
  "Exceeds" with 7).
- **b)** Diversity profile — distributions by race (60% White; Black or African
  American next at 26%; Hispanic, American Indian and multiracial minimal),
  sex and marital status.
- **c)** Recruiting sources vs diversity — stacked percentage bars of race by
  `RecruitmentSource` (Diversity Job Fair most diverse; LinkedIn recommended;
  Employee Referral / Google Search skew White).
- **d)** Termination prediction — salary, engagement, satisfaction and absence
  distributions for Active vs Voluntarily Terminated vs Terminated for Cause,
  plus a logistic regression (`Termd ~ Salary + EngagementSurvey +
  EmpSatisfaction + Absences + PerfScoreID`) reporting its own train/test
  accuracy (the original report estimated 60–85% from the visual patterns).
- **e)** Pay equity — average salary by department (pie chart, as in the
  original), plus salary boxplots by department, department × sex, and race.

## Status

Reconstructed 2026-09-27 from the graded reports — the original `.R` file was
lost. **Not executed** (R unavailable in this environment); run in RStudio with
this folder as the working directory and verify the printed tables against the
findings in the comments and `../reports/Assignement_1_human_resource.pdf`.

## Data quirk

The CSV copy here stores `""` in `DateofTermination` for active employees;
the file used originally stored `"N/A-StillEmployed"`. The script restores that
value before `drop_na()` to reproduce the original 303-row clean dataset —
see the comment in the script.

## Packages

`dplyr`, `tidyr`, `ggplot2`, `reshape2`
