# author: Alina Hameed, Vincy Huang, Alan Lee, and Charlotte Ren
# date: 2025-03-11

"This script reads the data from the first script and performs 
data cleaning/pre-processing, transforming, and/or partitioning
that needs to happen before exploratory data analysis or modeling.

Usage: 02_cleaning.R --file_path=<file_path> --output_path=<output_path>
" -> doc

library(readr)
library(docopt)
library(assertthat)

opt <- docopt(doc)

# === 1. Check file exists ===
assert_that(file.exists(opt$file_path))

# === 2. Read raw data ===
data_path <- opt$file_path
us_covid <- read_csv(data_path)

# === 3. Check column names ===
expected_cols <- c("date", "search_trends_anxiety", "new_persons_vaccinated",
                   "new_hospitalized_patients", "new_confirmed", "new_intensive_care_patients")
actual_cols <- colnames(us_covid)
assert_that(all(expected_cols %in% actual_cols))

# === 4. No duplicate observations ===
assert_that(nrow(us_covid) == nrow(unique(us_covid)))

# === 5. Check for missing values ===
if (any(is.na(us_covid))) {
  warning("⚠️ Missing values detected in the dataset.")
}

# === 6. Correct data types ===
assert_that(inherits(us_covid$date, "Date"))
assert_that(is.numeric(us_covid$new_confirmed))
assert_that(is.numeric(us_covid$new_persons_vaccinated))

# === 7. Reasonable range checks ===
assert_that(all(us_covid$new_persons_vaccinated >= 0, na.rm = TRUE))
assert_that(all(us_covid$new_confirmed >= 0, na.rm = TRUE))


# === 8. Optional: Check response variable distribution ===
# e.g., use summary or quantile range for search_trends_anxiety
stopifnot(median(us_covid$search_trends_anxiety, na.rm = TRUE) < 100)

# === Clean using packaged function ===
us_selected <- covidanxietytrends::clean_covid_data(us_covid)

# === Write cleaned output ===
write_csv(us_selected, opt$output_path)

# If all checks passed:
message("✅ All data validation checks passed.")


