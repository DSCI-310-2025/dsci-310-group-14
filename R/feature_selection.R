#' perform backward feature selection on COVID data
#' @param df Data frame containing with the expected columns
#' @param initial_test_size size for initial holdout set 
#' @param train_size proportion for training after holdout 
#' @param nvmax maximum number of variables to include 
#' @return a list with:
#'   - train_data: the training set with numeric dates
#'   - test_data: test set with numeric dates
#'   - selection_summary: the variables selected at each step (tibble)
#'   - performance: the model metrics (tibble with RSQ, RSS, ADJ.R2)
#' @export
perform_feature_selection <- function(df, initial_test_size = 0.3, train_size = 0.7, nvmax = 5) {
  # Input validation
  required_cols <- c("date", "search_trends_anxiety", "new_persons_vaccinated",
                    "new_hospitalized_patients", "new_confirmed", "new_intensive_care_patients")
  
  if (!all(required_cols %in% names(df))) {
    missing <- setdiff(required_cols, names(df))
    stop("Missing required columns: ", paste(missing, collapse = ", "))
  }
  
  # copy original split logic
  bwd_select_train <- df %>% 
    sample_n(size = nrow(df) * initial_test_size, replace = FALSE)
  
  model_data <- anti_join(df, bwd_select_train, by = "date")
  
  covid_train <- model_data %>% 
    sample_n(size = nrow(model_data) * train_size, replace = FALSE)
  
  covid_test <- anti_join(model_data, covid_train, by = "date")
  
  # convert dates to numeric
  covid_train_numeric <- covid_train %>% 
    mutate(date = as.numeric(date))
  
  covid_test_numeric <- covid_test %>% 
    mutate(date = as.numeric(date))
  
  # the backward selection with same formula
  model <- regsubsets(
    search_trends_anxiety ~ new_persons_vaccinated + 
      new_hospitalized_patients +
      new_confirmed +
      new_intensive_care_patients + date,
    data = covid_train_numeric,
    nvmax = nvmax,
    method = "backward"
  )
  
  # get the results
  model_summary <- summary(model)
  
  list(
    train_data = covid_train_numeric,
    test_data = covid_test_numeric,
    selection_summary = as_tibble(model_summary$which),
    performance = tibble(
      n_input_variables = 1:nvmax,
      RSQ = model_summary$rsq,
      RSS = model_summary$rss,
      ADJ.R2 = model_summary$adjr2
    )
  )
}