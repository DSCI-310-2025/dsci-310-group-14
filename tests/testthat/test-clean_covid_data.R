source("R/clean_covid_data.R")

test_that("clean_covid_data selects correct columns and removes NAs", {
  sample_df <- data.frame(
    date = as.Date(c("2020-01-01", "2020-01-02")),
    search_trends_anxiety = c(1.2, NA),
    new_persons_vaccinated = c(100, 200),
    new_hospitalized_patients = c(5, NA),
    new_confirmed = c(20, 30),
    new_intensive_care_patients = c(2, 3),
    irrelevant_column = c("A", "B")
  )
  
  cleaned_df <- clean_covid_data(sample_df)

  # Check: No NAs
  expect_false(any(is.na(cleaned_df)))

  # Check: Correct columns retained
  expected_cols <- c("date", "search_trends_anxiety", "new_persons_vaccinated", 
                     "new_hospitalized_patients", "new_confirmed", "new_intensive_care_patients")
  expect_equal(colnames(cleaned_df), expected_cols)
})
