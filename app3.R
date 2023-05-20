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
  titlePanel("Expense Tracker"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("month", "Select Month:", choices = month.name),
      textInput("expense", "Expense:", ""),
      actionButton("addExpense", "Add Expense"),
      hr(),
      plotOutput("expensePlot")
    ),
    
    mainPanel(
      dataTableOutput("expenseTable")
    )
  )
)

# Define the server logic
server <- function(input, output) {
  # Track expenses
  expenses <- reactiveVal(data.frame(Month = character(), Date = character(), Expense = numeric()))
  
  # Add expense button click event
  observeEvent(input$addExpense, {
    month <- input$month
    expense <- as.numeric(input$expense)
    
    if (!is.na(expense) && expense > 0) {
      new_expense <- data.frame(Month = month, Date = Sys.time(), Expense = expense)
      expenses_data <- rbind(expenses(), new_expense)
      expenses_data$Date <- as.POSIXct(expenses_data$Date) # Convert Date column to POSIXct format
      expenses(expenses_data)
    }
    
    # Reset the input fields
    updateSelectInput(session, "month", selected = month)
    updateTextInput(session, "expense", value = "")
  })
  
  # Generate and render expense plot
  output$expensePlot <- renderPlot({
    filtered_expenses <- expenses() %>% filter(Month %in% input$month)
    ggplot(filtered_expenses, aes(x = Date, y = Expense)) +
      geom_line() +
      labs(x = "Date", y = "Total Expenses", title = "Total Expenses Over Time")
  })
  
  # Render expense table
  output$expenseTable <- renderDataTable({
    expenses()
  })
}

# Run the app
shinyApp(ui = ui, server = server)
