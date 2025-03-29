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
                 Q25 = unname(quantile(dates_day, 0.25)),
                 Mean = mean(dates_day),
                 Median = median(dates_day),
                 Q75 = unname(quantile(dates_day, 0.75)),
                 Max = max(dates_day)) %>%
    dplyr::mutate(dplyr::across(dplyr::where(is.numeric), as.Date))
}



#' Add Missing N/A Value Counts to Summary stats and Combine Summaries
#'
#' @param original_data The original data frame to count missing values from.
#' @param numeric_summary Summary table from summarize_numeric().
#' @param date_summary Summary table from summarize_dates().
#' @param vars Variables to check for missing values (default matches your study).
#' @return A combined data frame with summary statistics and missing value counts.
#' # Note: add_missing_counts() expects a numeric_summary from summarize_numeric()
#' 
#' @examples
#' # original <- data.frame(a = c(1, NA), b = c(2, 3))
#' # num_summary <- summarize_numeric(original)
#' # combined <- add_missing_counts(original, num_summary, NULL, vars = c("a", "b"))
#' 
add_missing_counts <- function(original_data, numeric_summary, date_summary = NULL, 
                               vars = c("date", "search_trends_anxiety", "new_persons_vaccinated", 
                                        "new_hospitalized_patients", "new_confirmed", 
                                        "new_intensive_care_patients")) {
  requireNamespace("dplyr", quietly = TRUE)
  requireNamespace("tibble", quietly = TRUE)
  
  # Combine numeric and date summaries
  if (!is.null(date_summary)) {
    table_summary <- dplyr::bind_rows(numeric_summary, date_summary)
  } else {
    table_summary <- numeric_summary
  }
  
  # Count missing values from original data
  us_missing <- original_data %>%
    dplyr::select(dplyr::all_of(vars))
  missing_counts <- tibble::tibble(
    Variable = table_summary$Variable,
    Observations = colSums(!is.na(us_missing)),
    Missing = colSums(is.na(us_missing))
  )
  
  # Combine with summary table
  table_summary_final <- dplyr::inner_join(table_summary, missing_counts, by = "Variable")
  return(table_summary_final)
}

