# author: Alina Hameed, Vincy Huang, Alan Lee, and Charlotte Ren
# date: 2025-03-11

"This script reads the data from the first script and performs 
data cleaning/pre-processing, transforming, and/or partitioning
that needs to happen before exploratory data analysis or modeling.

Usage: 02_cleaning.R --file_path=<file_path> --output_path=<output_path>
" -> doc

library(readr)
library(docopt)
library(covidanxietytrends)

opt <- docopt(doc)

# read data
data_path <- opt$file_path
us_covid <- read_csv(data_path)

# Use the covidanxietytrends package function 
us_selected <- clean_covid_data(us_covid)

# write processed data
write_csv(us_selected, opt$output_path)




