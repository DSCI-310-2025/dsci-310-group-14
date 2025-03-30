library(testthat)
library(here)
library(tidyverse)
library(leaps)

source(here("R", "feature_selection.R"))


create_test_data <- function() {
  tibble(
    date = seq.Date(as.Date("2020-01-01"), as.Date("2020-01-30"), by = "day"),
    search_trends_anxiety = rnorm(30),
    new_persons_vaccinated = rnorm(30),
    new_hospitalized_patients = rnorm(30),
    new_confirmed = rnorm(30),
    new_intensive_care_patients = rnorm(30)
  )
}

test_that("feature_selection returns correct object types", {
  test_data <- create_test_data()
  result <- feature_selection(test_data, nvmax = 3)
  
  expect_type(result, "list")
  expect_named(result, c("train_data", "test_data", "selection_summary", "performance"))
  expect_s3_class(result$train_data, "tbl_df")
  expect_s3_class(result$test_data, "tbl_df")
  expect_s3_class(result$selection_summary, "tbl_df")
  expect_s3_class(result$performance, "tbl_df")
})

test_that("feature_selection handles different nvmax values", {
  test_data <- create_test_data()
  
  result3 <- feature_selection(test_data, nvmax = 3)
  expect_equal(nrow(result3$performance), 3)
  
  result5 <- feature_selection(test_data, nvmax = 5)
  expect_equal(nrow(result5$performance), 5)
})

test_that("feature_selection splits data correctly", {
  test_data <- create_test_data()
  result <- feature_selection(test_data, initial_test_size = 0.2, train_size = 0.75)
  

  total_rows <- nrow(test_data)
  initial_test_rows <- round(total_rows * 0.2)
  remaining_rows <- total_rows - initial_test_rows
  train_rows <- round(remaining_rows * 0.75)
  test_rows <- remaining_rows - train_rows
  
  expect_equal(nrow(result$train_data), train_rows)
  expect_equal(nrow(result$test_data), test_rows)
})

test_that("feature_selection converts dates to numeric", {
  test_data <- create_test_data()
  result <- feature_selection(test_data)
  
  expect_type(result$train_data$date, "double")
  expect_type(result$test_data$date, "double")
})