#' create the regression coefficent table and writes it to a csv in the resulte folder as well. 
#'
#' @param final_model A lm model 
#'
#' @return returns the lm coefficients and a csv with the data saved onto it
#' @export
make_lm_coef <- function(final_model) {
lm_coef <- tidy(final_model)
write_csv(lm_coef, "results/lm_coef.csv")
return (lm_coef)
}
