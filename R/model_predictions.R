#' predicts the model's R^2 and RMSE and then saves it to a table
#'
#' @param final_model A lm model 
#' @param test_df The test split of the data we will be verifying against. This should have date as a numeric value
#'
#' @return returns a table with the R^2 and RMSE values
#' @export
model_predictions <- function(final_model, test_df) {
    # Input validation 
    required_cols <- c("date", "search_trends_anxiety", "new_persons_vaccinated",
                     "new_hospitalized_patients", "new_confirmed", "new_intensive_care_patients")
    
    if (!all(required_cols %in% names(test_df))) {
        missing <- setdiff(required_cols, names(test_df))
        stop("Missing required columns: ", paste(missing, collapse = ", "))
        }
  
       
    if (!all(is.numeric(test_df$date))) {
        stop("Date is not numeric")
        }
        
    # apply the model to predict test data:
    final_model_predictions <- predict(final_model, newdata = test_df)
    
    # find the RMSE between the model's prediction and the actual values
    final_model_RMSPE = rmse(preds = final_model_predictions,
                        actuals = test_df$search_trends_anxiety)
                        
    # create dataframe with RMSPE and R-squared, store it as csv and return it
    metrics_results <- tibble(RMSPE = final_model_RMSPE, R_square = summary(final_model)$r.squared)
    write_csv(metrics_results, "results/models/metrics_results.csv")

    metrics_results
}