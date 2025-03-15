FROM rocker/tidyverse:4.4.3

# Install remotes for version control of packages
RUN Rscript -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"

# Install tidyverse and its dependencies with pinned versions
RUN Rscript -e "remotes::install_version('tidyverse', version = '2.0.0', repos = 'https://cran.rstudio.com')"

# Install other packages with pinned versions
RUN Rscript -e "remotes::install_version('tidymodels', version = '1.3.0', repos = 'https://cran.rstudio.com')"
RUN Rscript -e "remotes::install_version('GGally', version = '2.2.1', repos = 'https://cran.rstudio.com')"
RUN Rscript -e "remotes::install_version('purrr', version = '1.0.2', repos = 'https://cran.rstudio.com')"
RUN Rscript -e "remotes::install_version('knitr', version = '1.45', repos = 'https://cran.rstudio.com')"
RUN Rscript -e "remotes::install_version('leaps', version = '3.1', repos = 'https://cran.rstudio.com')"
RUN Rscript -e "remotes::install_version('mltools', version = '0.1.0', repos = 'https://cran.rstudio.com')"