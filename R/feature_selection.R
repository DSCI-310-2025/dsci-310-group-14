#' perform feature selection using backward selection
#'
#' @param df Data frame containing the data
#' @param initial_test_size Proportion of data for initial test split (default: 0.3)
#' @param train_size Proportion of remaining data for training (default: 0.7)
#' @param nvmax Maximum number of variables to include in model (default: 5)
#' @return List containing:
#'   - train_data: Training data with numeric dates
#'   - test_data: Testing data with numeric dates
#'   - selection_summary: Summary of selected variables
#'   - performance: Model performance metrics
feature_selection <- function(df, initial_test_size = 0.3, train_size = 0.7, nvmax = 5) {

  
  # Split data
  initial_test <- sample_n(df, size = nrow(df) * initial_test_size, replace = FALSE)
  remaining_data <- anti_join(df, initial_test, by = "date")
  
  train_set <- sample_n(remaining_data, size = nrow(remaining_data) * train_size, replace = FALSE)
  test_set <- anti_join(remaining_data, train_set, by = "date")
  
  # Convert dates to numeric
  train_numeric <- train_set |> mutate(date = as.numeric(date))
  test_numeric <- test_set |> mutate(date = as.numeric(date))
  
  # Backward selection
  backward_model <- regsubsets(
    search_trends_anxiety ~ new_persons_vaccinated + 
                            new_hospitalized_patients +
                            new_confirmed +
                            new_intensive_care_patients + date,
    nvmax = nvmax,
    data = train_numeric,
    method = "backward"
  )
  
  model_summary <- summary(backward_model)
  
  # Prepare results
  results <- list(
    train_data = train_numeric,
    test_data = test_numeric,
    selection_summary = as_tibble(model_summary[["which"]]),
    performance = tibble(
      n_input_variables = 1:nvmax,
      RSQ = model_summary$rsq,
      RSS = model_summary$rss,
      ADJ.R2 = model_summary$adjr2
    )
  )
  
  return(results)
}