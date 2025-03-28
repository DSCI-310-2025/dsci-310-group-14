#' Plot anxiety search trends over time
#'
#' @param df A data frame with at least `date` and `search_trends_anxiety` columns
#'
#' @return A ggplot object
#' @export
plot_anxiety_time_series <- function(df) {
  ggplot(df, aes(x = date, y = search_trends_anxiety)) +
    geom_line(color = "cornflower blue") +
    labs(
      title = "Google Searches Regarding Anxiety over Time",
      x = "Date",
      y = "Normalized Search Volume"
    ) +
    theme(text = element_text(size = 13))
}
