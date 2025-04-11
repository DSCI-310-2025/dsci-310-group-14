library(testthat)
library(here)

source(here("R", "load_data.R"))  # Make sure this is still at the top!

test_that("load_data reads CSV files correctly", {
  test_file <- tempfile(fileext = ".csv")
  write.csv(data.frame(a = 1:3, b = letters[1:3]), test_file, row.names = FALSE)
  on.exit(unlink(test_file))

  result <- load_data(test_file)
  expect_s3_class(result, "tbl_df")
  expect_equal(ncol(result), 2)
  expect_equal(nrow(result), 3)
})

test_that("load_data errors on empty or nonexistent files", {
  empty_file <- tempfile()
  file.create(empty_file)
  on.exit(unlink(empty_file), add = TRUE)

  expect_error(load_data(empty_file))  # change: now expect an error
  expect_error(load_data("nonexistent_file.csv"))  # same
})
