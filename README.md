# Data Analysis Portfolio

This repository showcases three distinct data analysis projects, showcasing my skills in exploratory data analysis, model selection, and designing simulation studies. 

## Project 1
### Exploratory Data Analysis on Prenatal/Childhood Smoke Exposure and Adolescent Behavior

**Background**:  The prenatal and postnatal periods represent critical stages of human development, during which environmental factors can shape the child's long-term health and well-being. Among many factors that influence fetal and neonatal development, maternal smoking has emerged as a concern associated with a variety of adverse outcomes, not only affecting the immediate health of the newborn but potentially extending into adolescence and beyond. 

**Methods**: This report explores the relationship between prenatal and postpartum smoke exposure and its subsequent impact on teenagers' internalizing and externalizing behaviors. Internalizing behaviors encompass self-regulatory problems, while externalizing behaviors involve outward expressions, such as attention-deficit/hyperactivity disorder (ADHD), conduct disorder, and substance use. Understanding the relationship between prenatal or postnatal smoke exposure and the emergence of these behaviors is crucial for informing public health policies and interventions aimed at fostering healthier outcomes for adolescents. Utilizing data from a cohort of 40 parent-adolescent pairs, this investigation examined the effects of maternal smoking during pregnancy and the first six months postpartum on adolescent outcomes. 

**Results**: This report's exploratory data analysis revealed that there wasn't much of an association between smoking during pregnancy and the measured self-regulation behaviors, while there was a stronger association between smoking during pregnancy and the measured externalizing behaviors, particularly the incidence of ADHD. These associations were stronger for childhood smoke exposure than prenatal smoke exposure. The full report can be found [here](<Exploratory Data Analysis/report/EDA_report.pdf>).

## Project 2
### Model Selection for Predicting Tracheostomy Placement in Infants with sBPD

**Background**: Bronchopulmonary dysplasia (BPD) poses a significant challenge in the care of preterm infants, with severe cases often needing tracheostomy. Clinicians grapple with the challenge of determining the optimal timing for tracheostomy placement in neonates with sBPD. This study aims to develop models for predicting tracheostomy in neonates with severe BPD using respiratory parameters at 36 and 44 weeks post-menstrual age (PMA).

**Methods**: A multicenter, retrospective case-control study was conducted, involving 996 infants born at less than 32 weeks PMA. Clinical data were collected at birth, 36 weeks PMA, 44 weeks PMA, and at discharge. Multiple imputation addressed missing data and a best subsets algorithm was used for variable selection. Four logistic mixed-effects models were developed, with 30% of observations reserved for validation. Models were evaluated using area under the receiver operating characteristic curve (AUC), Brier score, precision, recall, and F1 score.

**Results**: Respiratory support level, fraction of inspired oxygen required, prenatal corticosteroids, and medication of pulmonary hypertension emerged as significant predictors of tracheostomy. The 44-week model outperformed the 36-week model, showing the importance of respiratory parameters closer to discharge. The full report can be found [here](<Model Selection/report/model_selection_report.pdf>). 

## Project 3
### Evaluating the Performance of Simulated Datasets in Transportability Analysis

**Background**: Risk prediction models, such as the Framingham ATP-III model for cardiovascular disease, are crucial for clinical decision-making but may face challenges when applied to populations with different characteristics. Transportability analysis techniques can adjust model performance for these differences, but they require individual-level data from the target population, which may not always be available. Simulating the target population data from summary statistics may be one way to overcome this challenge. Our study evaluated how well simulated data can replicate individual-level target population data in the context of transportability analysis, specifically investigating how important correlation assumptions are when simulating the data.

**Methods**: We fit a CVD risk model on Framingham Heart Study data and then conducted transportability analyses using a target population from the National Health and Nutrition Examination Survey (NHANES), a nationally representative dataset that does not contain long-term outcome data on CVD. We assessed the bias of Brier score and AUC estimates derived through transportability analysis using simulated data in comparison to those derived using the individual-level NHANES data. Simulated target population data were generated using NHANES summary statistics and a variety of correlation parameters. 

**Results**: Low relative biases were observed, suggesting that using simulated data to conduct transportability analysis is a valid way to estimate Brier scores and AUC in a target population when individual-level data is not available. The simulations that assumed no associations between simulated covariates or that used the associations observed in the source population did not result in substantially lowered performance than simulations using the precise associations observed in the target population. More details can be found in the [report](Simulation/report/simulation_report.pdf) or the [poster](Simulation/report/simulation_poster.pdf). 

## Contact
**Hannah Eglinton** \
hannah_eglinton@brown.edu \
[LinkedIn](https://www.linkedin.com/in/hannah-eglinton/) \
[Github](https://github.com/hjeglinton)
