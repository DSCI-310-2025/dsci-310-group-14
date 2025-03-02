FROM rocker/tidyverse:4.4.3

RUN Rscript -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN Rscript -e "remotes::install_version('tidymodels', version = '1.3.0', repos = 'https://cran.rstudio.com')"
RUN Rscript -e "remotes::install_version('GGally', version = '2.2.1', repos = 'https://cran.rstudio.com')"

