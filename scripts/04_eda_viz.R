# author: Vincy Huang
# date: 2025-03-11

"This script creates exploratory data visualization(s) to help readers understand
the data set. The visualizations and tables will be saved as files. 

Usage: 04_eda_viz.R --input_unprocessed=<input_unprocessed> --input_processed=<input_processed> --output_fig1=<output_fig1> --output_fig2=<output_fig2>
" -> doc

library(tidyverse)
library(docopt)
library(GGally)

# Source the create_pairs_plot function from root directory
source("R/eda_viz_pairplot.R")
source("R/eda_viz.R")


# Parse command line options
opt <- docopt(doc)

# Read unprocessed and processed data
unprocessed_data_path <- opt$input_unprocessed
processed_data_path   <- opt$input_processed

us_covid    <- read_csv(unprocessed_data_path)
us_selected <- read_csv(processed_data_path)

# 📊 Figure 1: Pair plot of all variables (from processed data)
create_pairs_plot(us_selected, opt$output_fig1, width = 16, height = 12)

ggsave(opt$output_fig1, width = 15)


# Figure 2: Time series plot on anxiety search trend across all COVID-19 dates

options(repr.plot.width = 14, repr.plot.height = 9) 
# 
# anxiety_time_plot <- ggplot(us_covid, aes(y = search_trends_anxiety, x = date)) +
#                       geom_line(color = "cornflower blue")+
#                       labs(title = "Google Searches Regarding Anxiety over Time",
#                            x = "Date",
#                            y = "Normalized Search Volume") +
#                         theme(text = element_text(size = 13)) 



anxiety_time_plot <- plot_anxiety_time_series(us_covid, opt$output_fig2)

ggsave(opt$output_fig2, width = 10)

