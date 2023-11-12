# Predicting Tracheostomy in Infants with sBPD

Bronchopulmonary dysplasia (BPD) poses a significant challenge in the care of preterm infants, with severe cases often needing tracheostomy. This project aims to develop models for predicting tracheostomy in neonates with severe BPD using respiratory parameters at 36 and 44 weeks post-menstrual age (PMA). The data were accessed from the BPD Collaborative Registry, which included a sample of 996 infants with severe BPD. 

Clinicians grapple with the challenge of determining the optimal timing for tracheostomy placement in neonates with sBPD. While early intervention helps the patient and parents adjust to tracheostomy well before discharge, leading to better outcomes and improved growth, clinicians do not want to introduce the risks associated with tracheostomy to patients who will not need it. Existing attempts to predict the need for tracheostomy have predominately relied on baseline demographics and clinical diagnosis and have not provided prediction at different postmenstrual ages or used detailed respiratory parameters.

This research seeks to address this gap by leveraging clinical data collected at two timepoints -- 36 and 44 weeks PMA -- to develop predictive models for tracheostomy outcomes in neonates with BPD. 36 weeks marks a crucial junction in the neonatal period, as it is the point at which preterm born infants are considered to have reached their term-equivalent age. The 44-week timepoint provides insights closer to anticipated discharge. The implications of such a model are substantial, not only for guiding clinicians through informed decision-making but also for refining the ongoing debate surrounding tracheostomy placement in neonates with severe bronchopulmonary dysplasia.

The following packages were used in this analysis: 

 - Data Manipulation: `tidyverse` \ 
 - Table Formatting: `gtsummary`, `knitr`
 - Data Visualization: `corrplot`, `ggplot2`
 - Multiple Imputation: `mice`
 - Best Subsets Variable Selection: `L0Learn`
 - Mixed Effects Modeling: `lme4`
 - Model Evaluation: `pROC`

## Files

`project2_eda.R`:
Contains the exploratory data analysis steps taken to inform model development. 

`project2_report.Rmd`:
The Rmarkdown version of the  report, which includes both written text interpretations and raw code used in the analysis. 

`project2_report.pdf`:
The PDF version of the report, which includes both written text interpretations and a Code Applendix with the raw code used in the analysis. 
