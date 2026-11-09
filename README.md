# ML_HS26 — Who Reaches the Summit? Predicting Summit Success on Nepal Himalaya Expeditions

Machine learning course project, autumn semester 2026 (HS26).

## Project context

Since 1905, tens of thousands of climbers have attempted the peaks of the Nepal Himalaya. Their expeditions have been recorded systematically, first by the journalist Elizabeth Hawley and today by the Himalayan Database, one of the most complete registries of expedition mountaineering in the world.

This project uses the Himalayan Database to study what determines whether a climber reaches the summit. The study has four objectives:

1. **Prediction of summit success:** develop and validate a prediction model for summit success, and compare models of increasing complexity (logistic regression, generalised additive model, support vector machine and neural network). The model is considered to have good predictive ability if its AUC on the validation set is greater than 0.80.
2. **Predictor importance:** identify the predictors that contribute most to summit success, and check whether different models agree.
3. **How close climbers get:** model the proportion of the peak's height reached by each climber, using a linear model and a generalised additive model.
4. **Success at the team level:** model the number of expedition members who reach the summit, using a Poisson generalised linear model.

The full study design, hypothesis and analysis plan are described in the [study protocol](documents/himalayan_project_protocol.md).

## Data source

- **The Himalayan Database**: the expedition archives of Elizabeth Hawley, maintained by a non-profit organisation and freely available at <https://himalayandatabase.com/downloads.html>.
- **Version used:** the release covering expeditions from 1905 to the Autumn–Winter season of 2025.
- **Format:** the database is distributed as a Windows application. Its data tables (climbers, expeditions and peaks) are stored as dBASE (`.DBF`) files, which are read directly with R or Python using the Windows-1252 encoding.

## Contents of the submission

| Folder / file | Contents |
|---|---|
| `README.md` | This file: project description, data source, contents and authors |
| `documents/` | Project documents |
| `documents/himalayan_project_protocol.md` | Study protocol: background, research purpose, objectives, hypothesis, data source, methods, analysis plan and limitations |
| `Raw data/` | Original, unmodified data tables from the Himalayan Database (never edited) |
| `Analysis data/` | Cleaned and processed data sets produced by the scripts |
| `Scripts/` | Code for data extraction and cleaning, model training and evaluation |
| `Reports/` | Figures, tables and the final report |

## Workflow

1. Place the original database tables in `Raw data/`.
2. Run the scripts in `Scripts/` to produce the analysis data sets in `Analysis data/`.
3. Save results, figures and write-ups in `Reports/`.

## Authors

| Name | Contact |
|---|---|
| _Author 1_ | _email_ |
| _Author 2_ | _email_ |
| _Author 3_ | _email_ |

## Contributions

| Name | Contribution |
|---|---|
| _Author 1_ | _e.g. study protocol, data extraction and cleaning_ |
| _Author 2_ | _e.g. generalised linear and additive models_ |
| _Author 3_ | _e.g. support vector machine, neural network and report_ |

## Getting started

```bash
git clone https://github.com/laybao/ML_HS26.git
cd ML_HS26
```
