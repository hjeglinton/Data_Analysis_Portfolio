# Evaluating the Performance of Simulated Dataset in Transportability Analysis

Risk prediction models, such as the Framingham ATP-III model for cardiovascular disease, are crucial for clinical decision-making but may face challenges when applied to populations with different characteristics. Transportability analysis techniques can adjust model performance for these differences, but they require individual-level data from the target population, which may not always be available. Simulating the target population data from summary statistics may be one way to overcome this challenge. To investigate this, , our study fit a CVD risk model on FHS data and then conducted transportability analyses using a simulated target population from the National Health and Nutrition Examination Survey (NHANES), a nationally representative dataset that does not contain long-term outcome data on CVD. Our study evaluated how well simulated data can replicate individual-level target population data in the context of transportability analysis, specifically investigating how important correlation assumptions are when simulating the data. We assessed the bias of Brier score and AUC estimates derived through transportability analysis using simulated data in comparison to those derived using the individual-level NHANES data. 

The following packages were used in this analysis: 

 - Data Manipulation: `tidyverse` 
 - Table Formatting: `gtsummary`, `knitr`, `kableExtra`
 - Data Visualization: `ggplot2`, `gridExtra`
 - Multiple Imputation: `mice`
 - FHS data: `riskCommunicator`
 - NHANES data: `nhanesA`


## Files

### R Code 

`preprocessing.R`:
Contains the steps taken to process the FHS and NHANES datasets. 

`functions.R`: 
Contains all original functions written for this analysis. 

`simulations.R`:
Contains the code used for the simulation study. 

### Data Files

`simulation_results.csv`:
Contains the results from the simulation study.

### Report

`project3_report.Rmd`:
The Rmarkdown version of the  report, which includes both written text interpretations and raw code used in the analysis. 

`project3_report.pdf`
The PDF version of the report, which includes both written text interpretations and a Code Appendix with the raw code used in the analysis. 


