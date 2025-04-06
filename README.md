# Project: COVID-19 Anxiety Search Trend Analysis
- The list of contributors/authors: 
    - Alina Hameed
    - Vincy Huang
    - Alan Lee
    - Charlotte Ren

## Project Summary 
The COVID-19 pandemic led to significant public health measures, such as lockdowns and vaccinations, which have increased stress and anxiety worldwide. Studies have shown that isolation, uncertainty, and media coverage, including misinformation, have exacerbated mental health issues. This study aims to explore how factors like hospitalizations and new vaccination correlate with anxiety-related Google searches in the U.S. during the pandemic. The confluence of COVID-19 hospitalization rates, vaccine numbers, and public worry is a relevant area of study because it sheds light on the influence that public health metrics have on the overall mental health of populations. This project seeks to determine whether increasing numbers of newly hospitalized COVID-19 patients and falling vaccination rates align with rising search volumes related to anxiety. Using publicly available data from Google Open Data, we will utilize regression analysis to investigate potential correlations between these variables. 

Our workflow includes data preprocessing, exploratory data analysis, and regression modeling, all accomplished using R. Preliminary results in our exploratory data analysis show a moderate strength correlation between rising hospitalization, falling vaccination rates, and increased anxiety search volume trends, the connectivity of which shows the interconnectedness of physical and mental wellness throughout the pandemic. The analysis aims to provide actionable insights for policymakers and healthcare practitioners to effectively combat both the physical and psychological impacts of the pandemic.
    
The data used herein is from publicly available repositories, including COVID-19 hospitalization statistics, vaccination records, and Google Trends as collected by Google Open Data which can be found [here!](https://github.com/GoogleCloudPlatform/covid-19-open-data#aggregated-table)

## How to run our data analysis?
To reproduce our analysis in a containerized environment, please follow the following steps:
> Note: Our project environment presupposes the basic software setup and hardware requirements in [DSCI 310 Course Computer Setup](https://ubc-dsci.github.io/dsci-310-student/computer-setup.html). We strongly encourage readers to confirm their device setup through this guide.

### Basic setup:
1. **Install and launch** [Docker](https://www.docker.com/get-started/) on your computer according to your device system.
   > Why Docker?
   > 
   > Docker packs a specific R language version and package dependencies into a "container" that works the same on any computer operating systems, allowing our analysis and results to be rendered using the environement it was initially built in. This ensures that you as a reader can reproduce and audit our coding analysis results in a reliable and transparent way.
   
   Now you should have Docker launched and ready for the next steps: Pulling and running the container!

1. **Clone our Github repository**:

   - On your computer, open the **Terminal** application.
   - **Copy and paste** the following command into the Terminal, then hit the 'enter' button on your keyboard.This command clones a copy of our project repository onto your local machine:
   ```
   git clone https://github.com/DSCI-310-2025/dsci-310-group-14.git
   ```

1. **Move into the cloned project folder**:
   - Copy and paste the following command into a new line in the Terminal application, then press the 'enter' button on keyboard to move into the cloned `dsci-310-group-14` repository on your local machine.
    ```
    cd dsci-310-group-14
    ```
   
1. **Pull the Container**:
   - In the same **Terminal** application, copy and paste the following command to pull our analysis' Dockerhub image to your local device: 
    ```
    docker pull yvinc/dsci-310-group-14
    ```
    > Example output of the above `docker pull` command in Terminal (highlighted in grey):
    >
    > <img src="https://github.com/user-attachments/assets/40ae252b-ab2f-4e79-987e-a83a7265aa78" width="430"/>

1. **Run the Container**: Type the following command, then press 'enter' to run the container:
   On Apple Mac (ARM-based/Intel-based) :
   ```
   docker run --rm -it -p 8888:8787 -e PASSWORD="covid" -v "$(pwd)":/home/rstudio yvinc/dsci-310-group-14
   ```
    > Example output of the above `docker run` command in Terminal (highlighted in grey):
    >
    > <img src="https://github.com/user-attachments/assets/a2ad5fe6-bdbb-4970-afba-30b51588838f" width="420"/>

   On Windows:
   ```
   docker run --rm -it -p 8888:8787 -e PASSWORD="covid" -v "%CD%":/home/rstudio yvinc/dsci-310-group-14
   ```
### Then, we can run the analysis:

1. **After running the above commands**, open the browser (e.g., Google Chrome) and go onto [http://localhost:8888](http://localhost:8888) in the browser search bar and press enter.

   On `http://localhost:8888`, enter the following information:
   - `Username`: rstudio
   - `Password`: covid
    > <img src="https://github.com/user-attachments/assets/e4719f07-5ee9-4802-b8a4-d9908adb3221" width="260"/>
   Then left click `Sign in`.

1. After you have signed in, you will see an empty Rstudio navigation page like this:
    > <img src="https://github.com/user-attachments/assets/3c316fab-01dc-4951-ade4-a844dc888382" width="550"/>

1. You can now move your cursor to the right panel of the page near the bottom right. Click into the **`reports`** folder, then left-click the **`covid_anxiety_predictors_analysis.qmd`** Quarto report file to open the analysis.
1. With `covid_anxiety_predictors_analysis.qmd` opened, navigate your cursor to the **blue `Render` arrow** above the file panel.
1. Left click this `Render` blue arrow to run our analysis (wait time to produce the analysis is about 15 seconds).

   > **Important note**: You can expect a `html` rendering of our report to be produced in the popup window. If the popup window is blocked by your browser and you see a `Popup blocked` message, please click `Try Again` to open the `html` rendering of our report.

1. After the Quarto rendering, you should be able to see a new window popup with the name, "Group 14: Predict COVID-19 Anxiety Search Trend - Regression".

1. You are now able to reproduce and review our analysis report and results!

## Dependencies
- A list of the dependency packages needed to be **installed** to run the analysis:
- (If run in Docker image, note that the analysis runs on `rocker/tidyverse:4.4.3 image`)
    - `tidyverse`: Installed from the latest version available at the time of container build.
    - `GGally`: Version 2.2.1
    - `purrr`: Installed from the latest version available at the time of container build.
    - `knitr`: Installed from the latest version available at the time of container build.
    - `tidymodels`: Version 1.3.0
    - `leaps`: Version 3.1
    - `mltools`: Version 0.1.0




## Licenses

- The names of the licenses contained in `LICENSE.md`

  Project Code: Licensed under the MIT License.
  
  Report and Documentation: Licensed under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International.
