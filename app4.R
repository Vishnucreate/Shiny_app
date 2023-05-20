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
      dataTableOutput("expenseTable")
    ),
    
    mainPanel(
      plotOutput("expensePlot")
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
  
  # Calculate total expenses for each month
  monthly_expenses <- reactive({
    expenses() %>%
      group_by(Month) %>%
      summarise(TotalExpense = sum(Expense))
  })
  
  # Render expense table
  output$expenseTable <- renderDataTable({
    monthly_expenses()
  })
  
  # Generate and render expense plot
  output$expensePlot <- renderPlot({
    ggplot(monthly_expenses(), aes(x = Month, y = TotalExpense)) +
      geom_bar(stat = "identity", fill = "steelblue") +
      labs(x = "Month", y = "Total Expenses", title = "Total Expenses by Month") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
}

# Run the app
shinyApp(ui = ui, server = server)
