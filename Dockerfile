FROM rocker/verse:4.4.3


RUN Rscript -e "install.packages('remotes', repos = 'https://cloud.r-project.org')"

RUN Rscript -e "install.packages('renv', repos = 'https://cloud.r-project.org')"


COPY . /home/rstudio/project


WORKDIR /home/rstudio/project


RUN chown -R rstudio:rstudio /home/rstudio/project


EXPOSE 8787


RUN Rscript -e "if (file.exists('renv.lock')) renv::restore(prompt = FALSE) else print('No renv.lock found, skipping restore.')"


RUN Rscript -e "remotes::install_version('tidymodels', version = '1.3.0', repos = 'https://cran.rstudio.com')"
RUN Rscript -e "remotes::install_version('GGally', version = '2.2.1', repos = 'https://cran.rstudio.com')"
RUN Rscript -e "remotes::install_version('purrr', version = '1.0.2', repos = 'https://cran.rstudio.com')"
RUN Rscript -e "remotes::install_version('knitr', version = '1.45', repos = 'https://cran.rstudio.com')"
