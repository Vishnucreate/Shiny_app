# Install required packages if not already installed
if (!require(shiny)) {
  install.packages("shiny")
}

# Load required packages
library(shiny)
library(ggplot2)
library(dplyr)
library(lubridate)

# Define the UI portion of the app
ui <- fluidPage(
  titlePanel("Monthly Expense Calculator"),
  
  sidebarLayout(
    sidebarPanel(
      dateInput("startDate", "Start Date:", value = Sys.Date() - 30),
      dateInput("endDate", "End Date:", value = Sys.Date()),
      numericInput("dailyExpense", "Daily Expense:", value = 0),
      actionButton("calculateButton", "Calculate Monthly Expense"),
      hr(),
      textOutput("monthlyExpenseOutput")
    ),
    
    mainPanel(
      plotOutput("expensePlot")
    )
  )
)

# Define the server logic
server <- function(input, output) {
  # Calculate monthly expenses
  monthly_expense <- eventReactive(input$calculateButton, {
    start_date <- input$startDate
    end_date <- input$endDate
    daily_expense <- input$dailyExpense
    
    # Calculate number of days between start and end dates
    num_days <- as.numeric(difftime(end_date, start_date, units = "days")) + 1
    
    # Calculate monthly expense
    monthly_expense <- num_days * daily_expense
    
    # Return monthly expense
    monthly_expense
  })
  
  # Display monthly expense output
  output$monthlyExpenseOutput <- renderText({
    paste("Monthly Expense: $", monthly_expense())
  })
  
  # Generate and render expense plot
  output$expensePlot <- renderPlot({
    data <- data.frame(
      Date = seq(input$startDate, input$endDate, by = "day"),
      Expense = input$dailyExpense
    )
    
    ggplot(data, aes(x = Date, y = Expense)) +
      geom_line() +
      labs(x = "Date", y = "Expense", title = "Daily Expense Over Time")
  })
}

# Run the app
shinyApp(ui = ui, server = server)
