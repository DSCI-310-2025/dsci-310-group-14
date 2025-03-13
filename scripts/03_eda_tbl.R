# author: Vincy Huang
# date: 2025-03-11

"This script creates exploratory data table(s) to help readers understand the data set. The visualizations and tables will be saved as files. 

Usage: 03_eda_tbl.R --input_unprocessed=<input_unprocessed> --input_processed=<input_processed> --tbl_summary=<tbl_summary> --tbl_detailed_summary=<tbl_detailed_summary> 
" -> doc
library(tidyverse)
library(docopt)

opt <- docopt(doc)

# read unprocessed and processed data
unprocessed_data_path <- opt$input_unprocessed
processed_data_path   <- opt$input_processed

us_covid    <- read_csv(unprocessed_data_path)
us_selected <- read_csv(processed_data_path)

# Table 1: Summarise all numeric columns
covid_summary <- us_selected %>%
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

# Table 2: Summary table of all variables: 
##  (Add summery about date column and count missing values)
dates_day <- as.numeric(us_selected$date)

date_summary <- tibble(Variable = c("date"),
                      Min = min(dates_day),
                      Q25 = quantile(dates_day, 0.25),
                      Mean = mean(dates_day),
                      Median = median(dates_day),
                      Q75 = quantile(dates_day, 0.75),
                      Max = max(dates_day))|>
                mutate(across(where(is.numeric), as_date))

table_summary <- rbind(covid_summary,date_summary)

## (Count missing values from original dataset)
us_missing <- us_covid |>
  select(search_trends_anxiety, new_persons_vaccinated, new_hospitalized_patients,
         new_confirmed, new_intensive_care_patients,date)

us_missing_counts <- tibble(Variable = table_summary$Variable,
                            Observations = colSums(!is.na(us_missing)),
                            Missing = colSums(is.na(us_missing)))

## (Output: Combine all summary statistics, including date and missing data counts)
table_summary_final <- inner_join(table_summary, us_missing_counts, by = "Variable")
table_summary_final

write_csv(table_summary_final, opt$tbl_detailed_summary)
