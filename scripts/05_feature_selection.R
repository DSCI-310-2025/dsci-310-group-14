# author: Alina Hameed, Vincy Huang, Alan Lee, and Charlotte Ren
# date: 2025-03-11
"This script reads data from the second script, performs feature selection 
for linear regression and summarizes the results as a figure(s) and a table(s).

Usage: 05_feature_selection.R --input_path=<input_path> --output_train=<output_train> --output_test=<output_test> --bwd_sel_summary=<bwd_sel_summary> --bwd_performance=<bwd_performance> --selected_features=<selected_features>
Options:
--input_path=<input_path>           A path/filename pointing to the data
--output_train=<output_train>       A path/filename to save training data
--output_test=<output_test>         A path/filename to save testing data
--bwd_sel_summary=<bwd_sel_summary> A path/filename to save summary result table
--bwd_performance=<bwd_performance> A path/filename to save performance result table
--selected_features=<selected_features> A path/filename to save selected features
" -> doc

library(covidanxietytrends)

set.seed(310)

library(readr)
library(dplyr)
library(docopt)
library(leaps)

opt <- docopt(doc)

#read and split data
processed_data_path <- opt$input_path
us_selected <- read_csv(processed_data_path)

#split data 
bwd_select_train <- sample_n(us_selected, size = nrow(us_selected) * 0.3,
                           replace = FALSE)
model_data <- anti_join(us_selected, bwd_select_train, by = "date")
covid_train <- sample_n(model_data, size = nrow(model_data) * 0.7,
                       replace = FALSE)
covid_test <- anti_join(model_data, covid_train, by = "date")

#save numeric date versions 
covid_train_numeric <- covid_train |> mutate(date = as.numeric(date))
write_csv(covid_train_numeric, opt$output_train)

covid_test_numeric <- covid_test |> mutate(date = as.numeric(date))
write_csv(covid_test_numeric, opt$output_test)

#use the new feature_selection function in r
result_list <- covidanxietytrends::feature_selection(covid_train_numeric)

#save outputs
write_csv(result_list$selection_summary, opt$bwd_sel_summary)
write_csv(result_list$performance, opt$bwd_performance)
write_lines(result_list$selected_features, opt$selected_features)

#print summary check
print(result_list$selected_features)
print(result_list$performance)