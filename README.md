- The project title: COVID-19 Anxiety Trend Analysis
- The list of contributors/authors: 
    - Alina Hameed
    - Vincy Huang
    - Alan Lee
    - Charlotte Ren
- A short summary of the project (view from 10,000 feet)
This project investigates whether an increase in newly hospitalized COVID-19 patients and a lower vaccination count lead to higher anxiety search trends. The analysis uses publicly available data and applies regression to explore potential correlations.

- How to run your data analysis
To reproduce the analysis in a containerized environment:
1. Clone the repository:
git clone https://github.com/UBC-DSCI/dsci-310-group-14.git
cd dsci-310-group-14
2. Set up the environment using Docker:
docker build -t covid_analysis .
docker run -p 8888:8888 covid_analysis
3. Access Jupyter Notebook:
Open a browser and go to http://localhost:8888
Open notebooks/analysis.ipynb and execute the analysis.

- A list of the dependencies needed to run your analysis
  - R (4.0+)
  - tidyverse
  - tidymodels
  - ggplot2
  - GGally
  - rmarkdown
  - docker

- The names of the licenses contained in LICENSE.md
  Project Code: Licensed under the MIT License.
  Report and Documentation: Licensed under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International.
