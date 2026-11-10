# ==============================================================================
# Project:    Applied Machine Learning and Predictive Modeling 1 - Group Project
# Purpose:    Data cleaning
# Developer:  Hsiang-Chi Wang
# ==============================================================================

# ==== Setup ====
library(foreign)
library(dplyr)
library(stringr)
library(forcats)
library(tidyr)
library(here)

set.seed(3535)

out_dir <- here("Analysis data")

# ==== Read dbf files ====
read_him <- function(file) {
  path <- file.path(here("Raw data", "Himalayan Database", "HIMDATA"), file)
  df <- read.dbf(path, as.is = TRUE)         
  names(df) <- tolower(names(df))
  df %>%
    mutate(across(where(is.character),
                  ~ str_trim(iconv(.x, from = "CP1252", to = "UTF-8"))),
           across(where(is.character), ~ na_if(.x, "")))
}

exped   <- read_him("exped.DBF")
members <- read_him("members.DBF")
peaks <- read_him("peaks.DBF")

## ---- Check raw data ----
# Check duplicate records, missing values, and year range
sum(duplicated(exped$expid))                       
sum(duplicated(members[, c("expid", "membid")]))   
sum(is.na(exped$expid))  
sum(is.na(exped$year))
range(exped$year, na.rm = TRUE)

## ---- Flow of records (TRIPOD+AI) ----
# Every inclusion/exclusion step adds a row, so the number of records removed
# at each step can be reported.
flow <- tibble(data = character(), step = character(),
               n_records = integer(), n_removed = integer())
# new_unit = TRUE when the records change meaning (expeditions -> groups),
# so "removed" is not computed for that step
log_n <- function(df, data, step, new_unit = FALSE) {
  force(df)   # run earlier steps of a pipe first, so they log in order
  prev <- flow$n_records[flow$data == data]
  n_prev <- if (length(prev) > 0) tail(prev, 1) else nrow(df)
  flow <<- add_row(flow, data = data, step = step, n_records = nrow(df),
                   n_removed = if (new_unit) NA_integer_ else n_prev - nrow(df))
  invisible(df)
}


# ==== Data cleaning ====
## ---- Select variables used for the analysis ----
members_cln <- members %>%
  select(expid, membid, peakid, myear, mseason, sex, age, yob, calcage, citizen,
         status, leader, deputy, bconly, nottobc, support, disabled, hired,
         sherpa, tibetan, msuccess, mclaimed, mdisputed, msolo, mperhighpt,
         mo2used, mo2none, mo2climb, mo2descent, mo2sleep, mo2medical,
         death, deathtype, deathclass, ams, weather, injury, injurytype)

exped_cln <- exped %>%
  select(expid, peakid, year, season, host, nation, agency, totmembers,
         smtmembers, mdeaths, tothired, smthired, hdeaths, nohired, o2used,
         o2none, smtdays, termreason, bcdate, smtdate, smttime, termdate,
         comrte, stdrte)

peaks_cln <- peaks %>%
  select(peakid, pkname, heightm, himal, region, open, pstatus, pyear)

## ---- Convert variable type ----
exped_cln <- exped_cln %>%
  mutate(across(c(year, season, host, totmembers, smtmembers, mdeaths,
                  tothired, smthired, hdeaths, smtdays, termreason),
                as.numeric))

members_cln <- members_cln %>%
  mutate(across(c(myear, mseason, age, yob, calcage, mperhighpt,
                  deathtype, deathclass, injurytype),
                as.numeric))

peaks_cln <- peaks_cln %>%
  mutate(across(c(heightm, himal, region, pstatus, pyear), as.numeric))

## ---- Decode coded fields ----
season_lab <- c(`1` = "Spring", `2` = "Summer", 
                `3` = "Autumn", `4` = "Winter")

host_lab <- c(`1` = "Nepal", `2` = "China", `3` = "India")

termreason_lab <- c(
  `0`  = "Unknown",
  `1`  = "Success (main peak)",
  `2`  = "Success (subpeak, foresummit)",
  `3`  = "Success (claimed)",
  `4`  = "Bad weather",
  `5`  = "Bad conditions",
  `6`  = "Accident",
  `7`  = "Illness, AMS, exhaustion or frostbite",
  `8`  = "Lack of supplies, support or equipment",
  `9`  = "Lack of time",
  `10` = "Route technically too difficult",
  `11` = "Did not reach base camp",
  `12` = "Did not attempt climb",
  `13` = "Attempt rumoured",
  `14` = "Other"
)

region_lab <- c(
  `1` = "Kangchenjunga-Janak",
  `2` = "Khumbu-Rolwaling-Makalu",
  `3` = "Langtang-Jugal",
  `4` = "Manaslu-Ganesh",
  `5` = "Annapurna-Damodar-Peri",
  `6` = "Dhaulagiri-Mukut",
  `7` = "Kanjiroba-Far West"
)

death_injury_lab <- c(
  `1`  = "AMS (Acute MTN sickness",
  `2`  = "Exhaustion",
  `3`  = "Exposure/Frostbite",
  `4`  = "Fall",
  `5`  = "Crevasse",
  `6`  = "Ice fall collapse",
  `7`  = "Avalanche",
  `8`  = "Falling rock/ice",
  `9`  = "Disappearance (unexplained)",
  `10` = "Illness (non-AMS)",
  `11` = "Other",
  `12` = "Unknown"
)

death_cls_lab <- c(
  `1`  = "Death enroute BC",
  `2`  = "Death at BC/ABC",
  `3`  = "Route preparation",
  `4`  = "Ascending in summit bid",
  `5`  = "Descending from summit bid",
  `6`  = "Expedition evacuation",
  `7`  = "Other/Unknown"
)

decode <- function(x, labels) unname(labels[as.character(x)])

exped_cln <- exped_cln %>%
  mutate(season = factor(decode(season, season_lab), levels = season_lab),
         host = factor(decode(host, host_lab), levels = host_lab),
         termreason_code = termreason,          
         termreason = decode(termreason, termreason_lab)
  )

members_cln <- members_cln %>%
  mutate(mseason = factor(decode(mseason, season_lab), levels = season_lab),
         sex = factor(case_when(sex == "M" ~ "Male",
                                sex == "F" ~ "Female",
                                TRUE ~ NA_character_)),
         deathtype = factor(decode(deathtype, death_injury_lab), 
                            levels = death_injury_lab),
         injurytype = factor(decode(injurytype, death_injury_lab),
                             levels = death_injury_lab),
         deathclass = factor(decode(deathclass, death_cls_lab),
                             levels = death_cls_lab)
         )

peaks_cln <- peaks_cln %>%
  mutate(region = factor(decode(region, region_lab), levels = region_lab))

## ---- Unique expedition id ----
exped_cln <- exped_cln %>%
  log_n("expeditions", "All expedition records") %>%
  distinct() %>%
  log_n("expeditions", "Exact duplicate rows removed") %>%
  mutate(expid_year = paste(expid, year, sep = "_"))

members_cln <- members_cln %>%
  log_n("climbers", "All climber records") %>%
  distinct() %>%
  log_n("climbers", "Exact duplicate rows removed") %>%
  mutate(expid_year = paste(expid, myear, sep = "_"))

## ---- Data logic checking ----
# Dates checking
plausible_date <- function(d, year) {
  # a date more than one year away from the expedition year is an error
  if_else(abs(as.numeric(format(d, "%Y")) - year) <= 1, d, as.Date(NA))
}

# peak data check: 
# - Height (heightm): the highest peak (Everest) is 8849
# - pyear: first year of ascent should more than 0; 0 = not yet climbed (set as NA)
peaks_cln <- peaks_cln %>%
  mutate(
    heightm = if_else(heightm >= 5000 & heightm <= 8849, heightm, NA_real_),
    pyear   = if_else(pyear > 0, pyear, NA_real_)      
  )

# expedition data check:
# - 
exped_cln <- exped_cln %>%
  mutate(
    across(c(totmembers, smtmembers, mdeaths, tothired, smthired, hdeaths),
           ~ if_else(.x < 0, NA_real_, .x)),
    # hired staff missing but "no hired staff" flag set -> 0 hired staff
    tothired = if_else(is.na(tothired) & coalesce(nohired, FALSE), 0, tothired),
    hdeaths  = if_else(is.na(hdeaths)  & coalesce(nohired, FALSE), 0, hdeaths),
    bcdate   = plausible_date(bcdate, year),
    smtdate  = plausible_date(smtdate, year),
    termdate = plausible_date(termdate, year)
  )

# ==== Analysis data ====
# Expeditions: link to peak data
exped_cln <- exped_cln %>%
  left_join(peaks_cln, by = "peakid") %>%
  filter(peakid %in% peaks_cln$peakid) %>%
  log_n("expeditions", "Linked to a peak record") %>%
  filter(year >= 1905, year <= 2025) %>%
  log_n("expeditions", "Expedition year 1905-2025 (study population)")

# Climbers: belong to an included expedition
climbers_all <- members_cln %>%
  select(-peakid) %>%
  filter(expid_year %in% exped_cln$expid_year) %>%
  log_n("climbers", "Linked to an included expedition (study population)") %>%
  left_join(exped_cln, by = c("expid_year", "expid"))


## ---- Derived Variables ----
zero_to_na <- function(x) if_else(x > 0, x, NA_real_)   # 0 = unknown

climbers_all <- climbers_all %>%
  mutate(
    # Age: calcage, else age, else year - year of birth; outside 10-90 -> NA
    age = coalesce(zero_to_na(calcage), zero_to_na(age),
                   if_else(yob > 0, year - yob, NA_real_)),
    age = if_else(age >= 10 & age <= 90, age, NA_real_),
    age_group = cut(age, breaks = c(-Inf, 40, 60, Inf), right = FALSE,
                    labels = c("Under 40", "40-59", "60 or older")),
    
    # Personal high point: 0 = unknown, above the summit = impossible
    mperhighpt = zero_to_na(mperhighpt),
    mperhighpt = if_else(mperhighpt <= heightm, mperhighpt, NA_real_),
    
    # Role on the expedition
    across(c(leader, deputy, hired), ~ coalesce(.x, FALSE)),
    role = factor(case_when(hired ~ "Hired staff",
                            leader | deputy ~ "Leader",
                            TRUE ~ "Member"),
                  levels = c("Member", "Leader", "Hired staff")),
    climber_type = factor(if_else(hired, "Hired staff", "Member"),
                          levels = c("Member", "Hired staff")),
    
    # Citizenship: dual citizenship is recorded as "A/B"; keep the first
    nationality_raw = str_trim(str_extract(citizen, "^[^/]+")),
    
    # Team size = members + hired staff
    team_size = totmembers + tothired,
    
    # Years since first ascent at the time of the expedition.
    # Only ascents in EARLIER years count: if the first ascent was in the same
    # year, this expedition may have made it, which would leak the outcome.
    climbed_before = !is.na(pyear) & pyear < year,
    yrs_since_first = if_else(climbed_before, year - pyear, 0),
    
    decade = floor(year / 10) * 10
  )

## ---- Primary Outcome ----
# msuccess also counts subpeaks/foresummits and disputed claims.
# - expedition result "Success (subpeak, foresummit)" (code 2): nobody reached
#   the main summit -> 0
# - disputed claims: outcome unknown -> NA (change to 0L to count as failure)
climbers_all <- climbers_all %>%
  mutate(
    summit_success = case_when(
      is.na(msuccess) ~ NA_integer_,
      !msuccess ~ 0L,
      termreason_code %in% 2 ~ 0L,
      coalesce(mdisputed, FALSE) ~ NA_integer_,
      TRUE ~ 1L
    )
  )

## ---- Apply exclusion criteria (Obj. 1 & 2) -----
climbers <- climbers_all %>%
  filter(!is.na(summit_success)) %>%
  log_n("climbers", "Obj 1-2: summit outcome recorded (analysis data)")


# ==== Analysis data split - training/validation ====
# Training set consist of 80% / Validation set consist 20% of expeditions.
# Data is split at expedition level, stratified by whether any climber reached
# the summit, because members are linked to expeditions.
# Training expeditions also get a fold (1-10) for grouped cross-validation,
# so the whole team uses the same folds.

exp_strata <- climbers %>%
  group_by(expid_year) %>%
  summarise(any_summit = max(summit_success), .groups = "drop") %>%
  arrange(expid_year)            # same split whatever the row order

train_exp <- exp_strata %>%
  group_by(any_summit) %>%
  slice_sample(prop = 0.8) %>%
  pull(expid_year)

split <- exp_strata %>%
  mutate(set = if_else(expid_year %in% train_exp, "train", "validation")) %>%
  group_by(any_summit, set) %>%
  mutate(fold = if_else(set == "train", sample(rep_len(1:10, n())),
                        NA_integer_)) %>%
  ungroup() %>%
  select(expid_year, set, fold)

climbers <- climbers %>%
  left_join(split, by = "expid_year")

# check summit rate balance
climbers %>%
  group_by(set) %>%
  summarise(n = n(), n_exped = n_distinct(expid_year),
            summit_rate = mean(summit_success, na.rm = TRUE))


# ==== Category grouping, rules from training set only (protocol 4.5.4) ====
# Levels with fewer records than the threshold in the TRAINING set -> "Other".
# The same rule is applied unchanged to the validation set.
train_climbers <- filter(climbers, set == "train")
train_exped <- distinct(train_climbers, expid_year, nation, agency, peakid)

keep_levels <- function(x, min_n) {
  tab <- sort(table(x), decreasing = TRUE)
  names(tab)[tab >= min_n]
}
group_other <- function(x, keep) {
  factor(if_else(is.na(x), NA_character_, if_else(x %in% keep, x, "Other")),
         levels = c(keep, "Other"))
}

# No agency recorded is a real category (common before commercial climbing)
keep_nationality <- keep_levels(train_climbers$nationality_raw, 500)  # climbers
keep_nation      <- keep_levels(train_exped$nation, 50)               # expeditions
keep_peak        <- keep_levels(train_exped$peakid, 50)               # expeditions
keep_agency      <- keep_levels(coalesce(train_exped$agency, "None recorded"), 50)

grouping_rules <- bind_rows(
  tibble(variable = "nationality", kept_level = keep_nationality),
  tibble(variable = "exp_nation",  kept_level = keep_nation),
  tibble(variable = "peak_group",  kept_level = keep_peak),
  tibble(variable = "agency_group", kept_level = keep_agency)
)

add_groups <- function(df) {
  df %>%
    mutate(exp_nation   = group_other(nation, keep_nation),
           peak_group   = group_other(peakid, keep_peak),
           agency_group = group_other(coalesce(agency, "None recorded"),
                                      keep_agency))
}

climbers <- climbers %>%
  mutate(nationality = group_other(nationality_raw, keep_nationality)) %>%
  add_groups()

# ==== Expedition-level data (Objectives 3 and 4) ====
# One row per expedition, built from the expedition table (so expeditions
# without climber records are kept), with climber characteristics summarised
# within each expedition (protocol 4.4).
climber_summary <- climbers_all %>%
  group_by(expid_year) %>%
  summarise(
    n_members_records = sum(!hired),
    n_hired_records = sum(hired),
    prop_hired = mean(hired),
    prop_female = mean(sex == "Female", na.rm = TRUE),
    mean_age = mean(age, na.rm = TRUE),
    prop_age60 = mean(age >= 60, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(across(where(is.numeric), ~ if_else(is.nan(.x), NA_real_, .x)))

# One data set for Objectives 3 and 4. It has:
#   - flags obj3 / obj4 (TRUE = expedition meets that objective's criteria)
#   - the Objective 3 counts as separate columns for members and hired staff
#   - the Objective 4 outcome time_to_summit, already cleaned
expeditions <- exped_cln %>%
  left_join(climber_summary, by = "expid_year") %>%
  left_join(select(split, expid_year, set), by = "expid_year") %>%
  add_groups() %>%
  mutate(
    team_size = totmembers + tothired,
    climbed_before = !is.na(pyear) & pyear < year,
    yrs_since_first = if_else(climbed_before, year - pyear, 0),
    decade = floor(year / 10) * 10,
    
    # -- Objective 3: deaths and people at risk, per group (protocol 4.3) --
    deaths_member  = mdeaths,
    at_risk_member = totmembers,
    deaths_hired   = hdeaths,
    at_risk_hired  = tothired,
    
    # -- Objective 4: days from base camp arrival to first main summit --
    main_summit = termreason_code %in% 1,
    days_raw = as.numeric(smtdate - bcdate),
    # summit date before arrival at base camp -> missing (protocol 4.5.3)
    time_to_summit = if_else(days_raw >= 0, days_raw, NA_real_),
    
    # -- Inclusion flags (protocol 4.2) --
    # Obj 3: at least one recorded member or hired staff
    obj3 = coalesce(totmembers, 0) + coalesce(tothired, 0) > 0,
    # Obj 4: main summit reached, both dates recorded, summit not before BC
    obj4 = main_summit & !is.na(time_to_summit)
  )

## ---- Flow of records for Objectives 3 and 4 ----
# Counts only; the data set itself keeps all expeditions.
expeditions %>%
  log_n("obj3", "Expeditions in the study population") %>%
  filter(obj3) %>%
  log_n("obj3", "Obj 3: at least one recorded member or hired staff")

expeditions %>%
  log_n("obj4", "Expeditions in the study population") %>%
  filter(main_summit) %>%
  log_n("obj4", "Obj 4: main summit reached") %>%
  filter(!is.na(bcdate), !is.na(smtdate)) %>%
  log_n("obj4", "Obj 4: base camp and summit dates recorded") %>%
  filter(obj4) %>%
  log_n("obj4", "Obj 4: summit date not before base camp arrival")

summary(expeditions$time_to_summit[expeditions$obj4])  # check very long values

## ---- How to use this data set in the analysis scripts ----
# Objective 4: one row per expedition
#   tts <- expeditions %>% filter(obj4)
#
# Objective 3: two rows per expedition (members, hired staff), as needed for
# one Poisson model with group and group x year (protocol 5.6.1)
#   mort <- expeditions %>%
#     filter(obj3) %>%
#     pivot_longer(c(deaths_member, at_risk_member, deaths_hired, at_risk_hired),
#                  names_to = c(".value", "group"),
#                  names_pattern = "(deaths|at_risk)_(member|hired)") %>%
#     filter(!is.na(at_risk), at_risk > 0) %>%
#     mutate(group = factor(group, levels = c("member", "hired"),
#                           labels = c("Member", "Hired staff")))
#   Offset: log(at_risk); cluster standard errors by expid_year.

# ==== Leakage variables (protocol 4.4) ====
# Known only during or after the summit attempt. Use for outcomes and
# descriptive tables only, NEVER as predictors.
leakage_vars <- c("msuccess", "mclaimed", "mdisputed", "msolo", "mperhighpt",
                  "mo2descent", "mo2medical",
                  "death", "deathtype", "deathclass", "ams", "weather",
                  "injury", "injurytype",
                  "smtmembers", "smthired", "mdeaths", "hdeaths",
                  "smtdays", "termreason", "termreason_code", "main_summit",
                  "bcdate", "smtdate", "smttime", "termdate", "time_to_summit",
                  "days_raw", "deaths_member", "deaths_hired", "obj3", "obj4")
# Check with the team before using: these record actual oxygen use, not
# planned use (a climber who turned back early may not have used oxygen).
check_vars <- c("mo2used", "mo2none", "mo2climb", "mo2sleep",
                "o2used", "o2none", "bconly", "nottobc")

# ==== Missing value check (protocol 4.5.5) ====
missing_report <- bind_rows(
  climbers    %>% summarise(across(everything(), ~ mean(is.na(.x)))) %>%
    pivot_longer(everything(), names_to = "variable",
                 values_to = "prop_missing") %>% mutate(data = "climbers"),
  expeditions %>% summarise(across(everything(), ~ mean(is.na(.x)))) %>%
    pivot_longer(everything(), names_to = "variable",
                 values_to = "prop_missing") %>% mutate(data = "expeditions")
) %>%
  arrange(data, desc(prop_missing))
print(missing_report, n = Inf)

print(flow, n = Inf)

# ==== Output Analysis data ====
for (nm in c("climbers", "expeditions")) {
  df <- get(nm)
  saveRDS(df, file.path(out_dir, paste0(nm, ".rds")))    # keeps factors, dates
  write.csv(df, file.path(out_dir, paste0(nm, ".csv")),
            row.names = FALSE, na = "", fileEncoding = "UTF-8")
}
write.csv(flow, file.path(out_dir, "flow_of_records.csv"), row.names = FALSE)
write.csv(missing_report, file.path(out_dir, "missing_report.csv"), row.names = FALSE)
write.csv(grouping_rules, file.path(out_dir, "grouping_rules.csv"),
          row.names = FALSE, fileEncoding = "UTF-8")
