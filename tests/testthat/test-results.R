library(testthat)
library(here)
source(here("R", "results.R"))

# create test data 

# incorrect dataframes
missing_col_df <- tibble(class_labels = rep(c("date",
                                                 "search_trends_anxiety"), 2),
                            values = round(runif(4), 1))

empty_df  <- tibble(class_labels = character(0),
                    values = double(0))

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

# create test coef results
make_final_lm_model(test_df)
test_result <- lm(search_trends_anxiety ~ new_persons_vaccinated + new_hospitalized_patients + date,
     data = test_df)

# test incorrect dataframe used as argument
test_that("`count_classes` should throw an error when incorrect types
are passed to the `data_frame` argument", {
  expect_error(make_final_lm_model(empty_df))
})

# test incorrect dataframe used as argument
test_that("`count_classes` should throw an error when incorrect types
are passed to the `data_frame` argument", {
  expect_error(make_final_lm_model(missing_col_df))
})

# test correct type produced
test_that("`count_classes` should throw an error when incorrect types
are passed to the `data_frame` argument", {
  expect_s3_class(make_final_lm_model(test_df), "lm")
})

# test correct coef produed
test_that("`count_classes` should throw an error when incorrect types
are passed to the `data_frame` argument", {
  expect_equal(coef(make_final_lm_model(test_df)), coef(test_result))
})
