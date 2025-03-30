test_that("load_data reads CSV files correctly", {
  # Create temp test file
  test_file <- tempfile(fileext = ".csv")
  write.csv(data.frame(a = 1:3, b = letters[1:3]), test_file, row.names = FALSE)
  on.exit(unlink(test_file))
  
  result <- load_data(test_file)
  expect_s3_class(result, "tbl_df")
  expect_equal(ncol(result), 2)
  expect_equal(nrow(result), 3)
})

test_that("load_data returns tibble for empty files", {
  empty_file <- tempfile()
  file.create(empty_file)
  on.exit(unlink(empty_file))
  
  expect_s3_class(load_data(empty_file), "tbl_df")
  expect_error(load_data("nonexistent_file.csv"))
})