library(testthat)
library(here)
source(here("R", "make_final_lm_model.R"))
source(here("R", "results_lm_coef.R"))
source(here("R", "model_predictions.R"))

# create a test dataframe with date as DATE
set.seed(123)
test_df <- data.frame(
  date = as.Date(c("2020-01-01", "2020-01-02", "2020-01-03", 
                   "2020-01-04", "2020-01-05", "2020-01-06")),
  search_trends_anxiety = c(1.2, 1.5, 1.3, 1.6, 1.1, 1.4) + rnorm(6, sd = 0.1),
  new_persons_vaccinated = c(100, 200, 150, 250, 120, 180) + rnorm(6, sd = 10),
  new_hospitalized_patients = c(5, 10, 7, 12, 4, 8) + rnorm(6, sd = 1),
  new_confirmed = c(20, 30, 25, 35, 18, 22) + rnorm(6, sd = 2),
  new_intensive_care_patients = c(2, 3, 2, 4, 1, 2) + rnorm(6, sd = 0.5)
)

# create a test dataframe with date as numeric
df_numeric <- test_df |> 
  mutate(date = as.numeric(date))

# create an empty test dataframe
empty_df  <- tibble(class_labels = character(0),
                    values = double(0))

# make a test model
test_result <- lm(search_trends_anxiety ~ new_persons_vaccinated + new_hospitalized_patients + date,
     data = df_numeric)

# create test metrics:
test_rmse <- model_predictions(test_lm, df_numeric)

# apply the model to predict test data:
final_model_predictions <- predict(test_lm, newdata = df_numeric)

# find the RMSE between the model's prediction and the actual values
final_model_RMSPE = rmse(preds = final_model_predictions,
                         actuals = df_numeric$search_trends_anxiety)

# create dataframe with RMSPE and R-squared, store it as csv and return it
metrics_results <- tibble(RMSPE = final_model_RMSPE, R_square = summary(test_lm)$r.squared)

# test that an error is given when using the incorrect df
test_that("`results_lm_coef` should throw an error when incorrect types
are passed to the `lm_model` argument", {
  expect_error(model_predictions(test_lm, missing_col_df))
})

# test that an error is given when using the Dates isntead of numeric
test_that("`results_lm_coef` should throw an error when incorrect types
are passed to the `lm_model` argument", {
  expect_error(model_predictions(test_lm, test_df))
})

# test that the correct table is returned
test_that("`results_lm_coef` should throw an error when incorrect types
are passed to the `lm_model` argument", {
  
  expect_equal(model_predictions(test_lm, df_numeric), metrics_results)
})

# test that the csv is written
test_that("`results_lm_coef` should write a file named lm_coef.csv" {
  expect_true(file.exists("results/metrics_results.csv"))
})