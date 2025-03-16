library(shiny)
library(ggplot2)
library(dplyr)

df <- read.csv("data/processed/processed_student_mat.csv")

ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      body {
        background-color: #eef2f7;
        font-family: 'Roboto', sans-serif;
        color: #333333;
      }
      .container-fluid {
        background-color: #ffffff;
        padding: 40px;
        border-radius: 12px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
      }
      .card {
        background-color: #435069;
        color: white;
        margin-bottom: 30px;
        border-radius: 12px;
        padding: 25px;
        font-size: 20px;
        transition: transform 0.3s, box-shadow 0.3s;
      }
      .card:hover {
        transform: scale(1.05);
        box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
      }
      .card-title {
        font-size: 24px;
        font-weight: bold;
        margin-bottom: 10px;
      }
      .card-content {
        font-size: 18px;
        margin-top: 10px;
      }
      .sidebar {
        background-color: #f7f9fc;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
      }
      .main-panel {
        padding-left: 20px;
      }
      .btn-reset {
        background-color: #FF6F61;
        color: white;
        border-radius: 6px;
        padding: 10px;
        border: none;
        font-size: 16px;
        cursor: pointer;
      }
      .btn-reset:hover {
        background-color: #E64A45;
      }
    "))
  ),
  
  titlePanel("Student Performance - Math"),
  
  sidebarLayout(
    sidebarPanel(
      class = "sidebar",
      selectInput("gender", "Select Gender:", 
                  choices = c("All", unique(df$sex)), selected = "All"),
      
      selectInput("study_time", "Select Minimum Study Time (hours):", 
                  choices = c("All", unique(df$studytime)), selected = "All"),
      
      sliderInput("absences", "Select the absences range:", 
                  min = min(df$absences), max = max(df$absences), 
                  value = c(min(df$absences), max(df$absences))),
      
      checkboxGroupInput("failures", "Number of Past Failures:", 
                         choices = c("0", "1", "2", "3"), selected = c("0", "1", "2", "3")),
      
      selectInput("school", "Select School:", 
                  choices = c("All", unique(df$school)), selected = "All"),
      
      actionButton("reset", "Reset Filters", class = "btn-reset")
    ),
    
    mainPanel(
      class = "main-panel",
      fluidRow(
        column(4,
               div(class = "card",
                   div(class = "card-title", "Average Grade"),
                   div(class = "card-content", textOutput("avg_grade"))
               )
        ),
        column(4,
               div(class = "card",
                   div(class = "card-title", "Number of Students"),
                   div(class = "card-content", textOutput("num_students"))
               )
        ),
        column(4,
               div(class = "card",
                   div(class = "card-title", "Average Failures"),
                   div(class = "card-content", textOutput("failures_per_student"))
               )
        )
      ),
      tabsetPanel(
        tabPanel("Grade Distribution", plotOutput("histPlot")),
        tabPanel("Previous Grades vs. Final Grade", plotOutput("scatterPlot"))
      )
    )
  )
)

server <- function(input, output, session) {
  filtered_data <- reactive({
    data <- df
    if (input$gender != "All") {
      data <- data |> filter(sex == input$gender)
    }
    if (input$school != "All") {
      data <- data |> filter(school == input$school)
    }
    if (input$study_time != "All") {
      data <- data |> filter(studytime == input$study_time)
    }
    data <- data |> filter(absences >= input$absences[1] & absences <= input$absences[2],
                           failures %in% as.numeric(input$failures))
    return(data)
  })
  
  observeEvent(input$reset, {
    updateSelectInput(session, "gender", selected = "All")
    updateSelectInput(session, "study_time", selected = "All")
    updateSliderInput(session, "absences", value = c(min(df$absences), max(df$absences)))
    updateCheckboxGroupInput(session, "failures", selected = c("0", "1", "2", "3"))
    updateSelectInput(session, "school", selected = "All")
  })
  
  output$avg_grade <- renderText({
    data <- filtered_data()
    if (nrow(data) == 0) return("N/A")
    avg_grade <- mean(data$G3, na.rm = TRUE)
    round(avg_grade, 2)
  })
  
  output$num_students <- renderText({
    data <- filtered_data()
    nrow(data)
  })
  
  output$failures_per_student <- renderText({
    data <- filtered_data()
    if (nrow(data) == 0) return("N/A")
    total_failures <- sum(data$failures, na.rm = TRUE)
    failures_per_student <- total_failures / nrow(data)
    round(failures_per_student, 2)
  })
  
  output$histPlot <- renderPlot({
    data <- filtered_data()
    if (nrow(data) == 0) return(NULL)
    ggplot(data, aes(x = G3)) + 
      geom_histogram(binwidth = 1, fill = "#4CAF50", alpha = 0.9) +
      labs(title = "Final Grade Distribution", x = "Final Grade (G3)", y = "Count") +
      theme_minimal() +
      theme(
        plot.title = element_text(hjust = 0.5, size = 18),
        axis.title = element_text(size = 14),
        axis.text = element_text(size = 12)
      ) +
      xlim(0, 20)  
  })
  
  output$scatterPlot <- renderPlot({
    data <- filtered_data()
    if (nrow(data) == 0) return(NULL)
    ggplot(data, aes(x = PrevG, y = G3)) + 
      geom_point() +  
      labs(title = "Previous Grades vs. Final Grade", x = "Previous Grade (PrevG)", y = "Final Grade (G3)") +
      theme_minimal() +
      theme(
        plot.title = element_text(hjust = 0.5, size = 18),
        axis.title = element_text(size = 14),
        axis.text = element_text(size = 12)
      ) +
      scale_color_viridis_c() +
      xlim(0, 20) +
      ylim(0, 20) 
  })
}

shinyApp(ui = ui, server = server)
