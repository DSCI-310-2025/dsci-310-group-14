# author: Vincy Huang
# date: 2025-03-11
"This script reads data from the second script, performs feature selection 
for linear regression and summarizes the results as a figure(s) and a table(s).

Usage: 05_feature_selection.R --input_path=<input_path> --output_train=<output_train> --output_test=<output_test> --bwd_sel_summary=<bwd_sel_summary> --bwd_performance=<bwd_performance>
Options:
--input_path=<input_path>           A path/filename pointing to the data
--output_train=<output_train>       A path/filename to save training data
--output_test=<output_test>         A path/filename to save testing data
--bwd_sel_summary=<bwd_sel_summary> A path/filename to save summary result table
--bwd_performance=<bwd_performance> A path/filename to save performance result table
" -> doc
set.seed(310)

library(tidyverse)
library(tidymodels)
library(docopt)
library(knitr)
library(purrr)
library(leaps)
library(mltools)

opt <- docopt(doc)

# split data into training and testing sets:
processed_data_path   <- opt$input_path
us_selected <- read_csv(processed_data_path)

bwd_select_train <- sample_n(us_selected, size = nrow(us_selected) * 0.3,
                        replace = FALSE)
model_data <- anti_join(us_selected, 
                        bwd_select_train,
                        by = "date")
covid_train <- sample_n(model_data, size = nrow(model_data) * 0.7,
                        replace = FALSE)
covid_test <- anti_join(model_data, 
                        covid_train,
                        by = "date")


# converts dates into number of days for feature selection:
covid_train_numeric <- covid_train |> 
                       mutate(date = as.numeric(date))
write_csv(covid_train_numeric, opt$outout_train)

covid_test_numeric <- covid_test|> 
                      mutate(date = as.numeric(date))
write_csv(covid_test_numeric, opt$output_test)

# backward selection:
covid_backward_sel <- regsubsets(x = search_trends_anxiety ~ new_persons_vaccinated + 
                                                             new_hospitalized_patients +
                                                             new_confirmed +
                                                             new_intensive_care_patients + date,
                                  nvmax = 5,
                                  data = covid_train_numeric,
                                  method = "backward",)
covid_bwd_summary <- summary(covid_backward_sel)
covid_bwd_summary_df <- as.tibble((covid_bwd_summary[["which"]]))

write_csv(covid_bwd_summary_df, opt$bwd_sel_summary)

# summary of each model' performance
covid_bwd_performance <- tibble(n_input_variables = 1:5,
                          RSQ = covid_bwd_summary$rsq,
                          RSS = covid_bwd_summary$rss,
                          ADJ.R2 = covid_bwd_summary$adjr2)

covid_bwd_performance
write_csv(covid_bwd_performance, opt$bwd_performance)