# Development and Validation of a Prediction Model for Summit Success Among Climbers on Nepal Himalaya Expeditions: A Retrospective Study Protocol

**Protocol version:** 1.0
**Date:** 9 November 2026
**Study type:** Retrospective prediction model study using registry data
**Context:** Machine learning course project

---

## 1. Introduction

### 1.1 Background

High-altitude mountaineering in the Nepal Himalaya has been documented systematically since the early twentieth century. Records begun by the journalist Elizabeth Hawley and maintained today in the Himalayan Database form one of the most complete longitudinal registries of expedition mountaineering.

Over the last decades, the practice of Himalayan climbing has changed substantially. Commercial guiding has become common, supplemental oxygen is widely used, and many teams are large and supported by hired high-altitude staff. Whether a climber reaches the summit is likely to depend on characteristics of the climber, of the expedition and of the mountain. A model that predicts summit success from information available before or at the start of an expedition could help to describe the likely outcome of a planned ascent and to identify the factors that contribute most to success.

Summit success is usually recorded as a binary outcome. A binary outcome does not distinguish a climber who turned back just below the summit from one who abandoned the climb low on the mountain, and it does not describe success at the level of the team. This study therefore looks at summit success from three complementary angles: whether an individual climber reaches the summit, how close each climber gets to the summit, and how many members of an expedition reach the summit.

### 1.2 Research Purpose

The Himalayan Database is a non-profit registry that records every mountaineering expedition to the peaks of the Nepal Himalaya. It continues the archive compiled by Elizabeth Hawley from 1963 onwards and includes expeditions documented retrospectively back to 1905. For each climber, the registry records their characteristics, the expedition they joined, the peak attempted and the outcome of the expedition. This study uses the most recent release of the registry, covering expeditions from 1905 to the Autumn–Winter season of 2025. The study population consists of all climbers recorded as members of an expedition to a peak in the Nepal Himalaya during this period, including hired expedition staff. Each climber's participation in one expedition is one observation. In this analysis, we will use the Himalayan Database to: 1) build and validate a prediction model for summit success in climbers on Himalayan expeditions; 2) identify the predictors that contribute most to summit success; 3) model how close climbers come to the summit; and 4) model the number of expedition members who reach the summit.

### 1.3 Objectives

The objectives build on each other. Objective 1 asks whether summit success can be predicted and whether more complex models predict it better. Objective 2 asks what the predictions are based on. Objective 3 replaces the binary outcome with a continuous measure of how close climbers come to the summit. Objective 4 moves from the individual climber to the expedition.

**Primary objective**

1. To develop and validate a prediction model for summit success in climbers on Nepal Himalaya expeditions, and to compare the predictive performance of models of increasing complexity: a generalised linear model with binomial family (logistic regression), a generalised additive model, a support vector machine and a neural network.

**Secondary objectives**

2. To identify the predictors that contribute most to the prediction of summit success, and to assess whether the importance of predictors is consistent across modelling approaches.
3. To model the proportion of the peak's height reached by each climber, using a linear model, and to assess with a generalised additive model whether allowing non-linear relationships improves the model.

**Exploratory objective**

4. To model the number of members of an expedition who reach the summit, using a generalised linear model with Poisson family, and to identify expedition characteristics associated with a higher rate of summit success per member.

---

## 2. Study Hypothesis

The predictive performance of the model is measured by its discrimination: the area under the receiver operating characteristic curve (AUC) in the validation set. Good predictive ability is defined in advance as an AUC greater than 0.80.

Let AUC denote the true discrimination of the final prediction model for summit success, chosen as described in Section 5.4.2.

- **Null hypothesis (H₀):** AUC ≤ 0.80. The prediction model for summit success does not have good predictive ability.
- **Alternative hypothesis (H₁):** AUC > 0.80. The prediction model for summit success has good predictive ability.

This is a one-sided test at a significance level of α = 0.05. H₀ is rejected if the lower limit of the one-sided 95% confidence interval for the validation-set AUC is greater than 0.80. Equivalently, H₀ is rejected if the one-sided p-value from the test of AUC = 0.80 is less than 0.05 (see Section 5.4.3).

Secondary and exploratory objectives are addressed by estimation and are not tied to formal confirmatory hypotheses.

---

## 3. Data Source

### 3.1 Data Provenance

The data come from the **Himalayan Database**, a free, publicly available registry of mountaineering expeditions in the Nepal Himalaya maintained by a non-profit organisation (<https://himalayandatabase.com/downloads.html>). This study uses the most recent release of the database, which covers expeditions from 1905 to the Autumn–Winter season of 2025.

The database is distributed as a Windows application. Its data tables are stored as dBASE (.DBF) files, which can be read directly with standard statistical software (for example, R or Python) using the Windows-1252 character encoding, without running the application. Many fields are stored as numeric or letter codes. They are decoded into readable categories using the documentation supplied with the database before analysis.

### 3.2 Structure of the Data

The registry is organised in three relational tables:

| Level | Approximate records | Content |
|---|---|---|
| Climber | 92,800 | Demographic characteristics, role, use of supplemental oxygen, outcome (summit, injury, death) and maximum altitude reached for each climber on each expedition |
| Expedition | 11,700 | Peak, year, season, key dates, team size, number of hired staff, reason for ending the expedition, organising agency |
| Peak | Several hundred | Height, climbing status, and year and nationality of the first ascent |

The tables are linked through expedition and peak identifiers. For Objectives 1–3, the analysis data set is the climber-level table, with expedition-level and peak-level attributes attached to each record. For Objective 4, climber records are aggregated to the expedition level. The exact number of records is reported after data extraction.

### 3.3 Ethical Considerations

The registry is publicly available. No personal identifiers are used in the analysis, and no individual climber is reported. Ethics approval is not required for the secondary analysis of publicly available data.

---

## 4. Methods

### 4.1 Study Design

This is a retrospective study that develops and internally validates a prediction model using registry data, together with secondary regression analyses. The study will be reported following the TRIPOD+AI guideline for prediction model studies.

### 4.2 Study Population

**Inclusion criteria**
- Climbers recorded as members of an expedition to a peak in the Nepal Himalaya between 1905 and the Autumn–Winter season of 2025.

**Exclusion criteria**
- Objectives 1 and 2: records with a missing summit outcome.
- Objective 3: records with a missing maximum altitude reached or a missing peak height.
- Objective 4: expeditions with no recorded members.
- For each model, records with missing values in any predictor that model requires (complete-case analysis; see Section 4.5).

### 4.3 Outcome Measures

**Primary outcome (Objectives 1 and 2)**
- *Summit success*: a binary indicator of whether the climber reached the main summit of the target peak.

**Secondary outcome (Objective 3)**
- *Proportion of peak height reached*: the maximum altitude reached by the climber divided by the height of the peak, expressed as a percentage. Expressing altitude relative to the height of the peak makes climbs on peaks of different heights comparable.

**Exploratory outcome (Objective 4)**
- *Number of summiting members*: the number of members of an expedition who reached the main summit. The size of the team is used as the exposure (offset), so the model describes the rate of summit success per member.

**Descriptive outcomes only**
- Death and injury during the expedition. These events are expected to be rare, so they are reported descriptively and not modelled.

### 4.4 Candidate Predictors

Every variable in the registry that is known before or at the start of an expedition is a candidate predictor. Candidate predictors fall into three domains. The list below gives examples and is not exhaustive. The final set of predictors is chosen during model development (Section 5.4.2).

| Domain | Examples of candidate predictors | Planned handling |
|---|---|---|
| Climber | Age, sex, nationality, role on the expedition, hired staff status, planned use of supplemental oxygen | Continuous variables kept continuous; nationality and role grouped into broader categories |
| Expedition | Calendar year, season, team size, number of hired staff, organising agency | Categories with many levels grouped; "unknown" season treated as missing |
| Peak | Identity of the peak, peak height, years since first ascent | Peaks with few expeditions grouped as "other" |

For Objective 4, climber-level characteristics are summarised at the expedition level (for example, as proportions or means within the team).

**Variables excluded as predictors.** Some variables are only known during or after the summit attempt, so they cannot be used to make a prediction in advance. Including them would cause data leakage. They are excluded as predictors in all models:
- death and injury, and the cause and altitude of death or injury;
- the maximum altitude reached (used only as the outcome of Objective 3);
- the recorded reason for ending the expedition, which directly records whether the summit was reached;
- the dates on which the highest point was reached and on which the expedition ended, and any duration calculated from them.

### 4.5 Data Preparation

1. **Extraction and decoding:** the climber, expedition and peak tables are read from the database files, and coded fields are decoded into readable categories.
2. **Linkage:** expedition-level and peak-level attributes are joined to each climber record. For Objective 4, climber records are aggregated by expedition.
3. **Plausibility checks:** values outside plausible ranges (age, altitude, dates) are identified. Values that are clearly erroneous are set to missing. For Objective 3, recorded altitudes greater than the height of the peak are set to missing.
4. **Category grouping:** categorical variables with many levels are grouped into broader categories. Grouping rules are set using the training set only and then applied unchanged to the validation set.
5. **Missing data:** the main analysis uses complete cases. The proportion of missing values is reported for each variable, together with the number of records lost from each model. Multiple imputation by chained equations is planned as a sensitivity analysis.
6. **Data partitioning:** the data are randomly divided into a **training set (80%)** and a **validation set (20%)**, with stratification by the primary outcome. The division is made by expedition, so all climbers from the same expedition are in the same set. The same division is used for all objectives. All model fitting, predictor selection and hyperparameter tuning use the training set only, with 10-fold cross-validation grouped by expedition within the training set. The validation set is used once, to evaluate the final models. A fixed random seed is used for all random steps.

---

## 5. Data Analysis

### 5.1 General Settings: Statistical Inference and Multiplicity

The following settings apply to all analyses unless stated otherwise.

- All model fitting, predictor selection and hyperparameter tuning use the training set. All reported measures of predictive performance are estimated in the validation set.
- The primary hypothesis is a single, one-sided test at α = 0.05, so no adjustment for multiple comparisons is needed.
- Pairwise comparisons of model performance are adjusted with the Holm–Bonferroni procedure.
- All other tests are two-sided at α = 0.05 and are interpreted as hypothesis-generating.
- All confidence intervals are 95% confidence intervals.
- Effect sizes and confidence intervals are emphasised over p-values.

### 5.2 Descriptive Analysis

- Characteristics of the study population are summarised overall and by summit outcome. Continuous variables are summarised by means and standard deviations, or medians and interquartile ranges. Categorical variables are summarised by frequencies and percentages.
- The amount and pattern of missing data are reported for each variable.
- Characteristics of the training set and the validation set are compared, to confirm that the split produced comparable groups.
- Collinearity between candidate predictors is assessed with variance inflation factors.
- The distribution of the proportion of peak height reached (Objective 3) and of the number of summiting members per expedition (Objective 4) is described.

### 5.3 Statistical Models

The statistical models used in this study are listed below. Their specifications are described in the section for each objective (Sections 5.4–5.7).

| Statistical model | Outcome | Objective |
|---|---|---|
| Generalised linear model, binomial family (logistic regression) | Summit success | 1, 2 |
| Generalised additive model, binomial family | Summit success | 1, 2 |
| Support vector machine | Summit success | 1, 2 |
| Neural network | Summit success | 1, 2 |
| Linear model | Proportion of peak height reached | 3 |
| Generalised additive model, Gaussian family | Proportion of peak height reached | 3 |
| Generalised linear model, Poisson family | Number of summiting members per expedition | 4 |

### 5.4 Objective 1: Development and Validation of the Prediction Model for Summit Success

#### 5.4.1 Model Specification

Four modelling approaches of increasing complexity are developed on the training set:

- **Generalised linear model, binomial family (logistic regression):** logit link. Predictors are selected by LASSO or elastic-net penalisation. This model serves as the interpretable reference model.
- **Generalised additive model, binomial family:** logit link. Continuous predictors enter as penalised regression splines, with smoothness chosen by restricted maximum likelihood. This allows non-linear relationships while keeping the model interpretable.
- **Support vector machine:** radial basis function kernel. The cost and kernel width are tuned. Predicted probabilities are obtained by Platt scaling.
- **Neural network:** feed-forward network. The number of hidden layers and units, the weight decay or dropout rate, and the learning rate are tuned. Early stopping is used to prevent overfitting.

For the support vector machine and the neural network, continuous predictors are standardised and categorical predictors are one-hot encoded. Standardisation parameters are estimated in the training set and applied unchanged to the validation set.

#### 5.4.2 Model Development and Selection of the Final Model

- Each approach is tuned by grouped 10-fold cross-validation within the training set, with AUC as the criterion.
- The approaches are compared by their mean cross-validated AUC. The approach with the highest cross-validated AUC is chosen as the **final model**. Where the difference is small (less than 0.01), the more interpretable model is preferred.
- Each approach is refitted on the full training set with its tuned settings before evaluation on the validation set.

#### 5.4.3 Model Validation and Hypothesis Testing

All four models are evaluated on the validation set. The primary hypothesis is tested on the final model only.

**Discrimination (primary hypothesis)**
- The validation-set AUC is estimated with its 95% confidence interval, using DeLong's method. A bootstrap confidence interval with 2,000 resamples, drawn by expedition, is reported as a check.
- **Test of H₀:** the test statistic is *z* = (AUC − 0.80) / SE(AUC), where SE is the DeLong standard error. The one-sided p-value is 1 − Φ(*z*). H₀ is rejected if *p* < 0.05, which is equivalent to the lower limit of the one-sided 95% confidence interval being greater than 0.80.

**Calibration**
- Calibration plot of observed against predicted probabilities, with a smoothed curve.
- Calibration intercept (calibration-in-the-large) and calibration slope.
- Brier score.

**Classification performance**
- At a probability threshold chosen in the training set (for example, by maximising the Youden index), the following are reported: accuracy, sensitivity, specificity, positive and negative predictive values, and F1 score.
- These are compared with the no-information rate, which is the accuracy obtained by always predicting the more frequent outcome.

**Does complexity improve prediction?**
- The validation-set AUCs of the four models are compared in pairs with DeLong's test for correlated ROC curves. P-values are adjusted for the six pairwise comparisons with the Holm–Bonferroni procedure.
- Calibration and Brier scores are compared across the four models.
- Decision curve analysis is used to compare the net benefit of the models across a range of threshold probabilities.

### 5.5 Objective 2: Predictor Importance

- **Binomial GLM:** odds ratios with 95% confidence intervals are reported for the selected predictors.
- **Binomial GAM:** estimated smooth functions are presented graphically with 95% confidence bands. Effective degrees of freedom are reported for each smooth term, as an indication of non-linearity.
- **All four models:** permutation importance is computed on the validation set. It is defined as the decrease in AUC when the values of a predictor are randomly permuted, averaged over repeated permutations. Because it does not depend on the type of model, it allows direct comparison across approaches. SHAP (Shapley additive explanations) values may be computed for the support vector machine and the neural network.
- **Consistency across models:** predictors are ranked by importance within each model. Agreement between rankings is summarised with Spearman's rank correlation for each pair of models and Kendall's coefficient of concordance across all four models. Predictors that rank highly in all models are considered robust predictors of summit success.

### 5.6 Objective 3: Proportion of Peak Height Reached

- A multiple linear regression of the proportion of peak height reached on the candidate predictors is fitted on the training set. Regression coefficients are reported with 95% confidence intervals.
- Model assumptions are checked with residual-versus-fitted plots, normal quantile–quantile plots and influence diagnostics (Cook's distance).
- A generalised additive model with Gaussian family and identity link is fitted to the same data. Continuous predictors enter as penalised regression splines, with smoothness chosen by restricted maximum likelihood. It is compared with the linear model using AIC, an approximate F-test of the nested models and the effective degrees of freedom of the smooth terms.
- Both models are evaluated on the validation set with the root mean squared error, the mean absolute error and R².
- The outcome cannot exceed 100% and many climbers reach the summit, so its distribution is expected to be bounded and left-skewed. This is taken into account when interpreting residual diagnostics. A sensitivity analysis restricted to climbers who did not reach the summit describes how far below the summit unsuccessful climbers turned back.

### 5.7 Objective 4: Number of Summiting Members per Expedition

- A Poisson GLM with log link is fitted at the expedition level on the training set, with the logarithm of team size as an offset. Exponentiated coefficients are interpreted as rate ratios for summit success per member, and are reported with 95% confidence intervals.
- Overdispersion is assessed with the dispersion statistic (Pearson χ² divided by the residual degrees of freedom) and tested formally with the Cameron–Trivedi test. If overdispersion is present, the model is refitted as quasi-Poisson and negative binomial, and the fits are compared using AIC and randomised quantile residuals.
- Model fit is assessed with the residual deviance and by comparing observed and predicted counts in the validation set.

### 5.8 Sensitivity Analyses

1. **Missing data:** the final model is redeveloped and revalidated after multiple imputation of missing predictors.
2. **Hired staff:** model performance is evaluated separately for hired staff and for other climbers, because the two groups may differ systematically.
3. **Calendar period:** model performance in the validation set is evaluated in subgroups defined by calendar period, to assess whether it is stable over time.

### 5.9 Software

The analyses will be done in R (packages for reading dBASE files, generalised linear models, generalised additive models, penalised regression, support vector machines and neural networks) or Python (equivalent statistical and machine learning libraries). Package versions will be recorded.


---

## 6. Limitations

1. **Internal validation only.** The model is validated on a random 20% of the same registry. Performance may be lower in other settings or in future seasons, which an external validation would be needed to confirm.
2. **Predictor availability.** The registry does not record several factors that probably influence summit success, such as climbing experience, physical fitness, acclimatisation and weather conditions on the summit day. This may limit the model's discrimination.
3. **Prediction is not causation.** The predictors that contribute most to the models are not necessarily causes of summit success, and their importance should not be interpreted causally.
4. **Interpretability of complex models.** The support vector machine and the neural network do not provide directly interpretable parameters. Measures of predictor importance summarise their behaviour but do not fully describe how they reach their predictions.
5. **Non-independence of observations.** Climbers on the same expedition share weather, route, leadership and logistics, so their outcomes are correlated. Dividing the data and running cross-validation by expedition prevents information leakage, but confidence intervals for climber-level estimates may still be too narrow.
6. **Missing data.** Some variables may be incompletely recorded, in particular the maximum altitude reached, which is the basis of the Objective 3 outcome. If the data are not missing completely at random, complete-case estimates may be biased.
7. **Data extraction and decoding.** The original database stores many fields as codes. Errors in extracting or decoding these fields could cause misclassification. Decoding is checked against the database documentation.
8. **Bounded outcome in Objective 3.** The proportion of peak height reached is capped at 100%, which conflicts with the assumptions of the linear model. Estimates from the linear model should be interpreted as approximations.
9. **Aggregation in Objective 4.** Summarising climber characteristics at the expedition level loses information about individual climbers. Associations at the expedition level may not hold for individual climbers.
10. **Data quality and reporting bias.** Historical records, particularly from the early twentieth century, may be incomplete or inaccurate. Summit claims are partly self-reported, and some are disputed, which may cause misclassification of the outcome.
11. **Changes over time.** Climbing practice has changed greatly across the study period. A model developed on the full period may not reflect current conditions.
12. **Choice of performance threshold.** The 0.80 threshold for good discrimination is a common convention but is arbitrary. A model with lower discrimination may still be useful, depending on its intended use.
13. **Generalisability.** The findings apply to expeditions in the Nepal Himalaya and may not generalise to other mountain ranges.

---

## 7. References

1. The Himalayan Database: The Expedition Archives of Elizabeth Hawley. Release covering 1905 to Autumn–Winter 2025. <https://himalayandatabase.com>
2. Collins GS, Moons KGM, Dhiman P, et al. TRIPOD+AI statement: updated guidance for reporting clinical prediction models that use regression or machine learning methods. *BMJ*. 2024;385:e078378.
3. Steyerberg EW. *Clinical Prediction Models: A Practical Approach to Development, Validation, and Updating*. 2nd ed. Cham: Springer; 2019.
4. DeLong ER, DeLong DM, Clarke-Pearson DL. Comparing the areas under two or more correlated receiver operating characteristic curves: a nonparametric approach. *Biometrics*. 1988;44(3):837–845.
5. Wood SN. *Generalized Additive Models: An Introduction with R*. 2nd ed. Boca Raton, FL: CRC Press; 2017.
6. Platt J. Probabilistic outputs for support vector machines and comparisons to regularized likelihood methods. In: Smola AJ, Bartlett P, Schölkopf B, Schuurmans D, eds. *Advances in Large Margin Classifiers*. Cambridge, MA: MIT Press; 1999:61–74.
7. Vickers AJ, Elkin EB. Decision curve analysis: a novel method for evaluating prediction models. *Med Decis Making*. 2006;26(6):565–574.
8. Cameron AC, Trivedi PK. Regression-based tests for overdispersion in the Poisson model. *J Econom*. 1990;46(3):347–364.
