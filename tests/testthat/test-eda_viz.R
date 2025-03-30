library(tibble)
library(ggplot2)
library(here)
library(testthat)

source(here("R", "eda_viz.R"))

test_that("plot_anxiety_time_series returns a ggplot object", {
  df <- tibble(date = as.Date(c("2020-01-01", "2020-01-02", "2020-01-03")),
              search_trends_anxiety = c(10, 20, 30))
  
  # Use a temporary file for output
  output_file <- tempfile(fileext = ".png")
 
  # this checks whether the file exist before running the test else remove
  if (file.exists(output_file)) { 
    file.remove(output_file)
  }
  
  p <- plot_anxiety_time_series(df, output_file)

  expect_s3_class(p, "ggplot")
  expect_true("GeomLine" %in% class(p$layers[[1]]$geom))
  
  # cleaning!! remove the temporary file:
  file.remove(output_file)
})
 
