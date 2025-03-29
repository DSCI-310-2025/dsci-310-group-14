library(tibble)
library(ggplot2)
library(here)

source(here("R", "eda_viz.R"))

test_that("plot_anxiety_time_series returns a ggplot object", {
  df <- tibble(
    date = as.Date(c("2020-01-01", "2020-01-02", "2020-01-03")),
    search_trends_anxiety = c(10, 20, 30)
  )

  p <- plot_anxiety_time_series(df)

  expect_s3_class(p, "ggplot")
  expect_true("GeomLine" %in% class(p$layers[[1]]$geom))
})
 
