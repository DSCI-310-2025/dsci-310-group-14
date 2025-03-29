library(here)
source(here("R", "load_data.R"))

test_that("load_covid_data loads covid file", {
  test_file <- tempfile(fileext = ".csv")
  writeLines(
    "date,
    search_trends_anxiety,
    new_persons_vaccinated,
    new_hospitalized_patients,
    new_confirmed,
    new_intensive_care_patients\n2020-01-01,1.2,100,5,20,2\n2020-01-02,1.5,200,10,30,3",
    test_file
  )

  df <- load_covid_data(test_file)
  
  expect_s3_class(df, "data.frame")
  expect_equal(ncol(df), 6)
  expect_equal(nrow(df), 2)
  expect_s3_class(df$date, "Date")
  expect_type(df$search_trends_anxiety, "double")
  
  unlink(test_file)
})

test_that("load_covid_data can empty covid file", {
  empty_file <- tempfile(fileext = ".csv")
  file.create(empty_file)
  
  df <- load_covid_data(empty_file)
  expect_s3_class(df, "data.frame")
  expect_equal(nrow(df), 0)
  expect_equal(ncol(df), 6)
  unlink(empty_file)
  
  #file with only headers
  header_file <- tempfile(fileext = ".csv")
  writeLines(
    "date,
    search_trends_anxiety,
    new_persons_vaccinated,
    new_hospitalized_patients,
    new_confirmed,
    new_intensive_care_patients",
    header_file
  )
  
  df <- load_covid_data(header_file)
  expect_s3_class(df, "data.frame")
  expect_equal(nrow(df), 0)
  expect_equal(ncol(df), 6)
  unlink(header_file)
})

test_that("load_covid_data fails when file does not exist", {
  expect_error(load_covid_data("non_existent_file.csv"), "File not found")
})