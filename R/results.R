#' Create results linear regression model with the selected features
#'
#' @param df A data frame with at least `date`, 
#'                                      `new_persons_vaccinated`, 
#'                                      `new_confirmed`, 
#'                                      `new_intensive_care_patients`, 
#'                                      `new_hospitalized_patients` 
#'                                      `search_trends_anxiety` columns
#'
#' @return returns the final regression model from our results
#' @export
make_final_lm_model <- function(df) {
    
    # Input validation
    required_cols <- c("date", "search_trends_anxiety", "new_persons_vaccinated",
                    "new_hospitalized_patients", "new_confirmed", "new_intensive_care_patients")
                    
    if (!all(required_cols %in% names(df))) {
        missing <- setdiff(required_cols, names(df))
        stop("Missing required columns: ", paste(missing, collapse = ", "))
        }
        
    final_model <- lm(search_trends_anxiety ~ new_persons_vaccinated + new_hospitalized_patients + date,
                  data = df)
                  
    return(final_model)
}
