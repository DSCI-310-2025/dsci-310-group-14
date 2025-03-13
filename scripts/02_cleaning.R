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


opt <- docopt(doc)

# read data
data_path <- opt$file_path

us_covid <- read_csv(data_path)
# select only variables of interest for further analysis
us_selected <- us_covid |>
               select(date, search_trends_anxiety, new_persons_vaccinated, 
                       new_hospitalized_patients, new_confirmed, new_intensive_care_patients) |>
                drop_na()

write_csv(us_selected, opt$output_path)



