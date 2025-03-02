# Project: COVID-19 Anxiety Trend Analysis
- The list of contributors/authors: 
    - Alina Hameed
    - Vincy Huang
    - Alan Lee
    - Charlotte Ren

## Project Summary 
The confluence of COVID-19 hospitalization rates, vaccine numbers, and public worry is a relevant area of study because it sheds light on the influence that public health metrics have on the overall mental health of populations. This project seeks to determine whether increasing numbers of newly hospitalized COVID-19 patients and falling vaccination rates align with rising search volumes related to anxiety. Using publicly available data from google open data,by utilizing regression analysis to investigate for potential correlations between these variables. 

Our workflow includes data preprocessing, exploratory data analysis, and regression modeling, all accomplished using R. Preliminary results in our exploratory data anaylsis shows a moderate strength correlation between rising hospitalization, falling vaccination rates, and increased anxiety search volume trends, the connectivity of which shows the interconnectedness of physical and mental wellness throughout the pandemic. The analysis aims to provide actionable insights for policymakers and healthcare practitioners to effectively combat both the physical and psychological impacts of the pandemic.
    
The data used herein is from publicly available repositories, including COVID-19 hospitalization statistics, vaccination records, and Google Trends as collect by Google Open Data which can be found [here!](https://github.com/GoogleCloudPlatform/covid-19-open-data#aggregated-table)

## How to run our data analysis?
To reproduce the analysis in a containerized environment, please follow the following steps:
1. Clone and move into the current Github repository with the **following commands** in bash into your local working directory:
```
git clone https://github.com/UBC-DSCI/dsci-310-group-14.git
```
```
cd dsci-310-group-14
```
2. Set up the environment using Docker image (based on Docker image `tidyverse` 4.4.3) by running the **following commands** in bash on your local computer:

(Please first make sure the `Docker` application is opened and running in the background)

```
docker build -t covid_analysis .
```
```
docker run --rm -it -p 8888:8787 -v /$(pwd):/home/rstudio covid_analysis
```
3. Access analysis:
    Open a browser and go to http://localhost:8888.

    Enter 'rstudio' as the username and the password from the output of previous `docker run` command to open our Rstudio container.

    From the `Files` panel of the Rstudio, open `covid_analysis.qmd` from the root folder. You can run our analysis by running `covid_analysis.qmd`.

## Dependencies
- A list of the dependencies needed to run the analysis, given the `rocker/tidyverse:4.4.3 image`:
  - remotes
  - tidymodels (version 1.3.0)
  - GGally (version 2.2.1)
  - tidyverse (pre-installed in rocker/tidyverse image)

## Licenses

- The names of the licenses contained in `LICENSE.md`

  Project Code: Licensed under the MIT License.
  
  Report and Documentation: Licensed under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International.
