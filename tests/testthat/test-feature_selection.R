library(testthat)
library(here)
source(here("R", "feature_selection.R"))

test_that("feature_selection works with valid input", {
  #test data with some noise
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
  
  #function with default param
  result <- feature_selection(test_df)
  
  #test output structure
  expect_type(result, "list")
  expect_named(result, c("train_data", "test_data", "selected_features", "performance"))
  
  #training data
  expect_s3_class(result$train_data, "data.frame")
  expect_true(nrow(result$train_data) > 0)
  expect_type(result$train_data$date, "double")
  
  #performance metrics
  expect_s3_class(result$performance, "data.frame")
  expect_true("RSQ" %in% names(result$performance))
})

test_that("perform_feature_selection handles missing columns", {
  #incomplete test data
  bad_df <- data.frame(
    date = as.Date(c("2020-01-01", "2020-01-02")),
    search_trends_anxiety = c(1.2, 1.5)
  )
  
  expect_error(
    feature_selection(bad_df),
    "Missing required columns"
  )
})

test_that("feature_selection works with custom parameters", {
  set.seed(123)
  test_df <- data.frame(
    date = as.Date(c("2020-01-01", "2020-01-02", "2020-01-03", 
                    "2020-01-04", "2020-01-05", "2020-01-06", 
                    "2020-01-07", "2020-01-08", "2020-01-09")),
    search_trends_anxiety = c(1.2, 1.5, 1.3, 1.6, 1.1, 1.4, 1.3, 1.7, 1.2) + rnorm(9, sd = 0.1),
    new_persons_vaccinated = c(100, 200, 150, 250, 120, 180, 160, 220, 140) + rnorm(9, sd = 10),
    new_hospitalized_patients = c(5, 10, 7, 12, 4, 8, 6, 11, 5) + rnorm(9, sd = 1),
    new_confirmed = c(20, 30, 25, 35, 18, 22, 24, 32, 19) + rnorm(9, sd = 2),
    new_intensive_care_patients = c(2, 3, 2, 4, 1, 2, 3, 4, 2) + rnorm(9, sd = 0.5)
  )
  
  #custom param
  result <- feature_selection(
    df = test_df,
    initial_test_size = 0.2,
    train_size = 0.6,
    nvmax = 3
  )
  
  expect_true(nrow(result$performance) <= 3)  # nvmax = 3
})