# author: Vincy Huang
# date: 2025-03-11

"This script reads the data from the first script and performs 
and data cleaning/pre-processing, transforming, and/or partitioning
that needs to happen before exploratory data analysis or modeling.

Usage: 02_cleaning.R --file_path=<file_path> --output_path=<output_path>

Options: 
--file_path=<file_path>     Path and filename pointing to the data to be read in.
--output_path=<output_path> Path and filename pointing to where the processed/partitioned data should live.
" -> doc

library(tidyverse)
library(docopt)
source("R/clean_covid_data.R")


opt <- docopt(doc)

# read data
data_path <- opt$file_path

us_covid <- read_csv(data_path)

# select only variables of interest for further analysis using clean_covid_data()
us_selected <- clean_covid_data(us_covid)

write_csv(us_selected, opt$output_path)



