library(tidyverse)
library(gtsummary)

# Read in and process data
df <- read.csv("project2.csv") %>%
  distinct() %>%
  select(-c(record_id, hosp_dc_ga, Death, mat_race)) %>%
  mutate_at(c("center","mat_ethn", "del_method", "prenat_ster", 
              "com_prenat_ster", "mat_chorio", "gender", "sga", "any_surf", 
              "ventilation_support_level.36", "med_ph.36", "Trach"), 
            as.factor) 

levels(df$ventilation_support_level.36) <- c("None", "NIPPV", "IPPV")
df$center[is.na(df$center)] <- 1

# Examine univariate distributions
hist(df$bw)
hist(df$ga)
hist(df$blength)
hist(df$birth_hc)
hist(df$weight_today.36)
hist(df$inspired_oxygen.36)
hist(df$p_delta.36)
hist(df$peep_cm_h2o_modified.36)

table(df$center)
table(df$mat_ethn)
table(df$del_method)
table(df$prenat_ster)
table(df$com_prenat_ster)
table(df$mat_chorio)
table(df$gender)
table(df$sga)
table(df$any_surf)
table(df$ventilation_support_level.36)
table(df$med_ph.36)
table(df$ventilation_support_level_modified.44)
table(df$med_ph.44)

# Examine missing data 
data.frame(variable = names(colMeans(is.na(df))), 
           perc_missing = paste0(round(100*colMeans(is.na(df)),1),"%"), 
           row.names = NULL)

# Examine variable correlations
df %>%
  select(bw, ga, blength, birth_hc, weight_today.36, 
         inspired_oxygen.36, p_delta.36, peep_cm_h2o_modified.36, 
         weight_today.44, inspired_oxygen.44, 
         p_delta.44, peep_cm_h2o_modified.44) %>%
  cor(use = "complete.obs") %>%
  round(2)

# Examine each variables's relationship with outcome 
tbl_summary(df, by = Trach, missing = "no",
            type = list(mat_ethn ~ "dichotomous", 
                        del_method ~ "dichotomous",
                        prenat_ster ~ "dichotomous",
                        com_prenat_ster ~ "dichotomous",
                        mat_chorio ~ "dichotomous",
                        gender ~ "dichotomous",
                        sga ~ "dichotomous",
                        any_surf ~ "dichotomous",
                        med_ph.36 ~ "dichotomous"),
            value = list(mat_ethn = "1",
                         del_method = "2",
                         prenat_ster = "Yes", 
                         com_prenat_ster = "Yes", 
                         mat_chorio = "Yes",
                         gender = "Male",
                         sga = "SGA",
                         any_surf = "Yes",
                         med_ph.36 = "1"),
            statistic = list(all_continuous() ~ 
                               c("{mean} ({sd})"))) %>%
  add_n()  

