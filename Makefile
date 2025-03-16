# author: Vincy, Alina, Charlotte, Alan
# date: 2025-3-4

all: reports/covid_analysis.html \
	reports/covid_analysis.pdf

# makie the clean the data clean names
data/raw/US_cleaned_name.csv: scripts/01-load_clean.R data/raw/US.csv
	Rscript scripts/01_load_data.R --file_path="data/raw/US.csv" --output_path="data/raw/US_cleaned_name.csv"

# make the cleaned US_partitioned.csv
data/processed/US_partitioned.csv: scripts/02_cleaning.R data/raw/US_cleaned_name.csv
	Rscript scripts/02_cleaning.R --file_path="data/raw/US_cleaned_name.csv" --output_path="data/processed/US_partitioned.csv"

# generate tables for report
results/tables/summary.csv results/tables/detailed_summary.csv: scripts/03_eda_tbl.R data/raw/US.csv data/processed/US_partitioned.csv
	Rscript scripts/03_eda_tbl.R --input_unprocessed="data/raw/US.csv" --input_processed="data/processed/US_partitioned.csv" \
		--tbl_summary="results/tables/summary.csv" --tbl_detailed_summary="results/tables/detailed_summary.csv"

# generate figures and objects for report
results/figures/pairplot.png results/figures/anxiety_search_time_series.png: scripts/04_eda_viz.R data/raw/US.csv data/processed/US_partitioned.csv
	Rscript scripts/04_eda_viz.R --input_unprocessed="data/raw/US.csv" --input_processed="data/processed/US_partitioned.csv" \
		--output_fig1="results/figures/pairplot.png" --output_fig2="results/figures/anxiety_search_time_series.png"

# make do the feature selection
data/processed/train.csv data/processed/test.csv results/models/bwd_sel_summary.csv results/models/bwd_performance.csv: scripts/05_feature_selection.R \
data/processed/US_partitioned.csv \
	Rscript scripts/05_feature_selection.R --input_path="data/processed/US_partitioned.csv" --outout_train="data/processed/train.csv" --output_test="data/processed/test.csv" \
 		--bwd_sel_summary="results/models/bwd_sel_summary.csv" --bwd_performance="results/models/bwd_performance.csv">

# make do the model results
results/models/lm_coef.csv results/models/lm_metrics_results.csv: scripts/06_model_results.R \
data/processed/train.csv data/processed/test.csv\
	Rscript scripts/06_model_results.R --input_train="data/processed/train.csv" --input_test="data/processed/test.csv" \
	--coefficients="results/models/lm_coef.csv" --metrics_results="results/models/lm_metrics_results.csv"	
	
# render quarto report in HTML and PDF
reports/covid_analysis.html: results reports/covid_analysis.qmd
	quarto render reports/covid_analysis.qmd --to html

reports/covid_analysis.pdf: results reports/covid_analysis.qmd
	quarto render reports/covid_analysis.qmd --to pdf

# clean
 # we do not have clean we make report