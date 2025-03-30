#' create the regression coefficent table and writes it to a csv in the resulte folder as well. 
#'
#' @param lm_model A lm model 
#' @param output_file  Path to save the output
#' @return returns the lm coefficients and a csv with the data saved onto it
#' @export
results_lm_coef <- function(lm_model, output_file) {
    
    if (!all(class(lm_model) == 'lm')) {
    stop("Please provide a lm model")
    }

    lm_coef <- tidy(lm_model)

    write_csv(lm_coef, output_file)

}
