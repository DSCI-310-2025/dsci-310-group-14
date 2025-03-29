#' Load Raw COVID-19 Data
#'
#' Reads COVID-19 data from a CSV file without modification.
#' All cleaning/processing should be done in separate functions.
#'
#' @param data_path Path to the CSV file. Expected columns:
#'   - date (YYYY-MM-DD)
#'   - search_trends_anxiety
#'   - new_persons_vaccinated
#'   - new_hospitalized_patients
#'   - new_confirmed
#'   - new_intensive_care_patients
#'
#' @return A tibble with raw data (preserves all columns and NAs)
#' @export

load_covid_data <- function(data_path) {
  if (!file.exists(data_path)) {
    stop("File not found: ", data_path)
  }
  
  readr::read_csv(
    data_path,
    show_col_types = FALSE  # Silences type messages
  )
}