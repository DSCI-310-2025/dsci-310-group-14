# author: Charlotte Ren
# date: 2025-04-12

"This script performs data validation checks on the cleaned COVID-19 dataset
using the pointblank package. A validation report is saved for review.

Usage: 07_data_validation.R --input_path=<input_path> --output_report=<output_report>
" -> doc

library(docopt)
library(readr)
library(pointblank)

opt <- docopt(doc)

# === Load cleaned data ===
df <- read_csv(opt$input_path)

# === Create validation agent with checks ===
agent <- create_agent(read_fn = ~ df) %>%
  col_exists(vars(
    date, search_trends_anxiety, new_persons_vaccinated,
    new_hospitalized_patients, new_confirmed, new_intensive_care_patients)) %>%
  col_is_date(vars(date)) %>%
  col_is_numeric(vars(
    search_trends_anxiety, new_persons_vaccinated,
    new_hospitalized_patients, new_confirmed, new_intensive_care_patients)) %>%
  col_vals_not_null(everything()) %>%
  col_vals_gte(vars(new_confirmed, new_persons_vaccinated), value = 0) %>%
  col_schema_match(schema = col_schema(
    date = "Date",
    search_trends_anxiety = "numeric",
    new_persons_vaccinated = "numeric",
    new_hospitalized_patients = "numeric",
    new_confirmed = "numeric",
    new_intensive_care_patients = "numeric"
  )) %>%
  interrogate()

# === Export validation report ===
export_report(agent, filename = opt$output_report)

message("✅ Data validation completed and report saved to: ", opt$output_report)

