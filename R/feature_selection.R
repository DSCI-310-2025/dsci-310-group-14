#' Perform backward feature selection on COVID data
#' @param df Data frame containing the expected columns
#' (must include date and all predictor variables)
#' @param nvmax Maximum number of variables to include (default: 5)
#' @return A list with:
#'   - selected_features: Character vector of selected features
#'   - selection_summary: Tibble showing which variables
#'     were selected at each step
#'   - performance: Data frame with model metrics (RSQ, RSS, ADJ.R2)
#' @export
feature_selection <- function(df, nvmax = 5) {
  # Validate input
  required_cols <- c("date",
                     "search_trends_anxiety",
                     "new_persons_vaccinated",
                     "new_hospitalized_patients",
                     "new_confirmed",
                     "new_intensive_care_patients")
  
  if (!all(required_cols %in% names(df))) {
    stop("Input data missing required columns")
  }
  
  if (nrow(df) < 3) {
    warning("Very small dataset - results may be unreliable")
  }
  
  # Convert dates to numeric
  df_numeric <- df |> 
    dplyr::mutate(date = as.numeric(date)) |> 
    tidyr::drop_na()  # Remove rows with NAs
  
  # Adjust nvmax if too large
  max_predictors <- 5  # Number of predictors in formula
  if (nvmax > max_predictors) {
    warning("nvmax reduced to ", max_predictors, " (number of predictors)")
    nvmax <- max_predictors
  }
  
  # Backward selection
  tryCatch({
    backward_model <- leaps::regsubsets(
      search_trends_anxiety ~ new_persons_vaccinated +
        new_hospitalized_patients +
        new_confirmed +
        new_intensive_care_patients + date,
      nvmax = nvmax,
      data = df_numeric,
      method = "backward"
    )
    
    model_summary <- summary(backward_model)
    
    # Prepare results
    list(
      selected_features = names(which(model_summary$which[which.max(model_summary$adjr2), ]))[-1],
      selection_summary = tibble::as_tibble(model_summary[["which"]]),
      performance = tibble::tibble(
        n_input_variables = 1:nvmax,
        RSQ = model_summary$rsq,
        RSS = model_summary$rss,
        ADJ.R2 = model_summary$adjr2
      )
    )
  }, error = function(e) {
    stop("Feature selection failed: ", e$message)
  })
}