# Prediction and Temporal Trends of Summit Success and Mortality on Nepal Himalaya Expeditions, 1905–2025. A Retrospective Study Protocol

#### *HSLU Applied Machine Learning and Predictive Modeling 1, Fall 2026*

**Protocol version:** 1.0

**Date:** 10 November 2026

**Authors:** Hsiang-Chi Wang, Michael Engel, Leonie Mueller

------------------------------------------------------------------------

## 1. Introduction

### 1.1 Background

High-altitude mountaineering in the Nepal Himalaya has been documented systematically since the early twentieth century. Records begun by the journalist Elizabeth Hawley and maintained today in the Himalayan Database form one of the most complete longitudinal registries of expedition mountaineering, and the database has been the basis of most quantitative research on Himalayan climbing.

Over the last decades, the practice of Himalayan climbing has changed substantially. Commercial guiding has become common, supplemental oxygen is widely used, weather forecasting has improved, and many teams are large and supported by hired high-altitude staff. On Mount Everest, the proportion of first-time climbers who reached the summit roughly doubled between 1990–2005 and 2006–2019, while the death rate remained at about 1% [[1]](#ref-1). Earlier work on Everest showed that summit success declines with age from about 40 years onwards, that the risk of death increases at older ages, and that men and women have similar success rates [[2]](#ref-2). Most deaths of climbers above 8,000 m occur during the descent from the summit [[3]](#ref-3). The circumstances of death differ between paying expedition members and hired high-altitude staff: hired staff die mostly from objective hazards such as avalanches during route preparation, whereas members die mostly during the summit bid and descent [[4]](#ref-4). Commercial expeditions do not appear to be more dangerous than traditional ones [[5]](#ref-5). Reported mortality estimates vary considerably between studies, depending on the peaks, periods and populations considered [[6]](#ref-6).

Most of this evidence comes from Mount Everest or from the highest peaks, and from analyses that describe associations rather than predict individual outcomes. Three questions remain open across the full range of Nepal Himalaya peaks: whether a climber's chance of reaching the summit can be predicted accurately from information available before the expedition; whether the increase in summit success has been shared equally by all groups of climbers; and whether higher success has come at the price of a higher risk of death. In addition, if commercial logistics have made climbing more efficient, expeditions should reach the summit more quickly than in the past.

### 1.2 Research Purpose

The Himalayan Database is a non-profit registry that records every mountaineering expedition to the peaks of the Nepal Himalaya. It continues the archive compiled by Elizabeth Hawley from 1963 onwards and includes expeditions documented retrospectively back to 1905. For each climber, the registry records their characteristics, the expedition they joined, the peak attempted and the outcome of the expedition, including summit success and death. This study uses the most recent release of the registry, covering expeditions from 1905 to the Autumn–Winter season of 2025. The study population consists of all climbers recorded as members of an expedition to a peak in the Nepal Himalaya during this period, including hired expedition staff, and the expeditions they belonged to. In this analysis, we will use the Himalayan Database to: 1) build and validate a prediction model for summit success in climbers on Himalayan expeditions; 2) describe how the probability of summit success has changed over time and whether the change differs between groups of climbers; 3) describe how the death rate on expeditions has changed over time, and compare it with the trend in summit success; and 4) identify the factors associated with the time expeditions take to reach the summit.

### 1.3 Objectives

The objectives follow one line of argument. Objective 1 asks whether reaching the summit can be predicted. Objective 2 asks how the chance of reaching the summit has changed over time, and for whom. Objective 3 asks whether this success has come at the price of more deaths. Objective 4 asks whether expeditions have become more efficient, by identifying the factors associated with how long they take to reach the summit.

**Primary objective**

1.  To develop and validate a prediction model for summit success in climbers on Nepal Himalaya expeditions, and to compare the predictive performance of models of increasing flexibility: a generalised linear model with binomial family (logistic regression), a generalised additive model, a support vector machine and a neural network.

**Secondary objectives**

2.  To describe how the probability of summit success has changed over calendar time, and to assess whether the trend differs between groups of climbers, using a generalised additive model.
3.  To describe how the death rate on expeditions has changed over calendar time, separately for expedition members and hired staff, and to compare it with the trend in summit success, using a generalised linear model with Poisson family.
4.  To identify the factors associated with the number of days an expedition takes to reach the summit, using a linear model, and to assess with a generalised additive model whether these associations are non-linear.

------------------------------------------------------------------------

## 2. Study Hypothesis

The predictive performance of the model for summit success is measured by its discrimination: the area under the receiver operating characteristic curve (AUC) in the validation set. Good predictive ability is defined in advance as an AUC greater than 0.80.

Let AUC denote the true discrimination of the final prediction model for summit success, chosen as described in Section 5.4.2.

- **Null hypothesis (H₀):** AUC ≤ 0.80. The prediction model for summit success does not have good predictive ability.
- **Alternative hypothesis (H₁):** AUC \> 0.80. The prediction model for summit success has good predictive ability.

This is a one-sided test at a significance level of α = 0.05. H₀ is rejected if the lower limit of the one-sided 95% confidence interval for the validation-set AUC is greater than 0.80. Equivalently, H₀ is rejected if the one-sided p-value from the test of AUC = 0.80 is less than 0.05 (see Section 5.4.3).

Secondary objectives are addressed by estimation and are not tied to formal confirmatory hypotheses.

------------------------------------------------------------------------

## 3. Data Source

### 3.1 Data Provenance

The data come from the **Himalayan Database**, a free, publicly available registry of mountaineering expeditions in the Nepal Himalaya maintained by a non-profit organisation [[7]](#ref-7) (<https://himalayandatabase.com/downloads.html>). This study uses the most recent release of the database, which covers expeditions from 1905 to the Autumn–Winter season of 2025.

The database is distributed as a Windows application. Its data tables are stored as dBASE (.DBF) files, which can be read directly with standard statistical software (for example, R or Python) using the Windows-1252 character encoding, without running the application. Many fields are stored as numeric or letter codes. They are decoded into readable categories using the documentation supplied with the database before analysis.

### 3.2 Structure of the Data

The registry is organised in three relational tables:

| Level | Approximate records | Content |
|------------------------|------------------------|------------------------|
| Climber | 94,999 | Demographic characteristics, role, use of supplemental oxygen, outcome (summit, injury, death) and maximum altitude reached for each climber on each expedition |
| Expedition | 11,854 | Peak, year, season, key dates (arrival at base camp, summit, end of expedition), team size, number of hired staff, number of deaths among members and hired staff, reason for ending the expedition, organising agency |
| Peak | 503 | Height, climbing status, and year and nationality of the first ascent |

The tables are linked through expedition and peak identifiers. The exact number of records is reported after data extraction. Two analysis data sets are built:

- **Climber-level data set (Objectives 1 and 2):** one record per climber per expedition, with expedition-level and peak-level attributes attached to each record.
- **Expedition-level data set (Objectives 3 and 4):** one record per expedition, with peak-level attributes attached and climber-level characteristics summarised within the expedition.

### 3.3 Ethical Considerations

The registry is publicly available. No personal identifiers are used in the analysis, and no individual climber is reported. Ethics approval is not required for the secondary analysis of publicly available data.

------------------------------------------------------------------------

## 4. Methods

### 4.1 Study Design

This is a retrospective registry study with two components: the development and internal validation of a prediction model (Objective 1), and the description of temporal trends and associations (Objectives 2–4). The prediction model will be reported following the TRIPOD+AI guideline for prediction model studies [[8]](#ref-8), and its development and validation follow established principles for prediction modelling [[9]](#ref-9).

### 4.2 Study Population

**Inclusion criteria** - Climbers recorded as members of an expedition to a peak in the Nepal Himalaya between 1905 and the Autumn–Winter season of 2025, including hired expedition staff, and the expeditions they belonged to.

**Exclusion criteria** - Objectives 1 and 2: climber records with a missing summit outcome. - Objective 3: expeditions with no recorded members or hired staff. - Objective 4: expeditions on which no climber reached the main summit, and expeditions with a missing date of arrival at base camp or a missing summit date. - For each model, records with missing values in any predictor that model requires (complete-case analysis; see Section 4.5).

### 4.3 Outcome Measures

**Primary outcome (Objectives 1 and 2)** - *Summit success*: a binary indicator of whether the climber reached the main summit of the target peak.

**Secondary outcome (Objective 3)** - *Number of deaths*: the number of people who died on an expedition, counted separately for expedition members and for hired staff. The number of members and the number of hired staff on the expedition are used as the exposure (offset), so the model describes the death rate per person.

**Secondary outcome (Objective 4)** - *Time to summit*: the number of days from the expedition's arrival at base camp to the date on which the main summit was first reached.

**Descriptive outcomes only** - Injuries during the expedition, and the cause and altitude of death or injury. These are reported descriptively and not modelled. - The ratio of deaths to successful summit ascents in each calendar period, as a simple summary of the balance between success and risk.

### 4.4 Candidate Predictors

Every variable in the registry that is known before or at the start of an expedition is a candidate predictor. Candidate predictors fall into three domains. The list below gives examples and is not exhaustive. The final set of predictors for the prediction model is chosen during model development (Section 5.4.2).

| Domain | Examples of candidate predictors | Planned handling |
|------------------------|------------------------|------------------------|
| Climber | Age, sex, nationality, role on the expedition, hired staff status, planned use of supplemental oxygen | Continuous variables kept continuous; nationality and role grouped into broader categories |
| Expedition | Calendar year, season, team size, number of hired staff, organising agency, route | Categories with many levels grouped; "unknown" season treated as missing |
| Peak | Identity of the peak, peak height, years since first ascent | Peaks with few expeditions grouped as "other" |

For the expedition-level analyses (Objectives 3 and 4), climber-level characteristics are summarised within each expedition (for example, as proportions or means).

**Variables excluded as predictors.** Some variables are only known during or after the summit attempt, so they cannot be used to make a prediction in advance. Including them would cause data leakage or reverse causation. They are excluded as predictors in all models, even where they serve as outcomes: - summit success of other members of the same expedition; - death and injury, and the cause and altitude of death or injury; - the maximum altitude reached; - the recorded reason for ending the expedition, which directly records whether the summit was reached; - the dates on which the summit or the highest point was reached and on which the expedition ended, and any duration calculated from them.

### 4.5 Data Preparation

1.  **Extraction and decoding:** the climber, expedition and peak tables are read from the database files, and coded fields are decoded into readable categories.
2.  **Linkage and aggregation:** expedition-level and peak-level attributes are joined to each climber record. For the expedition-level data set, climber records are aggregated by expedition.
3.  **Plausibility checks:** values outside plausible ranges (age, altitudes, dates) are identified. Values that are clearly erroneous are set to missing. For Objective 4, a summit date earlier than the date of arrival at base camp is set to missing.
4.  **Category grouping:** categorical variables with many levels are grouped into broader categories. Grouping rules are set using the training set only and then applied unchanged to the validation set.
5.  **Missing data:** the main analysis uses complete cases. The proportion of missing values is reported for each variable, together with the number of records lost from each model. Multiple imputation by chained equations is planned as a sensitivity analysis.
6.  **Data partitioning (Objective 1):** expeditions are randomly divided into a **training set (80%)** and a **validation set (20%)**, with stratification by whether at least one climber on the expedition reached the summit. All climbers from the same expedition are in the same set. All model fitting, predictor selection and hyperparameter tuning use the training set only, with 10-fold cross-validation grouped by expedition within the training set. The validation set is used once, to evaluate the final models. A fixed random seed is used for all random steps.

------------------------------------------------------------------------

## 5. Data Analysis

### 5.1 General Settings: Statistical Inference and Multiplicity

The following settings apply to all analyses unless stated otherwise.

- **Prediction objective (1):** all model fitting, predictor selection and hyperparameter tuning use the training set. All reported measures of predictive performance are estimated in the validation set.
- **Estimation objectives (2–4):** these aim at estimation rather than prediction, so the models are fitted on the full data set.
- **Clustering:** climbers on the same expedition are not independent, and expeditions on the same peak may be similar. In Objective 1, this is handled by dividing the data and running cross-validation by expedition. In the other objectives, it is handled by a random effect for expedition (Objective 2), by standard errors clustered by expedition (Objective 3), or by standard errors clustered by peak (Objective 4).
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
- Crude summit success rates, death rates (for members and hired staff) and the ratio of deaths to successful ascents are tabulated by calendar decade.
- The distribution of the time to summit (Objective 4) is described.

### 5.3 Statistical Models

The statistical models used in this study are listed below. Their specifications are described in the section for each objective (Sections 5.4–5.7).

| Statistical model | Outcome | Objective |
|------------------------|------------------------|------------------------|
| Generalised linear model, binomial family (logistic regression) | Summit success | 1 |
| Generalised additive model, binomial family | Summit success | 1, 2 |
| Support vector machine | Summit success | 1 |
| Neural network | Summit success | 1 |
| Generalised linear model, Poisson family | Number of deaths | 3 |
| Linear model | Time to summit | 4 |
| Generalised additive model, Gaussian family | Time to summit | 4 |

### 5.4 Objective 1: Development and Validation of the Prediction Model for Summit Success

#### 5.4.1 Model Specification

Four modelling approaches of increasing flexibility are developed on the training set. Each produces a predicted probability of summit success for each climber.

- **Generalised linear model, binomial family (logistic regression):** logit link. Predictors are selected by LASSO or elastic-net penalisation. This model serves as the interpretable reference model.
- **Generalised additive model, binomial family:** logit link. Continuous predictors enter as penalised regression splines, with smoothness chosen by restricted maximum likelihood [[11]](#ref-11). This allows non-linear relationships while keeping the model interpretable.
- **Support vector machine:** radial basis function kernel. The cost and kernel width are tuned. The support vector machine is a classifier: it returns a decision score (the signed distance of a climber from the boundary separating the two outcomes) rather than a probability. Its decision scores are converted to predicted probabilities by Platt scaling [[14]](#ref-14), which fits a logistic regression of the outcome on the decision score. To avoid overfitting, the Platt scaling is fitted on out-of-fold decision scores from cross-validation within the training set, never on the validation set.
- **Neural network:** feed-forward network with a sigmoid output unit, so that it returns a predicted probability directly. The number of hidden layers and units, the weight decay or dropout rate, and the learning rate are tuned. Early stopping is used to prevent overfitting.

For the support vector machine and the neural network, continuous predictors are standardised and categorical predictors are one-hot encoded. Standardisation parameters are estimated in the training set and applied unchanged to the validation set.

#### 5.4.2 Model Development and Selection of the Final Model

- Each approach is tuned by grouped 10-fold cross-validation within the training set, with AUC as the criterion.
- The approaches are compared by their mean cross-validated AUC. The approach with the highest cross-validated AUC is chosen as the **final model**. Where the difference is small (less than 0.01), the more interpretable model is preferred.
- Each approach is refitted on the full training set with its tuned settings before evaluation on the validation set.

#### 5.4.3 Model Validation and Hypothesis Testing

All four models are evaluated on the validation set. The primary hypothesis is tested on the final model only.

**Discrimination (primary hypothesis)** - The validation-set AUC is estimated with its 95% confidence interval, using DeLong's method [[10]](#ref-10). A bootstrap confidence interval with 2,000 resamples, drawn by expedition, is reported as a check. - **Test of H₀:** the test statistic is *z* = (AUC − 0.80) / SE(AUC), where SE is the DeLong standard error. The one-sided p-value is 1 − Φ(*z*). H₀ is rejected if *p* \< 0.05, which is equivalent to the lower limit of the one-sided 95% confidence interval being greater than 0.80.

**Calibration** - Calibration plot of observed against predicted probabilities, with a smoothed curve. - Calibration intercept (calibration-in-the-large) and calibration slope. - Brier score.

**Classification performance (supplementary)** - At a probability threshold chosen in the training set (for example, by maximising the Youden index), the following are reported: accuracy, sensitivity, specificity, positive and negative predictive values, and F1 score. - These are compared with the no-information rate, which is the accuracy obtained by always predicting the more frequent outcome.

**Does flexibility improve prediction?** - The validation-set AUCs of the four models are compared in pairs with DeLong's test for correlated ROC curves. P-values are adjusted for the six pairwise comparisons with the Holm–Bonferroni procedure. - Calibration and Brier scores are compared across the four models. Because the probabilities of the support vector machine are obtained after fitting, by Platt scaling, its calibration is of particular interest. - Decision curve analysis is used to compare the net benefit of the models across a range of threshold probabilities [[12]](#ref-12).

#### 5.4.4 Contribution of Predictors

- **Binomial GLM:** odds ratios with 95% confidence intervals are reported for the selected predictors.
- **Binomial GAM:** estimated smooth functions are presented graphically with 95% confidence bands.
- **All four models:** permutation importance is computed on the validation set, defined as the decrease in AUC when the values of a predictor are randomly permuted, averaged over repeated permutations. Predictors that rank highly in all four models are reported as robust predictors of summit success.

### 5.5 Objective 2: Temporal Trends in Summit Success

#### 5.5.1 Model Specification

A generalised additive model with binomial family and logit link is fitted to the full climber-level data set:

- **Time trend:** calendar year enters as a penalised regression spline, so that the shape of the trend is estimated from the data.
- **Differences between groups:** the trend is allowed to differ between groups of climbers by fitting a separate smooth function of calendar year for each group (a factor-by-smooth interaction). Groups are defined by age (for example, under 40, 40–59 and 60 years or older), by sex, and by role (expedition member or hired staff). One model is fitted for each grouping.
- **Adjustment:** the models are adjusted for other candidate predictors, so that the trends are not explained only by changes in which peaks are climbed or in the mix of climbers.
- **Clustering:** a random intercept for expedition is included as a random-effect smooth term.

Smoothness is chosen by restricted maximum likelihood.

#### 5.5.2 Analysis

- The estimated probability of summit success over calendar year is plotted for each group, with 95% confidence bands, holding other predictors at reference values.
- Whether the trend differs between groups is assessed by comparing the model with group-specific smooths against a model with one common smooth, using AIC and an approximate likelihood-ratio (χ²) test.
- The change in the probability of summit success between defined periods (for example, before and after 2006, following earlier work [[1]](#ref-1)) is reported for each group, with 95% confidence intervals.

### 5.6 Objective 3: Temporal Trends in Mortality

#### 5.6.1 Model Specification

The expedition-level data set is arranged with two records per expedition: one for expedition members and one for hired staff. Each record contains the number of deaths in that group and the number of people at risk in that group. Records with no people at risk are excluded.

A generalised linear model with Poisson family and log link is fitted to the full data set:

- **Offset:** the logarithm of the number of people at risk, so that exponentiated coefficients are rate ratios (deaths per person).
- **Time trend:** calendar year, entered as a natural cubic spline with a small number of degrees of freedom (for example, 3–4), which allows a non-linear trend within the generalised linear model.
- **Role:** expedition member or hired staff, and its interaction with calendar year, to assess whether the trend in mortality differs between the two groups.
- **Adjustment:** other candidate predictors at the expedition and peak level.
- **Clustering:** the two records from the same expedition are correlated, so standard errors are clustered by expedition (sandwich estimator).

#### 5.6.2 Analysis

- Rate ratios with 95% confidence intervals are reported. The estimated death rate over calendar year is plotted for members and hired staff, with 95% confidence bands.
- Overdispersion is assessed with the dispersion statistic (Pearson χ² divided by the residual degrees of freedom) and tested formally with the Cameron–Trivedi test [[13]](#ref-13). If overdispersion is present, the model is refitted as quasi-Poisson and negative binomial.
- Because deaths are rare, many records are expected to have zero deaths. The observed number of zeros is compared with the number predicted by the model. If there are clearly more zeros than expected, a zero-inflated Poisson or zero-inflated negative binomial model is fitted, and the fits are compared using AIC and randomised quantile residuals.
- **Comparison with the success trend:** the estimated death rate and the estimated probability of summit success from Objective 2 are plotted on the same calendar-year axis. Together with the ratio of deaths to successful ascents (Section 5.2), this shows whether increasing success has been accompanied by increasing, stable or decreasing mortality.

### 5.7 Objective 4: Factors Associated with Time to Summit

#### 5.7.1 Model Specification

The models are fitted to the full expedition-level data set, restricted to expeditions that reached the summit (Section 4.2).

- **Linear model:** multiple linear regression of time to summit on the candidate predictors. This is the main model. All candidate predictors are entered together, after grouping of categories with many levels, so that each coefficient is adjusted for the other factors.
- **Generalised additive model, Gaussian family:** identity link. The same predictors are entered, but continuous predictors (for example, calendar year and peak height) enter as penalised regression splines, with smoothness chosen by restricted maximum likelihood. This shows whether the associations are non-linear.
- **Outcome scale:** time to summit is expected to be right-skewed. If so, it is log-transformed, and exponentiated coefficients are interpreted as the percentage difference in time to summit.
- **Clustering:** expeditions on the same peak and route may take similar times. Peak is included as a predictor, and standard errors are clustered by peak.

#### 5.7.2 Analysis

- Regression coefficients from the linear model are reported with 95% confidence intervals, as the adjusted difference in days (or percentage difference) associated with each factor.
- Model assumptions are checked with residual-versus-fitted plots, normal quantile–quantile plots and influence diagnostics (Cook's distance). Collinearity is assessed with variance inflation factors.
- The generalised additive model is compared with the linear model using AIC, an approximate F-test of the nested models and the effective degrees of freedom of the smooth terms. Estimated smooth functions are presented graphically with 95% confidence bands.
- The adjusted time to summit over calendar year is plotted from the generalised additive model, to show whether expeditions have reached the summit faster over time.
- The proportion of variation explained (adjusted R²) is reported for both models.

### 5.8 Sensitivity Analyses

1.  **Missing data:** the final model of Objective 1 is redeveloped and revalidated, and the models of Objectives 2–4 are refitted, after multiple imputation of missing predictors.
2.  **Clustering in Objective 1:** the binomial GLM and GAM are refitted with a random intercept for expedition. Predictions for the validation set are made with the random effect set to zero, because the effect of a new expedition is unknown in advance.
3.  **Hired staff:** in Objective 1, model performance is evaluated separately for hired staff and for expedition members.
4.  **Calendar period:** in Objective 1, model performance in the validation set is evaluated in subgroups defined by calendar period, to assess whether it is stable over time.
5.  **Recording period:** Objectives 2 and 3 are repeated restricted to expeditions from 1970 onwards, when records were collected systematically and are expected to be more complete.

### 5.9 Software

The analyses will be done in R (packages for reading dBASE files, generalised linear and additive models, penalised regression, count models, support vector machines and neural networks) or Python (equivalent statistical and machine learning libraries). Package versions will be recorded.

------------------------------------------------------------------------

## 6. Limitations

1.  **Internal validation only.** The prediction model is validated on a random 20% of the same registry. Performance may be lower in other settings or in future seasons, which an external validation would be needed to confirm.
2.  **Predictor availability.** The registry does not record several factors that probably influence summit success, mortality and time to summit, such as climbing experience, physical fitness, acclimatisation and weather conditions on the summit day. This may limit the performance of the models.
3.  **Prediction and description are not causation.** Predictors that contribute most to the models, and differences in trends between groups, are associations. They should not be interpreted as causal effects.
4.  **Confounding of time trends.** Over time, the peaks climbed, the routes used and the mix of climbers have changed. Adjustment for measured predictors reduces but does not remove this confounding, so the trends in Objectives 2 and 3 may partly reflect changes in who climbs where.
5.  **Non-independence of observations.** Climbers on the same expedition share weather, route, leadership and logistics, and expeditions on the same peak share its hazards. The methods used (grouped data splitting, random effects and clustered standard errors) address the clustering by expedition but not fully the clustering by peak.
6.  **Rare events.** Deaths are rare, so estimates of death rates and their trends are imprecise, particularly for subgroups and for periods with few expeditions.
7.  **Selection in Objective 4.** Time to summit is defined only for expeditions that reached the summit, so the model does not apply to unsuccessful expeditions. Dates of arrival at base camp and of the summit may also be missing for some expeditions.
8.  **Flexible models.** The support vector machine and the neural network do not provide directly interpretable parameters. Permutation importance summarises their behaviour but does not fully describe how they reach their predictions. The support vector machine does not estimate probabilities itself, so its probabilities depend on the Platt scaling step and may be less well calibrated than those of the other models.
9.  **Missing data.** Some variables may be incompletely recorded. If the data are not missing completely at random, complete-case estimates may be biased.
10. **Data extraction and decoding.** The original database stores many fields as codes. Errors in extracting or decoding these fields could cause misclassification. Decoding is checked against the database documentation.
11. **Data quality and reporting bias.** Historical records, particularly from before systematic recording began, may be incomplete or inaccurate. Summit claims are partly self-reported, and some are disputed. Deaths of hired staff may have been recorded less completely in earlier periods.
12. **Choice of performance threshold.** The 0.80 threshold for good discrimination is a common convention but is arbitrary. A model with lower discrimination may still be useful, depending on its intended use.
13. **Generalisability.** The findings apply to expeditions in the Nepal Himalaya and may not generalise to other mountain ranges.

------------------------------------------------------------------------

## 7. References

1.  <a id="ref-1"></a>Huey RB, Carroll C, Salisbury R, Wang JL. Mountaineers on Mount Everest: effects of age, sex, experience, and crowding on rates of success and death. *PLoS One*. 2020;15(8):e0236919. <https://doi.org/10.1371/journal.pone.0236919>
2.  <a id="ref-2"></a>Huey RB, Salisbury R, Wang JL, Mao M. Effects of age and gender on success and death of mountaineers on Mount Everest. *Biol Lett*. 2007;3(5):498–500. <https://pmc.ncbi.nlm.nih.gov/articles/PMC2391200/>
3.  <a id="ref-3"></a>Firth PG, Zheng H, Windsor JS, et al. Mortality on Mount Everest, 1921–2006: descriptive study. *BMJ*. 2008;337:a2654. <https://doi.org/10.1136/bmj.a2654>
4.  <a id="ref-4"></a>Dodge RE, Zheng H, Windsor JS, et al. Updates to mortality on Mount Everest: 1921–2024. Author accepted manuscript. <https://knowledge.lancashire.ac.uk/id/eprint/59218/>
5.  <a id="ref-5"></a>Westhoff JL, Koepsell TD, Littell CT. Effects of experience and commercialisation on survival in Himalayan mountaineering: retrospective cohort study. *BMJ*. 2012;344:e3782. <https://doi.org/10.1136/bmj.e3782>
6.  <a id="ref-6"></a>Weinbruch S, Nordby KC. Fatalities in high altitude mountaineering: a review of quantitative risk estimates. *High Alt Med Biol*. 2013;14(4):346–359. <https://pubmed.ncbi.nlm.nih.gov/24377342/>
7.  <a id="ref-7"></a>The Himalayan Database: The Expedition Archives of Elizabeth Hawley. Release covering 1905 to Autumn–Winter 2025. <https://himalayandatabase.com>
8.  <a id="ref-8"></a>Collins GS, Moons KGM, Dhiman P, et al. TRIPOD+AI statement: updated guidance for reporting clinical prediction models that use regression or machine learning methods. *BMJ*. 2024;385:e078378. <https://doi.org/10.1136/bmj-2023-078378>
9.  <a id="ref-9"></a>Steyerberg EW. *Clinical Prediction Models: A Practical Approach to Development, Validation, and Updating*. 2nd ed. Cham: Springer; 2019. <https://doi.org/10.1007/978-3-030-16399-0>
10. <a id="ref-10"></a>DeLong ER, DeLong DM, Clarke-Pearson DL. Comparing the areas under two or more correlated receiver operating characteristic curves: a nonparametric approach. *Biometrics*. 1988;44(3):837–845. <https://doi.org/10.2307/2531595>
11. <a id="ref-11"></a>Wood SN. *Generalized Additive Models: An Introduction with R*. 2nd ed. Boca Raton, FL: CRC Press; 2017. <https://doi.org/10.1201/9781315370279>
12. <a id="ref-12"></a>Vickers AJ, Elkin EB. Decision curve analysis: a novel method for evaluating prediction models. *Med Decis Making*. 2006;26(6):565–574. <https://doi.org/10.1177/0272989X06295361>
13. <a id="ref-13"></a>Cameron AC, Trivedi PK. Regression-based tests for overdispersion in the Poisson model. *J Econom*. 1990;46(3):347–364. [https://doi.org/10.1016/0304-4076(90)90014-K](https://doi.org/10.1016/0304-4076(90)90014-K){.uri}
14. <a id="ref-14"></a>Platt J. Probabilistic outputs for support vector machines and comparisons to regularized likelihood methods. In: Smola AJ, Bartlett P, Schölkopf B, Schuurmans D, eds. *Advances in Large Margin Classifiers*. Cambridge, MA: MIT Press; 1999:61–74. <https://scholar.google.com/scholar?q=Probabilistic+outputs+for+support+vector+machines+and+comparisons+to+regularized+likelihood+methods>
