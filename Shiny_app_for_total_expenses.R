library(shiny)

ui <- fluidPage(
  titlePanel("Monthly Expenses Calculator"),
  sidebarLayout(
    sidebarPanel(
      numericInput("rent", "Rent:", value = 0),
      numericInput("utilities", "Utilities:", value = 0),
      numericInput("groceries", "Groceries:", value = 0),
      numericInput("transportation", "Transportation:", value = 0),
      numericInput("entertainment", "Entertainment:", value = 0),
      numericInput("other", "Other Expenses:", value = 0)
    ),
    mainPanel(
      h3("Total Monthly Expenses:"),
      textOutput("totalExpenses")
    )
  )
)

server <- function(input, output) {
  output$totalExpenses <- renderText({
    total <- input$rent + input$utilities + input$groceries +
      input$transportation + input$entertainment + input$other
    paste("$", total)
  })
}

shinyApp(ui, server)

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



