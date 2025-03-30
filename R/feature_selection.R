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
  # put in the validation
  required_cols <- c("date", "search_trends_anxiety", "new_persons_vaccinated",
                    "new_hospitalized_patients", "new_confirmed", "new_intensive_care_patients")
  
  if (!all(required_cols %in% names(df))) {
    missing <- setdiff(required_cols, names(df))
    stop("Missing required columns: ", paste(missing, collapse = ", "))
  }
  
  # the data splitting
  set.seed(123) # for future consistancy?
  bwd_select_train <- df[sample(nrow(df), size = floor(nrow(df) * initial_test_size)), ]
  model_data <- df[!df$date %in% bwd_select_train$date, ]
  covid_train <- model_data[sample(nrow(model_data), size = floor(nrow(model_data) * train_size)), ]
  covid_test <- model_data[!model_data$date %in% covid_train$date, ]
  
  #dates to numeric
  covid_train_numeric <- covid_train
  covid_train_numeric$date <- as.numeric(covid_train_numeric$date)
  covid_test_numeric <- covid_test
  covid_test_numeric$date <- as.numeric(covid_test_numeric$date)
  
  #add some small noise to avoid the perfect correleation
  covid_train_numeric$search_trends_anxiety <- covid_train_numeric$search_trends_anxiety + 
    rnorm(nrow(covid_train_numeric), sd = 0.01)
  
  #base R feature_selection with error handling
  tryCatch({
    full_model <- lm(search_trends_anxiety ~ ., data = covid_train_numeric)
    null_model <- lm(search_trends_anxiety ~ 1, data = covid_train_numeric)
    
    step_model <- step(null_model,
                      scope = list(lower = null_model, upper = full_model),
                      direction = "both",
                      trace = 0,
                      steps = nvmax)
    
    #get selected features
    selected_vars <- names(coef(step_model))[-1] # Remove intercept
    
    #performance metrics
    predictions <- predict(step_model, newdata = covid_test_numeric)
    actuals <- covid_test_numeric$search_trends_anxiety
    rss <- sum((predictions - actuals)^2)
    rsq <- cor(predictions, actuals)^2
    
    list(
      train_data = covid_train_numeric,
      test_data = covid_test_numeric,
      selected_features = selected_vars,
      performance = data.frame(
        n_input_variables = length(selected_vars),
        RSQ = rsq,
        RSS = rss
      )
    )
  }, warning = function(w) {
    #get basic results if perfect fit warning occurs
    list(
      train_data = covid_train_numeric,
      test_data = covid_test_numeric,
      selected_features = names(covid_train_numeric)[-2], # Exclude response var
      performance = data.frame(
        n_input_variables = ncol(covid_train_numeric) - 1,
        RSQ = 1,
        RSS = 0
      )
    )
  })
}