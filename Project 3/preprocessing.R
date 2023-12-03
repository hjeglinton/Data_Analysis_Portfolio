library(riskCommunicator)
library(tidyverse)
library(tableone)
library(mice)
library(nhanesA)

data("framingham")

# The Framingham data has been used to create models for cardiovascular risk.
# The variable selection and model below are designed to mimic the models used
# in the paper General Cardiovascular Risk Profile for Use in Primary Care 
# This paper is available (cvd_risk_profile.pdf) on Canvas.

framingham_df <- framingham %>% select(c(CVD, TIMECVD, SEX, TOTCHOL, AGE,
                                      SYSBP, DIABP, CURSMOKE, DIABETES, BPMEDS,
                                      HDLC, BMI))
framingham_df <- na.omit(framingham_df)

CreateTableOne(data=framingham_df, strata = c("SEX"))

# Get blood pressure based on whether or not on BPMEDS
framingham_df$SYSBP_UT <- ifelse(framingham_df$BPMEDS == 0, 
                                 framingham_df$SYSBP, 0)
framingham_df$SYSBP_T <- ifelse(framingham_df$BPMEDS == 1, 
                                framingham_df$SYSBP, 0)

# Looking at risk within 15 years - remove censored data
dim(framingham_df)
framingham_df <- framingham_df %>%
  filter(!(CVD == 0 & TIMECVD <= 365*15)) %>%
  select(-c(TIMECVD))
dim(framingham_df)

framingham_df$SEX <- ifelse(framingham_df$SEX == 1, "Male", "Female")

write.csv(framingham_df, "framingham.csv", row.names = FALSE)

# The NHANES data here finds the same covariates among this national survey data


# blood pressure, demographic, bmi, smoking, and hypertension info
bpx_2017 <- nhanes("BPX_J") %>% 
  select(SEQN, BPXSY1, BPXDI1) %>% 
  rename(SYSBP = BPXSY1, DIABP = BPXDI1)
demo_2017 <- nhanes("DEMO_J") %>% 
  select(SEQN, RIAGENDR, RIDAGEYR, INDFMIN2, RIDRETH1) %>% 
  rename(SEX = RIAGENDR, AGE = RIDAGEYR, INCOME = INDFMIN2, RACE = RIDRETH1)
bmx_2017 <- nhanes("BMX_J") %>% 
  select(SEQN, BMXBMI) %>% 
  rename(BMI = BMXBMI)
smq_2017 <- nhanes("SMQ_J") %>%
  mutate(CURSMOKE = case_when(SMQ040 %in% c(1,2) ~ 1,
                              SMQ040 == 3 ~ 0, 
                              SMQ020 == 2 ~ 0)) %>%
  select(SEQN, CURSMOKE)
bpq_2017 <- nhanes("BPQ_J") %>% 
  mutate(BPMEDS = case_when(
    BPQ020 == 2 ~ 0,
    BPQ040A == 2 ~ 0,
    BPQ050A == 1 ~ 1,
    TRUE ~ NA )) %>%
  select(SEQN, BPMEDS) 
tchol_2017 <- nhanes("TCHOL_J") %>% 
  select(SEQN, LBXTC) %>% 
  rename(TOTCHOL = LBXTC)
hdl_2017 <- nhanes("HDL_J") %>% 
  select(SEQN, LBDHDD) %>% 
  rename(HDLC = LBDHDD)
diq_2017 <- nhanes("DIQ_J") %>% 
  mutate(DIABETES = case_when(DIQ010 == 1 ~ 1, 
                              DIQ010 %in% c(2,3) ~ 0, 
                              TRUE ~ NA)) %>%
  select(SEQN, DIABETES) 

mcq_2017 <- nhanes("MCQ_J") %>%
  select(SEQN, MCQ160E, MCQ160C) %>%
  rename(myocardial_infarction = MCQ160E,
         coronary_heart_disease = MCQ160C)

# Join data from different tables
df_2017 <- bpx_2017 %>%
  full_join(demo_2017, by = "SEQN") %>%
  full_join(bmx_2017, by = "SEQN") %>%
  full_join(hdl_2017, by = "SEQN") %>%
  full_join(smq_2017, by = "SEQN") %>%
  full_join(bpq_2017, by = "SEQN") %>%
  full_join(tchol_2017, by = "SEQN") %>%
  full_join(diq_2017, by = "SEQN") %>%
  full_join(mcq_2017, by = "SEQN")

CreateTableOne(data = df_2017, strata = c("SEX"))

range(df_2017$AGE)


df_2017 <- df_2017 %>%
  filter(AGE >= 44 & AGE <=81)  %>%
  filter(myocardial_infarction != 1 & coronary_heart_disease != 1) %>%
  select(-c(SEQN, myocardial_infarction, coronary_heart_disease))

# look at missing data pattern
md.pattern(df_2017)


df_2017_complete <- na.omit(df_2017) #976/3553 subjects with missing data (27%)


df_2017$SEX <- ifelse(df_2017$SEX == 1, "Male", "Female")


write.csv(df_2017, "nhanes.csv", row.names = FALSE)

