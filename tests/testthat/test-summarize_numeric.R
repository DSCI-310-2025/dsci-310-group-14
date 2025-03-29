library(testthat)
source(here::here("R", "summarize_numeric.R"))

# Test 1: base test-multiple numeric columns (2 columns)
test_that("summarize_numeric computes correct statistics for multiple columns", {
  test_data <- data.frame(a = c(1, 2, 3, 4, 5),
                          b = c(10, 20, 30, 40, 50))
  
  expected <- tibble::tibble(Variable = c("a", "b"), Min = c(1, 10), 
                              Q25 = c(2, 20),   Mean = c(3, 30), 
                           Median = c(3, 30),    Q75 = c(4, 40), 
                              Max = c(5, 50))
  
  result <- summarize_numeric(test_data)
  expect_equal(result, expected, tolerance = 1e-6)  # Small tolerance for floating-point precision
})


# Test 2: single numeric column
test_that("summarize_numeric works with a single numeric column", {
  test_data <- data.frame(x = c(1, 2, 3))
  
  expected <- tibble::tibble(Variable = "x",  Min = 1, Q25 = 1.5, 
                             Mean = 2, Median = 2, Q75 = 2.5, 
                              Max = 3)
  
  result <- summarize_numeric(test_data)
  expect_equal(result, expected, tolerance = 1e-6)
})

# Test 3: Mixed data with non-numeric columns, 
#         text column should be ignored by function
test_that("summarize_numeric ignores non-numeric columns", {
  test_data <- data.frame(num  = c(1, 2, 3), 
                          text = c("a", "b", "c"))
  
  expected <- tibble::tibble(Variable = "num", Min = 1, Q25 = 1.5,
                             Mean = 2,  Median = 2, Q75 = 2.5, Max = 3)
  
  result <- summarize_numeric(test_data)
  expect_equal(result, expected, tolerance = 1e-6)})



# Test 4: Edge case - all identical values
test_that("summarize_numeric handles identical values", {
  test_data <- data.frame(a = c(5, 5, 5, 5))
  
  expected <- tibble::tibble(Variable = "a", Min = 5, Q25 = 5, 
                             Mean = 5, Median = 5, Q75 = 5, Max = 5)
  
  result <- summarize_numeric(test_data)
  expect_equal(result, expected, tolerance = 1e-6)})


# Test 5: Edge case - single value (one row, one column in the dataframe)
test_that("summarize_numeric works with a single value", {
  test_data <- data.frame(a = 42)
  
  expected <- tibble::tibble(Variable = "a", Min = 42, Q25 = 42, 
                             Mean = 42, Median = 42, Q75 = 42, Max = 42)
  
  result <- summarize_numeric(test_data)
  expect_equal(result, expected, tolerance = 1e-6)})




