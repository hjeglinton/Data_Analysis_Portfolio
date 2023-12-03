

get_weights <- function(combined_df) {
  
  # Fit model for Pr(S = 1 | X)
  fit_S1 <- glm(S ~ ., data = dplyr::select(combined_df, -c(CVD, SEX)), family = "binomial")
  
  # Get probability of being in FHS (S = 1)
  prob_S1 <- predict(fit_S1, newdata = combined_df, type = "response")
  
  # Calculate inverse-odds weights 
  weights <- (1-prob_S1)/prob_S1
  
  return(weights)
  
}

# Estimate brier score
estimate_brier <- function(model, combined_df, observed, predicted, n_target) {
  
  weights <- get_weights(combined_df)
  
  est <- sum(weights[combined_df$S == 1] * (observed - predicted)^2) / n_target
  
  return(est)
  
}


# Estimate AUC

estimate_auc <- function(combined_df, observed, predicted) {
  
  weights <- get_weights(combined_df)[combined_df$S == 1]
  
  numerator <- 0
  denominator <- 0
  
  for (i in 1:(length(weights) - 1)) {
    for (j in (i+1):length(weights)) {
      
      if ((i != j) & (observed[i] == 1 & observed[j] == 0)) {
        
        w <- weights[i] * weights[j]
        denominator <- denominator + w
        
        if (predicted[i] > predicted[j]) {
          numerator <- numerator + w
        }
      }
    }
  } 
  
  return(numerator / denominator)
}

estimate_auc_noweights <- function(observed, predicted) {
  
  numerator <- 0
  denominator <- 0
  
  for (i in 1:(length(observed) - 1)) {
    for (j in (i+1):length(observed)) {
      
      if ((i != j) & (observed[i] == 1 & observed[j] == 0)) {
        
        denominator <- denominator + 1
        
        if (predicted[i] > predicted[j]) {
          numerator <- numerator + 1
        }
      }
    }
  } 
  
  return(numerator / denominator)
}


make_cov_mat <- function(sd1, sd2, rho) {
  
  cov_mat = matrix(0, nrow = 2, ncol = 2)
  cov_mat[1,1] <- sd1^2
  cov_mat[1,2] <- rho * sd1 * sd2
  cov_mat[2,1] <- rho * sd1 * sd2
  cov_mat[2,2] <- sd2^2 
  
  return(cov_mat)
  
}


simulate_covariates <- function(means, sds, rho, gamma) {
  
  cov_mat_chol <- make_cov_mat(sds$HDLC, sds$TOTCHOL, rho)
  X <- as.data.frame(mvrnorm(n = n, mu = c(means$HDLC, means$TOTCHOL), 
                             Sigma = cov_mat_chol, 2)) 
  colnames(X) <- c("HDLC", "TOTCHOL")
  
  
  cov_mat_age <- make_cov_mat(1, 1, gamma)
  age_bpmeds <- as.data.frame(mvrnorm(n = n, mu = c(0,0), Sigma = cov_mat_age, 2))
  
  X$AGE <- pnorm(age_bpmeds[,1])*(82-42) + 42
  X$BPMEDS <- ifelse(pnorm(age_bpmeds[,2]) > 1-means$BPMEDS, 1, 0)
  
  X$SYSBP_UT <- rnorm(n, means$SYSBP_UT, sds$SYSBP_UT)
  X$SYSBP_T <- rnorm(n, means$SYSBP_T, sds$SYSBP_T)
  
  X$CURSMOKE <- rbinom(n, 1, means$CURSMOKE)
  X$DIABETES <- rbinom(n, 1, means$DIABETES)
  
  X$S <- 0
  
  X <- X %>%
    mutate(SYSBP_UT = ifelse(BPMEDS == 0, SYSBP_UT, 0),
           SYSBP_T = ifelse(BPMEDS == 1, SYSBP_T, 0),
           SYSBP = SYSBP_UT + SYSBP_T)
  
  return(X)
  
}

relative_bias <- function(estimate_vec, estimand) {
  return((mean(estimate_vec) - estimand)/estimand)
}

relative_bias_se <- function(n_sim, estimate_vec, estimand) {
  return(sqrt(1/(n_sim*(n_sim-1)) * sum(((estimate_vec - estimand)^2)/estimand)))
}
