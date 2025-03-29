# author: Vincy Huang
# date: 2025-03-11 

"This script downloads the US COVID-19 data from the internet and saves it locally.

Usage: 01_load_data.R --file_path=<file_path> --output_path=<output_path>

Options:
--file_path=<file_path>     Path to the input file (or a URL).
--output_path=<output_path> Path and filename where to designate the file and what to call it.
" -> doc

library(tidyverse)
library(janitor)
library(docopt)

opt <- docopt(doc)

# load data

data <- read_csv(opt$file_path)

# clean column names in loaded data
us_covid <- janitor::clean_names(data)

# save data with cleaned variable names
write_csv(us_covid, opt$output_path)