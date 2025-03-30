#' Plot anxiety search trends over time
#'
#' @param df A data frame with at least `date` and `search_trends_anxiety` columns
#' @param output_file Path to save the output figure.
#' @return A ggplot object
#' @export
plot_anxiety_time_series <- function(df, output_file) {
  plot <- ggplot(df, aes(x = date, y = search_trends_anxiety)) +
    geom_line(color = "cornflower blue") +
    labs(
      title = "Google Searches Regarding Anxiety over Time",
      x = "Date",
      y = "Normalized Search Volume"
    ) +
    theme(text = element_text(size = 13))
  
  # Save the plot using ggsave
  ggsave(output_file, plot = plot, width = 10, height = 6)
  
  return(plot) # Optional, if you want to return the plot object itself
}
