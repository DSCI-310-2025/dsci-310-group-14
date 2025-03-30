#' create the regression coefficent table and writes it to a csv in the resulte folder as well. 
#'
#' @param lm_model A lm model 
#'
#' @return returns the lm coefficients and a csv with the data saved onto it
#' @export
results_lm_coef <- function(lm_model) {
    
    if (!all(class(lm_model) == 'lm')) {
    stop("Please provide a lm model")
    }

    lm_coef <- tidy(lm_model)
    
    lm_coef
}
