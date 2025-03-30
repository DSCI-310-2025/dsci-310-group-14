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

source(here::here("R", "feature_selection.R"))

# split data into training and testing sets:
processed_data_path   <- opt$input_path
us_selected <- read_csv(processed_data_path)

# run feature selection on the selected data
result_list <- feature_selection(us_selected)

# create train data as a seperate csv for use in model
write_csv(result_list$train_data, opt$output_train)

# create test data as a seperate csv for use in testing model
write_csv(result_list$test_data, opt$output_test)

# create table to show backward selection results
write_csv(result_list$selection_summary, opt$bwd_sel_summary)

# create table to show model performance
write_csv(result_list$performance, opt$bwd_performance)
