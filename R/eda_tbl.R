#' Summarize COVID data
#'
#' Generates summary statistics and missing data counts from the raw and processed COVID datasets.
#'
#' @param raw_df The unprocessed COVID dataset
#' @param processed_df The cleaned/processed COVID dataset
#'
#' @return A data frame with summary statistics and missing data counts
#' @export
summarize_covid_data <- function(raw_df, processed_df) {
  covid_summary <- processed_df %>%
    summarise(across(where(is.numeric), list(
      Min = min,
      Q25 = ~quantile(.x, 0.25),
      Mean = mean,
      Median = median,
      Q75 = ~quantile(.x, 0.75),
      Max = max
    ), .names = "{.col}_{.fn}")) %>%
    pivot_longer(cols = everything(), names_to = c("Variable", "Statistic"), names_sep = "_(?=[^_]+$)") %>%
    pivot_wider(names_from = Statistic, values_from = value)

  dates_day <- as.numeric(processed_df$date)
  date_summary <- tibble(
    Variable = c("date"),
    Min = min(dates_day),
    Q25 = quantile(dates_day, 0.25),
    Mean = mean(dates_day),
    Median = median(dates_day),
    Q75 = quantile(dates_day, 0.75),
    Max = max(dates_day)
  ) %>% mutate(across(where(is.numeric), as_date))

  table_summary <- rbind(covid_summary, date_summary)

  us_missing_counts <- tibble(
    Variable = table_summary$Variable,
    Observations = colSums(!is.na(raw_df[, table_summary$Variable, drop = FALSE])),
    Missing = colSums(is.na(raw_df[, table_summary$Variable, drop = FALSE]))
  )

  inner_join(table_summary, us_missing_counts, by = "Variable")
}
