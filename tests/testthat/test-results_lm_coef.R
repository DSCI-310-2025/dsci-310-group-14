library(testthat)
library(here)
library(tidyverse) 
library(tidymodels)
source(here::here("R", "make_final_lm_model.R"))
source(here::here("R", "results_lm_coef.R"))


# utilize tempfile for test output file
output_file <- tempfile(fileext = ".csv")

# create non lm object to give as argument
missing_col_df <- tibble(class_labels = rep(c("date",
                                              "search_trends_anxiety"), 2),
                            values = round(runif(4), 1))

# create test dataframes
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

# create test dataframe object
test_lm <- make_final_lm_model(test_df)

# test that 
test_that("`results_lm_coef` should throw an error when incorrect types
are passed to the `lm_model` argument", {
  expect_error(results_lm_coef(missing_col_df, output_file))
})

# test that the correct table is returned
test_that("`results_lm_coef` should throw an error when incorrect types 
          are passed to the `lm_model` argument", {
  expect_equal(results_lm_coef(test_lm, output_file), 
               tidy(make_final_lm_model(test_df)))
})

#read_csv(output_file)
#print(output_file)

# test that the csv is written
test_that("`results_lm_coef` should write a file named lm_coef.csv", {
  if (file.exists(output_file)) {
    file.remove(output_file)
  }
  results_lm_coef(test_lm, output_file)
  print(output_file)
  expect_true(file.exists(output_file))
  file.remove(output_file)
})

