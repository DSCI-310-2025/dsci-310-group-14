FROM --platform=linux/amd64 rocker/tidyverse:4.4.3
# Install remotes for version control of packages
RUN Rscript -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"

RUN Rscript -e "remotes::install_version('tidymodels', version = '1.3.0', repos = 'https://cran.rstudio.com')"
RUN Rscript -e "remotes::install_version('GGally', version = '2.2.1', repos = 'https://cran.rstudio.com')"

RUN Rscript -e "install.packages('purrr', version = '1.0.2', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "install.packages('knitr', version = '1.45', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('leaps', version = '3.1', repos = 'https://cran.rstudio.com')"
RUN Rscript -e "remotes::install_version('mltools', version = '0.1.0', repos = 'https://cran.rstudio.com')"