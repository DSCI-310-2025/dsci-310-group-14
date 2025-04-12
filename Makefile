
.PHONY: install_covidanxietytrends all reports all_tables_figures clean

# render analysis report
all: all_tables_figures index.html reports/covid_anxiety_predictors_analysis.html

# install covidanxietytrends package to run analysis
install_covidanxietytrends:
		Rscript scripts/install_covidanxietytrends.R


# load data
data/raw/US_cleaned_name.csv: scripts/01_load_data.R data/raw/US.csv
		Rscript scripts/01_load_data.R \
			--file_path=data/raw/US.csv \
			--output_path=data/raw/US_cleaned_name.csv

data/processed/US_partitioned.csv: scripts/02_cleaning.R data/raw/US_cleaned_name.csv
		Rscript scripts/02_cleaning.R \
			--file_path=data/raw/US_cleaned_name.csv \
			--output_path=data/processed/US_partitioned.csv

# results: plots and tables
results/tables/detailed_summary.csv: scripts/03_eda_tbl.R data/raw/US_cleaned_name.csv data/processed/US_partitioned.csv
		Rscript scripts/03_eda_tbl.R	\
			--input_unprocessed=data/raw/US_cleaned_name.csv	\
			--input_processed=data/processed/US_partitioned.csv	\
			--tbl_detailed_summary=results/tables/detailed_summary.csv

results/figures/pairplot.png results/figures/anxiety_search_time_series.png: scripts/04_eda_viz.R data/raw/US_cleaned_name.csv data/processed/US_partitioned.csv
		Rscript scripts/04_eda_viz.R \
			--input_unprocessed=data/raw/US_cleaned_name.csv \
			--input_processed=data/processed/US_partitioned.csv \
			--output_fig1=results/figures/pairplot.png \
			--output_fig2=results/figures/anxiety_search_time_series.png
			
data/processed/train.csv data/processed/test.csv results/models/bwd_sel_summary.csv results/models/bwd_performance.csv: data/processed/US_partitioned.csv
		Rscript scripts/05_feature_selection.R \
			--input_path=data/processed/US_partitioned.csv \
			--output_train=data/processed/train.csv \
			--output_test=data/processed/test.csv \
			--bwd_sel_summary=results/models/bwd_sel_summary.csv \
			--bwd_performance=results/models/bwd_performance.csv

results/models/lm_coef.csv results/models/lm_metrics_results.csv: scripts/06_model_results.R data/processed/train.csv data/processed/test.csv
		Rscript scripts/06_model_results.R \
			--input_train=data/processed/train.csv \
			--input_test=data/processed/test.csv \
			--coefficients=results/models/lm_coef.csv \
			--metrics_results=results/models/lm_metrics_results.csv

# produce all tables and figures
all_tables_figures: \
	data/raw/US_cleaned_name.csv \
	data/processed/US_partitioned.csv \
	results/tables/detailed_summary.csv \
	results/figures/pairplot.png results/figures/anxiety_search_time_series.png \
	data/processed/train.csv data/processed/test.csv \
	results/models/bwd_sel_summary.csv results/models/bwd_performance.csv \
	results/models/lm_coef.csv

# write the report
index.html: reports/covid_anxiety_predictors_analysis.qmd
	quarto render reports/covid_anxiety_predictors_analysis.qmd
	mv reports/covid_anxiety_predictors_analysis.html docs/index.html

reports/covid_anxiety_predictors_analysis.html: reports/covid_anxiety_predictors_analysis.qmd
	quarto render reports/covid_anxiety_predictors_analysis.qmd --to html
	
reports:
	make index.html
	make reports/covid_anxiety_predictors_analysis.html

# clean files so we can re-make them all
clean:
	rm -rf results/tables/* results/figures/* results/models/*
	rm -f data/raw/US_cleaned_name.csv
	rm -f data/processed/*
	rm -f index.html
	rm -f reports/*.pdf
	rm -f reports/*.html
