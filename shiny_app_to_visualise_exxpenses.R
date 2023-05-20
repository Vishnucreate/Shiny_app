# Install required packages if not already installed
if (!require(shiny)) {
  install.packages("shiny")
}

# Load required packages
library(shiny)
library(ggplot2)
library(dplyr)

# Define the UI portion of the app
ui <- fluidPage(
  titlePanel("Expense Tracker"),
  
  sidebarLayout(
    sidebarPanel(
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
  expenses <- reactiveVal(data.frame(Date = character(), Expense = numeric()))
  
  # Add expense button click event
  observeEvent(input$addExpense, {
    expense <- as.numeric(input$expense)
    
    if (!is.na(expense) && expense > 0) {
      new_expense <- data.frame(Date = Sys.time(), Expense = expense)
      expenses_data <- rbind(expenses(), new_expense)
      expenses_data$Date <- as.POSIXct(expenses_data$Date) # Convert Date column to POSIXct format
      expenses(expenses_data)
    }
    
    # Reset the input field
    updateTextInput(session, "expense", value = "")
  })
  
  # Generate and render expense plot
  output$expensePlot <- renderPlot({
    ggplot(expenses(), aes(x = Date, y = Expense)) +
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
