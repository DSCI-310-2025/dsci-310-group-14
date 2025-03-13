# author: Vincy Huang
# date: 2025-03-11

"This script creates exploratory data visualization(s) to help readers understand
the data set. The visualizations and tables will be saved as files. 

Usage: 04_eda_viz.R --input_unprocessed=<input_unprocessed> --input_processed=<input_processed> --output_fig1=<output_fig1> --output_fig2=<output_fig2>
" -> doc
library(tidyverse)
library(docopt)
library(GGally)

opt <- docopt(doc)

# read unprocessed and processed data
unprocessed_data_path <- opt$input_unprocessed
processed_data_path   <- opt$input_processed

us_covid    <- read_csv(unprocessed_data_path)
us_selected <- read_csv(processed_data_path)


# Figure 1: Pair plot of all variables
options(repr.plot.width = 16, repr.plot.height = 12) # change plot sizes to an appropiate size

ggpairs(us_selected, aes(alpha = 0.5)) +
    theme(text = element_text(size = 13)) +
    ggtitle("Pairs plot for all variables of interest for exploration") +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

ggsave(opt$output_fig1)

# Figure 2: Time series plot on anxiety search trend across all COVID-19 dates

options(repr.plot.width = 14, repr.plot.height = 9) 

anxiety_time_plot <- ggplot(us_covid, aes(y = search_trends_anxiety, x = date)) +
                      geom_line(color = "cornflower blue")+
                      labs(title = "Google Searches Regarding Anxiety over Time",
                           x = "Date",
                           y = "Normalized Search Volume") +
                        theme(text = element_text(size = 13)) 


anxiety_time_plot
ggsave(opt$output_fig2, width = 10)
