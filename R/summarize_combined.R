# R/summarize_combined.R


#' Summarize Date Column as Numeric Days
#'
#' @param dates A vector of dates (or a data frame column of dates).
#' @return A data frame with summary statistics for the date column, 
#' #       converted back to dates after after summary stats are calculated.
#' @examples
#' # dates <- as.Date(c("2020-01-01", "2020-01-02"))
#' # summarize_dates(dates)
summarize_dates <- function(dates) {
  requireNamespace("dplyr", quietly = TRUE)
  requireNamespace("tibble", quietly = TRUE)
  
  dates_day <- as.numeric(dates)
  tibble::tibble(Variable = "date",
                 Min = min(dates_day),
                 Q25 = quantile(dates_day, 0.25),
                 Mean = mean(dates_day),
                 Median = median(dates_day),
                 Q75 = quantile(dates_day, 0.75),
                 Max = max(dates_day)) %>%
    dplyr::mutate(dplyr::across(dplyr::where(is.numeric), as.Date))
}

