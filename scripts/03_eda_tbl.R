# author: Vincy Huang
# date: 2025-03-11

"This script creates exploratory data table(s) to help readers understand the data set. 
The visualizations and tables will be saved as files. 

Usage: 03_eda_tbl.R --input_unprocessed=<input_unprocessed> --input_processed=<input_processed> --tbl_summary=<tbl_summary> --tbl_detailed_summary=<tbl_detailed_summary>
" -> doc

library(tidyverse)
library(docopt)

# 🔧 Source the summary function
source("R/eda_tbl.R")

opt <- docopt(doc)

# Read datasets
raw_df <- read_csv(opt$input_unprocessed)
processed_df <- read_csv(opt$input_processed)

# Create summary of numeric variables only
covid_summary <- processed_df %>%
  summarise(across(where(is.numeric), list(
    Min = min,
    Q25 = ~quantile(.x, 0.25),
    Mean = mean,
    Median = median,
    Q75 = ~quantile(.x, 0.75),
    Max = max
  ), .names = "{.col}_{.fn}")) %>%
  pivot_longer(cols = everything(), names_to = c("Variable", "Statistic"), names_sep = "_(?=[^_]+$)") %>%
  pivot_wider(names_from = Statistic, values_from = value)

write_csv(covid_summary, opt$tbl_summary)

# ✅ Use the abstracted function for detailed summary
table_summary_final <- summarize_covid_data(raw_df, processed_df)
write_csv(table_summary_final, opt$tbl_detailed_summary)
