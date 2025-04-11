suppressWarnings({
  library(testthat)
  library(here)
  library(tidyverse)
  library(leaps)
})

source(here("R", "feature_selection.R"))

create_test_data <- function(rows = 30) {
  tibble(
    date = seq.Date(as.Date("2020-01-01"), by = "day", length.out = rows),
    search_trends_anxiety = rnorm(rows),
    new_persons_vaccinated = rnorm(rows),
    new_hospitalized_patients = rnorm(rows),
    new_confirmed = rnorm(rows),
    new_intensive_care_patients = rnorm(rows)
  )
}

test_that("function returns correct structure", {
  test_data <- create_test_data()
  result <- feature_selection(test_data)
  
  expect_type(result, "list")
  expect_named(result, c("selected_features", "selection_summary", "performance"))
  expect_true("date" %in% names(result$selection_summary))
})

test_that("parameter handling works correctly", {
  test_data <- create_test_data()
  
  # Test normal nvmax values
  expect_equal(nrow(feature_selection(test_data, nvmax = 3)$performance), 3)
  
  # Test nvmax larger than predictors
  expect_warning(
    result <- feature_selection(test_data, nvmax = 10),
    "nvmax reduced"
  )
  expect_equal(nrow(result$performance), 5)
})

test_that("input validation works", {
  good_data <- create_test_data()
  
  # Missing columns
  bad_data <- select(good_data, -new_confirmed)
  expect_error(feature_selection(bad_data), "missing required columns")
  
  # NA values
  na_data <- good_data
  na_data$new_hospitalized_patients[1:3] <- NA
  expect_silent(feature_selection(na_data))  # NAs are now automatically dropped
})
