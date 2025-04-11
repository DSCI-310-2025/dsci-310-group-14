library(testthat)
library(here)
library(tidyverse)
library(Metrics)  

source(here("R", "make_final_lm_model.R"))
source(here("R", "results_lm_coef.R"))
source(here("R", "model_predictions.R"))

# utilize tempfile for test output file
output_file <- tempfile(fileext = ".csv")


test_that("model_predictions works as expected", {
# create training and test dataframe
set.seed(123)
train_df <- data.frame(date = as.Date(c("2020-01-01", "2020-01-02", "2020-01-03", 
                                       "2020-01-04", "2020-01-05", "2020-01-06")),
                      search_trends_anxiety = c(1.2, 1.5, 1.3, 1.6, 1.1, 1.4) + rnorm(6, sd = 0.1),
                      new_persons_vaccinated = c(100, 200, 150, 250, 120, 180) + rnorm(6, sd = 10),
                      new_hospitalized_patients = c(5, 10, 7, 12, 4, 8) + rnorm(6, sd = 1),
                      new_confirmed = c(20, 30, 25, 35, 18, 22) + rnorm(6, sd = 2),
                      new_intensive_care_patients = c(2, 3, 2, 4, 1, 2) + rnorm(6, sd = 0.5))

test_df <- data.frame(date = as.Date(c("2020-01-01", "2020-01-02", "2020-01-02", 
                                       "2020-01-24", "2020-01-23", "2020-03-06")),
                      search_trends_anxiety = c(1.2, 1.6, 1.7, 1.6, 1.1, 2.5) + rnorm(6, sd = 0.1),
                      new_persons_vaccinated = c(100, 231, 122, 250, 150, 180) + rnorm(6, sd = 10),
                      new_hospitalized_patients = c(7, 10, 7, 14, 4, 12) + rnorm(6, sd = 1),
                      new_confirmed = c(23, 30, 25, 44, 18, 32) + rnorm(6, sd = 2),
                      new_intensive_care_patients = c(3, 2, 2, 5, 1, 2) + rnorm(6, sd = 0.5))

# create train.test data frame with date as numeric
numeric_train_df <- train_df |> 
                    mutate(date = as.numeric(date))

numeric_test_df <- test_df |> 
                   mutate(date = as.numeric(date))

# Train the linear model using sourced make_final_lm_model()
final_model <- make_final_lm_model(numeric_train_df)

# Test 1: Successful execution with valid inputs and csv output
temp_file <- tempfile(fileext = ".csv")
on.exit(unlink(temp_file)) # deletes temp file/directories.


# Employ model_predictions() with temp output_file as 3rd argument
result <- model_predictions(final_model, numeric_test_df, temp_file)

# Check whether result is a tibble with expected RMSPE and R_square columns
expect_s3_class(result, "tbl_df")
expect_equal(names(result), c("RMSPE", "R_square"))

# Check that the file was created and contains the expected data
expect_true(file.exists(temp_file))
saved_data <- read_csv(temp_file, show_col_types = FALSE) |>
              as_tibble()
expect_equal(saved_data, result, ignore_attr = TRUE) 
# only interested in comparing the data values, so ignore class differences

# Check that R_square matches the model's R²
expect_equal(result$R_square, summary(final_model)$r.squared)

# Check that RMSPE is a positive numeric value
expect_type(result$RMSPE, "double")
expect_true(result$RMSPE > 0)

})


# Test 2: expect fails with non-numeric date
test_that("model_predictions fails with non-numeric date", {
  # Create a test dataset with non-numeric date
  set.seed(123)
  start_date <- as.Date("2020-01-01")
  dates <- seq.Date(start_date, by = "day", length.out = 6)
  
  invalid_df <- data.frame(
    date = as.character(dates),  # Non-numeric date
    search_trends_anxiety = rnorm(6),
    new_persons_vaccinated = rnorm(6),
    new_hospitalized_patients = rnorm(6),
    new_confirmed = rnorm(6),
    new_intensive_care_patients = rnorm(6)
  )
  
  # Create a valid training dataset for the model
  train_df <- data.frame(
    date = seq.Date(start_date, by = "day", length.out = 6),
    search_trends_anxiety = rnorm(6),
    new_persons_vaccinated = rnorm(6),
    new_hospitalized_patients = rnorm(6),
    new_confirmed = rnorm(6),
    new_intensive_care_patients = rnorm(6)
  ) |> 
    mutate(date = as.numeric(date - min(date)))
  final_model <- make_final_lm_model(train_df)
  
  temp_file <- tempfile(fileext = ".csv")
  on.exit(unlink(temp_file))
  
  # Expect an error due to non-numeric date
  expect_error(
    model_predictions(final_model, invalid_df, temp_file),
    "Date is not numeric"
  )
})
