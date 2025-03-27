library(tibble)
library(dplyr)
library(tidyr)
library(here)

source(here::here("R", "eda_tbl.R"))


test_that("summarize_covid_data outputs a complete summary table", {
  raw <- tibble(
    date = as.Date(c("2020-01-01", "2020-01-02", NA)),
    search_trends_anxiety = c(1.1, 2.2, NA),
    new_persons_vaccinated = c(100, 200, NA),
    new_hospitalized_patients = c(3, 5, NA),
    new_confirmed = c(50, 60, NA),
    new_intensive_care_patients = c(1, 2, NA)
  )

  processed <- raw |> drop_na()

  summary_df <- summarize_covid_data(raw, processed)

  expect_s3_class(summary_df, "data.frame")
  expect_true(all(c("Variable", "Min", "Mean", "Missing") %in% colnames(summary_df)))
  expect_equal(nrow(summary_df), 6)  # 5 variables + date
})
