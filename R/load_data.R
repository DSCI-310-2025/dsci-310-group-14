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
#' @return A tibble with raw data (keeps all columns and NAs)
#' @export

load_covid_data <- function(data_path) {
  if (!file.exists(data_path)) {
    stop("File not found: ", data_path)
  }
  
  # the empty files and files with just headers catch
  if (file.size(data_path) == 0) {
    return(tibble::tibble(
      date = as.Date(character()),
      search_trends_anxiety = numeric(),
      new_persons_vaccinated = numeric(),
      new_hospitalized_patients = numeric(),
      new_confirmed = numeric(),
      new_intensive_care_patients = numeric()
    ))
  }
  
  # reading with explicit column specifications
  readr::read_csv(
    data_path,
    col_types = readr::cols(
      date = readr::col_date(format = ""),
      search_trends_anxiety = readr::col_double(),
      new_persons_vaccinated = readr::col_double(),
      new_hospitalized_patients = readr::col_double(),
      new_confirmed = readr::col_double(),
      new_intensive_care_patients = readr::col_double()
    ),
    show_col_types = FALSE
  )
}