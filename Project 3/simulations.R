
source("functions.R")

# Read in FHS data and models 
framingham_df <- read.csv("framingham.csv")
framingham_df$S <- 1
framingham_df_men <- framingham_df %>% filter(SEX == "Male")
framingham_df_women <- framingham_df %>% filter(SEX == "Female")
mod_men <- glm(CVD~log(HDLC)+log(TOTCHOL)+log(AGE)+log(SYSBP_UT+1)+
                 log(SYSBP_T+1)+CURSMOKE+DIABETES, 
               data= framingham_df_men, family= "binomial")
mod_women <- glm(CVD~log(HDLC)+log(TOTCHOL)+log(AGE)+log(SYSBP_UT+1)+
                   log(SYSBP_T+1)+CURSMOKE+DIABETES, 
                 data= framingham_df_women, family= "binomial")



# Set male parameters
n <- 1481
mean_men <- list("AGE" = 62, "SYSBP_UT" = 129, "SYSBP_T" = 135, "HDLC" = 49,
              "TOTCHOL" = 187, "CURSMOKE" = 0.20, "DIABETES" = 0.22, 
              "BPMEDS" = 0.41)
sd_men <- list("AGE" = 11, "SYSBP_UT" = 18, "SYSBP_T" = 18, "HDLC" = 14,
            "TOTCHOL" = 42, "CURSMOKE" = NA, "DIABETES" = NA, 
            "BPMEDS" = NA)


mean_women <- list("AGE" = 62, "SYSBP_UT" = 128, "SYSBP_T" = 139, "HDLC" = 59,
                 "TOTCHOL" = 200, "CURSMOKE" = 0.12, "DIABETES" = 0.19, 
                 "BPMEDS" = 0.46)
sd_women <- list("AGE" = 11, "SYSBP_UT" = 19, "SYSBP_T" = 20, "HDLC" = 16,
               "TOTCHOL" = 41, "CURSMOKE" = NA, "DIABETES" = NA, 
               "BPMEDS" = NA)


# Set seed and n_sim
set.seed(1)
n_sim = 100

rho_grid <- seq(0, 0.90, 0.1)
gamma_grid <- seq(0 , 0.90, 0.1)
full_grid <- expand.grid(rho = rho_grid, gamma = gamma_grid, 
                         brier_male = rep(NA, n_sim))
full_grid$brier_female <- NA
full_grid$auc_male <- NA
full_grid$auc_female <- NA

# Run simulations 
for (i in 1:nrow(full_grid)) {
  
  if (i %% 100 == 0) {
    print(i)
  }
  
  X_men <- simulate_covariates(mean_men, sd_men, 
                           rho = full_grid$rho[i], 
                           gamma = full_grid$gamma[i])
  
  X_women <- simulate_covariates(mean_women, sd_women, 
                                 rho = full_grid$rho[i], 
                                 gamma = full_grid$gamma[i])
  
  
  combined_men <- bind_rows(framingham_df_men, X_men) %>%
    dplyr::select(TOTCHOL, AGE, CURSMOKE, DIABETES, 
           BPMEDS, HDLC, SYSBP, CVD, S, SEX)
  
  combined_women <- bind_rows(framingham_df_women, X_women) %>%
    dplyr::select(TOTCHOL, AGE, CURSMOKE, DIABETES, 
           BPMEDS, HDLC, SYSBP, CVD, S, SEX)
  
  
  full_grid$brier_male[i] <- estimate_brier(model = mod_men,
                                            combined_df = combined_men,
                                            observed = framingham_df_men$CVD,
                                            predicted = predict(mod_men, type = "response"),
                                            n_target = nrow(X_men))
  
  full_grid$brier_female[i] <- estimate_brier(model = mod_women,
                                              combined_df = combined_women,
                                              observed = framingham_df_women$CVD,
                                              predicted = predict(mod_women, type = "response"),
                                              n_target = nrow(X_women))
  
  full_grid$auc_male[i] <- estimate_auc(combined_df = combined_men,
                                        observed = framingham_df_men$CVD,
                                        predicted = predict(mod_men, type = "response"))
 
   full_grid$auc_female[i] <- estimate_auc(combined_df = combined_women,
                                           observed = framingham_df_women$CVD,
                                           predicted = predict(mod_women, type = "response"))
  
  
  
}

sds <- full_grid %>%
  group_by(rho, gamma) %>%
  summarize(sd_m = sd(brier_male), sd_f = sd(brier_female))

# Save results
write.csv(full_grid, "simulation_results.csv", row.names = FALSE)
