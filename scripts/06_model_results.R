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

library(tidyverse)
library(tidymodels)
library(docopt)
library(knitr)
library(purrr)
library(leaps)
library(mltools)

opt <- docopt(doc)

# read in train and test data
train_path <- opt$input_train
test_path  <- opt$input_test
covid_train_numeric <- read_csv(train_path)
covid_test_numeric <- read_csv(test_path)


# create a mulitple linear regression model with the selected features
final_model <- lm(search_trends_anxiety ~ new_persons_vaccinated + new_hospitalized_patients + date,
                  data = covid_train_numeric)

#create a table with the regression results
lm_coef <- tidy(final_model)
write_csv(lm_coef, opt$coefficients)


# test model on testing set
# apply the model to predict test data:
final_model_predictions <- predict(final_model, newdata = covid_test_numeric)

# find the RMSE between the model's prediction and the actual values
final_model_RMSPE = rmse(preds = final_model_predictions,
                        actuals = covid_test_numeric$search_trends_anxiety)

# preview RMSPE error rate:
final_model_RMSPE

# preview R-squared:
r_sqr <- summary(final_model)$r.squared

# create dataframe with RMSPE and R-squared
metrics_results <- tibble(RMSPE = final_model_RMSPE, R_square = r_sqr)
write_csv(metrics_results, opt$metrics_results)