#' Load covid data
#' 
#' Simplified reading 
#' @param file_path Path to CSV file or URL
#' @return A tibble with the loaded data

load_data <- function(file_path) {
  # Check if the file exists
  if (!file.exists(file_path)) {
    stop("File does not exist: ", file_path)
  }
  
  # Check if the file is empty
  if (file.size(file_path) == 0) {
    stop("File is empty: ", file_path)
  }
  
  readr::read_csv(file_path, show_col_types = FALSE)
}