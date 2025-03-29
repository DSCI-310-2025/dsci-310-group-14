library(testthat)
library(tidyverse)
library(GGally)

# Source the script containing the function
source(here::here("R", "eda_viz_pairplot.R"))

# Test 1: create_pairs_plot generates a file with valid input
test_that("create_pairs_plot generates a file with valid input", {
  # Sample data
  test_data <- data.frame(
    a = c(1, 2, 3),
    b = c(4, 5, 6),
    c = c(7, 8, 9)
  )
  output_file <- tempfile(fileext = ".png")
  
  # Run the function
  create_pairs_plot(test_data, output_file)
  
  # Check if file exists
  expect_true(file.exists(output_file))
  
  # Clean up
  file.remove(output_file)
})

# Test 2: create_pairs_plot handles custom width and height
test_that("create_pairs_plot handles custom width and height", {
  test_data <- data.frame(
    x = rnorm(10),
    y = rnorm(10)
  )
  output_file <- tempfile(fileext = ".png")
  
  # Run with custom dimensions
  create_pairs_plot(test_data, output_file, width = 10, height = 8)
  
  # Check if file exists
  expect_true(file.exists(output_file))
  
  # Optionally check file size (rough proxy for dimensions)
  file_info <- file.info(output_file)
  expect_true(file_info$size > 0)  # Ensure it’s not empty
  
  # Clean up
  file.remove(output_file)
})


# Test 4: create_pairs_plot handles missing values
test_that("create_pairs_plot handles missing values", {
  test_data <- data.frame(
    a = c(1, 2, NA, 7, 1),
    b = c(4, NA, 6, 9, 6)
  )
  output_file <- tempfile(fileext = ".png")
  
  # Allow and expect warning, but should be no error
  expect_warning(
    create_pairs_plot(test_data, output_file),
    regexp = "Removed.*rows.*missing values")  # Optional: match specific warning
  
  # Check if file exists
  expect_true(file.exists(output_file))
  
  # Clean up
  file.remove(output_file)
})
