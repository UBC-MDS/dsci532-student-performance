# Mathematics Student Performance Analysis App

**Author:** Hrayr Muradyan

## Motivation

**Target audience**: Educators, school administrators, and data analysts.

Understanding student performance is important for improving educational outcomes. The ability to analyze factors that influence student performance in mathematics can help educators and school administrators develop targeted strategies to support students. This app allows users (target audience) to explore a dataset of student performance, with the goal of finding patterns and directions for improving the school environment. The factors that are used for the analysis include gender, study time, school, failures and so on. The app provides visualizations and summary cards for the user to gain a deeper understanding of how various elements affect student performance and make informed decisions on how to optimize teaching methods and resources.

## App Description

Please watch the following video for detailed description of the app.

<video width="900" controls>
  <source src="video_explanation.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>

## Installation Instructions

To run the app locally, please follow the below instructions.

1. Clone the repository:

```{bash}
git clone https://github.com/yourusername/student-performance-app.git
```

2. Navigate to the cloned repo:

```{bash}
cd student-performance-app
```

2. Install the required packages:
```{r}
source("src/install_packages.R")
```

3. Run the app:

```{bash}
shiny::runApp("src/app.R")
```


## Challenging

For the challenging portion, I added more input/output components. In total, the dashboard has 10 components. 5 Inputs, 3 Summary Cards and 2 Plots.
