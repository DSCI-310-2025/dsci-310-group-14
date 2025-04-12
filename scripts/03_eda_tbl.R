# author: Alina Hameed, Vincy Huang, Alan Lee, and Charlotte Ren
# date: 2025-03-11

"This script creates exploratory data table(s) to help readers understand the data set. 
The visualizations and tables will be saved as files. 

Usage: 03_eda_tbl.R --input_unprocessed=<input_unprocessed> --input_processed=<input_processed> --tbl_detailed_summary=<tbl_detailed_summary> 

" -> doc

library(tidyverse)
library(docopt)

opt <- docopt(doc)

# read unprocessed and processed data
unprocessed_data_path <- opt$input_unprocessed
processed_data_path   <- opt$input_processed

us_covid    <- read_csv(unprocessed_data_path)
us_selected <- read_csv(processed_data_path)

table_summary_final <- covidanxietytrends::summarize_covid_data(us_covid, us_selected)

write_csv(table_summary_final, opt$tbl_detailed_summary)
