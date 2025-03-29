#' Create results linear regression model with the selected features
#'
#' @param df A data frame with at least `date`, `new_persons_vaccinated`, `new_hospitalized_patients` and `search_trends_anxiety` columns
#'
#' @return returns the final regression model from our results
#' @export
make_the_results_final_model_multiple_linear_regression_of_selected_features <- function(df) {
final_model <- lm(search_trends_anxiety ~ new_persons_vaccinated + new_hospitalized_patients + date,
                  data = df)

return (final_model)
}
