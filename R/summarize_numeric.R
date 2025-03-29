# R/summary_numeric.R

#' Compute Summary Statistic for Numeric Columns
#' 
#' @param data A data frame with description with numeric columns to be 
#'        summarized (assumed to have no NAs)
#' @return A data frame in wide format with summary stats.
#' @examples
#' # data <- data.frame(a = c(1,2,3), b = c(4,5,6))
#' # summarize_numeric(data)
#' 

summarize_numeric <- function(data) {
  requireNamespace("dplyr", quietly = TRUE) # requireNamespace allows for :: operator
  requireNamespace("tidyr", quietly = TRUE)
  
  data |>
    dplyr::summarize(dplyr::across(dplyr::where(is.numeric), list(
         Min = min,
         Q25 = ~quantile(.x, .25),
        Mean = mean,
      Median = median,
         Q75 = ~quantile(.x, .75),
         Max = max),
      .names = "{.col}_{.fn}")) |>
        tidyr::pivot_longer(     cols = dplyr::everything(),
                             names_to = c("Variable", "Statistic"),
                            names_sep = "_(?=[^_]+$)") |>
        tidyr::pivot_wider(names_from = Statistic, values_from = value)
}
