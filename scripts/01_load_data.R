# author: Alina Hameed, Vincy Huang, Alan Lee, and Charlotte Ren
# date: 2025-03-11 

"This script downloads the US COVID-19 data from the internet and saves it locally.

Usage: 01_load_data.R --file_path=<file_path> --output_path=<output_path>

Options:
--file_path=<file_path>     Path to the input file (or a URL).
--output_path=<output_path> Path and filename where to designate the file and what to call it.
" -> doc

library(readr)
library(janitor)
library(docopt)
library(covidanxietytrends)

opt <- docopt(doc)

# load data
data <- load_data(opt$file_path)

# clean column names in loaded data
us_covid <- janitor::clean_names(data)

# save data with cleaned variable names
write_csv(us_covid, opt$output_path)