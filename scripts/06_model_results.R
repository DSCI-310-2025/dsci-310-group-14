# author: Vincy Huang
# date: 2025-03-12
"This script reads train/test data from previous script and performs linear regression on
selected features based on previous feature selection and summarizes the model in table(s).

Usage: 06_model_results.R --input_train=<input_train> --input_test=<input_test> --coefficients=<coefficients> --metrics_results=<metrics_results>
Options:
--input_train=<input_train>         A path/filename to training data
--input_test=<input_test>           A path/filename to testing data
--coefficients=<coefficients>       A path/filename to save linear coefficients table
--metrics_results=<metrics_results> A path/filename to save linear metrics results table
" -> doc

set.seed(310)
library(docopt)
library(tidyverse)

opt <- docopt(doc)

# read in train and test data
train_path <- opt$input_train
test_path  <- opt$input_test
covid_train_numeric <- read_csv(train_path)
covid_test_numeric <- read_csv(test_path)


# create a mulitple linear regression model with the selected features
final_model <- covidanxietytrends::make_final_lm_model(covid_train_numeric)

#create a table with the regression results
lm_coef <- covidanxietytrends::results_lm_coef(final_model, opt$coefficients)


# apply the model to predict test data:
# find the RMSE between the model's prediction and the actual values
# create dataframe with RMSPE and R-squared
performance_metrics <- covidanxietytrends::model_predictions(final_model, covid_test_numeric, opt$metrics_results)
