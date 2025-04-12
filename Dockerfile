FROM rocker/verse:4.4.3

# Install remotes and renv
RUN Rscript -e "install.packages('remotes', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "install.packages('renv', repos = 'https://cloud.r-project.org')"

# Copy project files
COPY . /home/rstudio/project
WORKDIR /home/rstudio/project
RUN chown -R rstudio:rstudio /home/rstudio/project

# Expose RStudio port
EXPOSE 8787

# Restore environment with renv (if lockfile exists)
RUN Rscript -e "if (file.exists('renv.lock')) renv::restore(prompt = FALSE) else print('No renv.lock found, skipping restore.')"

# Install specific package versions
RUN Rscript -e "remotes::install_version('tidymodels', version = '1.3.0', repos = 'https://cran.rstudio.com'); \
    remotes::install_version('GGally', version = '2.2.1', repos = 'https://cran.rstudio.com'); \
    remotes::install_version('purrr', version = '1.0.2', repos = 'https://cran.rstudio.com'); \
    remotes::install_version('knitr', version = '1.45', repos = 'https://cran.rstudio.com'); \
    remotes::install_version('leaps', version = '3.1', repos = 'https://cran.rstudio.com'); \
    remotes::install_version('mltools', version = '0.1.0', repos = 'https://cran.rstudio.com'); \
    remotes::install_version('here', version = '1.0.1', repos = 'https://cran.rstudio.com'); \
    remotes::install_version('Metrics', version = '0.1.4', repos = 'https://cran.rstudio.com'); \
    remotes::install_version('assertthat', version = '0.2.1', repos = 'https://cran.rstudio.com'); \
    remotes::install_github('DSCI-310-2025/covidanxietytrends')"


