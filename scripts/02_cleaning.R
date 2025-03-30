# author: Vincy Huang
# date: 2025-03-11

"This script reads the data from the first script and performs 
data cleaning/pre-processing, transforming, and/or partitioning
that needs to happen before exploratory data analysis or modeling.

Usage: 02_cleaning.R --file_path=<file_path> --output_path=<output_path>
" -> doc

library(tidyverse)
library(docopt)
source("R/clean_covid_data.R")

# 🔧 Source your function
source("R/clean_covid_data.R")

opt <- docopt(doc)

# read data
data_path <- opt$file_path
us_covid <- read_csv(data_path)


# ✅ Use the function
us_selected <- clean_covid_data(us_covid)

# write processed data
write_csv(us_selected, opt$output_path)




