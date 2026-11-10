# ML_HS26 — Reaching the Summit and Returning Alive

**Prediction and temporal trends of summit success and mortality on Nepal Himalaya expeditions, 1905–2025**

Machine learning course project, autumn semester 2026 (HS26).

## Project context

Since 1905, tens of thousands of climbers have attempted the peaks of the Nepal Himalaya. Their expeditions have been recorded systematically, first by the journalist Elizabeth Hawley and today by the Himalayan Database, one of the most complete registries of expedition mountaineering in the world.

This project uses the Himalayan Database to study whether summit success can be predicted, how it has changed over time, and whether it has come at the price of more deaths. The study has four objectives:

1. **Prediction of summit success (primary):** develop and validate a prediction model for summit success, and compare models of increasing flexibility (logistic regression, generalised additive model, support vector machine and neural network). The model is considered to have good predictive ability if its AUC on the validation set is greater than 0.80.
2. **Trends in summit success:** describe how the probability of summit success has changed over calendar time, and whether the trend differs by age, sex and role, using a generalised additive model.
3. **Trends in mortality:** describe how the death rate has changed over calendar time, separately for expedition members and hired staff, and compare it with the trend in summit success, using a Poisson generalised linear model.
4. **Time to summit:** identify the factors associated with the number of days from arrival at base camp to the summit, using a linear model and a generalised additive model.

The full study design, hypothesis and analysis plan are described in the [study protocol](documents/himalayan_project_protocol.md) (version 1.0, 10 November 2026; also available as [HTML](documents/himalayan_project_protocol.html)).

## Data source

- **The Himalayan Database:** the expedition archives of Elizabeth Hawley, maintained by a non-profit organisation and freely available at <https://himalayandatabase.com/downloads.html>.
- **Version used:** the release covering expeditions from 1905 to the Autumn–Winter season of 2025 (application version 2.75).
- **Format:** the database is distributed as a Windows application. Its data tables are stored as dBASE (.DBF) files, which are read directly with R or Python using the Windows-1252 encoding. Coded fields are decoded using the *Himalayan Database Guide* supplied with the database.

| Raw table | File | Records |
|---|---|---|
| Climbers | `members.DBF` | 94,999 |
| Expeditions | `exped.DBF` | 11,854 |
| Peaks | `peaks.DBF` | 503 |

## Contents of the submission

| Folder / file | Contents |
|---|---|
| `README.md` | This file: project description, data source, contents and contributions |
| `ML_Group Project.Rproj` | R project file; open it so that all paths resolve with `here()` |
| `documents/himalayan_project_protocol.md` | Study protocol: background, objectives, hypothesis, data source, methods, analysis plan and limitations (`.html` version alongside) |
| `Raw data/Himalayan Database/` | The Himalayan Database application and its data tables (`HIMDATA/`), as downloaded and never edited |
| `Raw data/Himalayan Database Guide.pdf` | Documentation of the database, including the meaning of coded fields |
| `Scripts/data_clean.R` | Reads the raw DBF files, decodes, checks and links them, applies the inclusion and exclusion criteria, makes the training/validation split and the cross-validation folds, groups rare categories and writes the analysis data sets. Fits no models |
| `Analysis data/` | Analysis data sets and data-cleaning reports produced by `data_clean.R` (see below) |
| `Reports/` | Figures, tables and the final report |

### Analysis data sets

Two analysis data sets are built (protocol Section 3.2).

| Data set | Unit | Records | Used for |
|---|---|---|---|
| `climbers.rds` | Climber level: one row per climber per expedition, with expedition and peak attributes attached, the training/validation set (`set`) and the cross-validation fold (`fold`) | 94,871 | Objectives 1 and 2 |
| `expeditions.rds` | Expedition level: one row per expedition, with peak attributes attached and climber characteristics summarised within the expedition | 11,854 | Objectives 3 and 4 |

The expedition-level data set holds both expedition-level objectives:

- **Objective 3:** keep expeditions with `obj3 == TRUE` (11,820) and reshape the columns `deaths_member`, `at_risk_member`, `deaths_hired` and `at_risk_hired` to two rows per expedition (members and hired staff). The code for this is in the comments at the end of `data_clean.R`.
- **Objective 4:** keep expeditions with `obj4 == TRUE` (5,557); the outcome is `time_to_summit` in days.

Some variables are known only during or after the summit attempt (summit, death, injury, dates, reason for ending the expedition). They are kept for outcomes and descriptive tables but must **never be used as predictors** (protocol Section 4.4). They are listed in `leakage_vars` in `data_clean.R`. The variables in `check_vars` (recorded oxygen use, base camp only) describe what happened rather than what was planned, and should be discussed with the team before use.

Complete-case selection is not done in the cleaning script, because it depends on the predictors each model uses. It is done when each model is fitted.

### Data-cleaning reports

| File | Contents |
|---|---|
| `flow_of_records.csv` | Number of records kept and removed at each step, for each data set and objective |
| `missing_report.csv` | Proportion of missing values for every variable in both data sets |
| `grouping_rules.csv` | Category levels kept for nationality, expedition nationality, peak and agency (rules set on the training set; all other levels are grouped as "Other") |

## Workflow

1. Open `ML_Group Project.Rproj` in RStudio.
2. Run `Scripts/data_clean.R`. It needs the packages `foreign`, `dplyr`, `stringr`, `forcats`, `tidyr` and `here`. It reads the tables in `Raw data/Himalayan Database/HIMDATA/` and writes the analysis data sets and reports to `Analysis data/`. It also writes `.csv` copies of the two data sets, for use in Python; these are not stored in the repository.
3. Run the analysis scripts for each objective on the analysis data sets. Model fitting, predictor selection and tuning for Objective 1 use the training set only; the validation set is used once, for the final evaluation.
4. Save results, figures and write-ups in `Reports/`.

The random seed is fixed (`set.seed(3535)`), so the training/validation split and the cross-validation folds are the same for everyone in the team.

## Authors

| Name | Contact |
|---|---|
| Author 1 | email |
| Author 2 | email |
| Author 3 | email |

## Contributions

| Task | Contributor | QC |
|---|---|---|
| Data cleaning | Hsiang-Chi Wang | |
| Data analysis — Objective 1: prediction of summit success | | |
| Data analysis — Objective 2: trends in summit success | | |
| Data analysis — Objective 3: trends in mortality | | |
| Data analysis — Objective 4: time to summit | | |
| Reporting | | |

## Getting started

```
git clone https://github.com/laybao/ML_HS26.git
cd ML_HS26
```
