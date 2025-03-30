#' Load covid data
#' 
#' Simplified reading 
#' @param file_path Path to CSV file or URL
#' @return A tibble with the loaded data

load_data <- function(file_path) {
  readr::read_csv(file_path, show_col_types = FALSE)
}