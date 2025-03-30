#' perform backward feature selection on COVID data
#' @param df Data frame containing the expected columns
#' @param initial_test_size size for initial holdout set 
#' @param train_size proportion for training after holdout 
#' @param nvmax maximum number of variables to include 
#' @return a list with:
#'   - train_data: the training set with numeric dates
#'   - test_data: test set with numeric dates
#'   - selected_features: character vector of selected features
#'   - performance: data frame with model metrics
#' @export
#' 

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