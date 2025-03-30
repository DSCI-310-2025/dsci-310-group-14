# author: Vincy Huang
# date: 2025-03-11

"This script creates exploratory data visualization(s) to help readers understand
the data set. The visualizations and tables will be saved as files. 

Usage: 04_eda_viz.R --input_unprocessed=<input_unprocessed> --input_processed=<input_processed> --output_fig1=<output_fig1> --output_fig2=<output_fig2>
" -> doc

library(tidyverse)
library(docopt)
library(GGally)

# 🔧 Source required plotting functions
source("R/eda_viz_pairplot.R")         # for create_pairs_plot()
source("R/eda_viz.R")                  # for plot_anxiety_time_series()

# Parse command line options
opt <- docopt(doc)

# Read unprocessed and processed data
unprocessed_data_path <- opt$input_unprocessed
processed_data_path   <- opt$input_processed

us_covid    <- read_csv(unprocessed_data_path)
us_selected <- read_csv(processed_data_path)

# 📊 Figure 1: Pair plot of all variables (from processed data)
create_pairs_plot(us_selected, opt$output_fig1, width = 16, height = 12)

# 📈 Figure 2: Time series plot on anxiety search trend (from raw data)
anxiety_time_plot <- plot_anxiety_time_series(us_covid)
ggsave(opt$output_fig2, plot = anxiety_time_plot, width = 10)
