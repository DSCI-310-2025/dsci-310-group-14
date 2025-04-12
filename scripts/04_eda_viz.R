# author: Alina Hameed, Vincy Huang, Alan Lee, and Charlotte Ren
# date: 2025-03-11

"This script creates exploratory data visualization(s) to help readers understand
the data set. The visualizations and tables will be saved as files. 

Usage: 04_eda_viz.R --input_unprocessed=<input_unprocessed> --input_processed=<input_processed> --output_fig1=<output_fig1> --output_fig2=<output_fig2>
" -> doc

library(readr)
library(docopt)

# Parse command line options
opt <- docopt(doc)

# Read unprocessed and processed data
unprocessed_data_path <- opt$input_unprocessed
processed_data_path   <- opt$input_processed

us_covid    <- read_csv(unprocessed_data_path)
us_selected <- read_csv(processed_data_path)

# Figure 1: Pair plot of all variables (from processed data)
covidanxietytrends::create_pairs_plot(us_selected, opt$output_fig1, width = 16, height = 12)

ggplot2::ggsave(opt$output_fig1, width = 15)


# Figure 2: Time series plot on anxiety search trend across all COVID-19 dates
options(repr.plot.width = 14, repr.plot.height = 9) 

anxiety_time_plot <- covidanxietytrends::plot_anxiety_time_series(us_covid, opt$output_fig2)

ggplot2::ggsave(opt$output_fig2, width = 10)

