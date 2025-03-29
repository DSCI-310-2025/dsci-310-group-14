#' Create Pairs Plot and Save Plot
#'
#' Generates a pairs plot for all variables in the dataset using ggpairs and saves it to a file.
#'
#' @param data A data frame containing the variables to plot.
#' @param output_file Path to save the output figure.
#' @param width Width of the plot in inches (default: 16).
#' @param height Height of the plot in inches (default: 12).
#' @return None (saves the plot to a file).
#' @examples
#' data <- data.frame(a = 1:3, b = 4:6)
#' create_pairs_plot(data, "pairs_plot.png")
create_pairs_plot <- function(data, output_file, width = 16, height = 12) {
  options(repr.plot.width = width, repr.plot.height = height)
  
  plot <- ggpairs(data, aes(alpha = 0.5)) +
    theme(text = element_text(size = 13)) +
    ggtitle("Pairs plot for all variables of interest for exploration") +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
  
  ggsave(output_file, plot)
}