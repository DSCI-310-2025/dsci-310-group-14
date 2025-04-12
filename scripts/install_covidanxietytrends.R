# checks for and installs the convidanxietytrends package. This is used instead 
# of renv as all other dependancies are included in this package.

if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}

if (!requireNamespace("covidanxietytrends", quietly = TRUE)) {
  message("Installing covidanxietytrends package")
  devtools::install_github("DSCI-310-2025/covidanxietytrends")
}
