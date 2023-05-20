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
  titlePanel("Monthly Expense Tracker"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("month", "Select Month:", choices = month.name),
      numericInput("groceries", "Groceries Expense:", value = 0),
      numericInput("transportation", "Transportation Expense:", value = 0),
      numericInput("rent", "Rent Expense:", value = 0),
      numericInput("entertainment", "Entertainment Expense:", value = 0),
      actionButton("addExpense", "Add Expense"),
      hr(),
      plotOutput("expensePlot"),
      hr(),
      dataTableOutput("expenseTable")
    ),
    
    mainPanel()
  )
)

# Define the server logic
server <- function(input, output) {
  # Track expenses
  expenses <- reactiveVal(data.frame(Month = character(), Groceries = numeric(), Transportation = numeric(), Rent = numeric(), Entertainment = numeric()))
  
  # Add expense button click event
  observeEvent(input$addExpense, {
    month <- input$month
    groceries <- as.numeric(input$groceries)
    transportation <- as.numeric(input$transportation)
    rent <- as.numeric(input$rent)
    entertainment <- as.numeric(input$entertainment)
    
    if (!is.na(groceries) && !is.na(transportation) && !is.na(rent) && !is.na(entertainment) &&
        groceries >= 0 && transportation >= 0 && rent >= 0 && entertainment >= 0) {
      new_expense <- data.frame(Month = month, Groceries = groceries, Transportation = transportation, Rent = rent, Entertainment = entertainment)
      expenses_data <- rbind(expenses(), new_expense)
      expenses(expenses_data)
    }
    
    # Reset the input fields
    updateSelectInput(session, "month", selected = month)
    updateNumericInput(session, "groceries", value = 0)
    updateNumericInput(session, "transportation", value = 0)
    updateNumericInput(session, "rent", value = 0)
    updateNumericInput(session, "entertainment", value = 0)
  })
  
  # Calculate total expenses for each month
  monthly_expenses <- reactive({
    expenses() %>%
      group_by(Month) %>%
      summarise(
        Groceries = sum(Groceries),
        Transportation = sum(Transportation),
        Rent = sum(Rent),
        Entertainment = sum(Entertainment)
      )
  })
  
  # Generate and render expense plot
  output$expensePlot <- renderPlot({
    ggplot(monthly_expenses(), aes(x = Month)) +
      geom_bar(aes(y = Groceries), fill = "steelblue", stat = "identity", position = "stack") +
      geom_bar(aes(y = Transportation), fill = "lightblue", stat = "identity", position = "stack") +
      geom_bar(aes(y = Rent), fill = "lightgreen", stat = "identity", position = "stack") +
      geom_bar(aes(y = Entertainment), fill = "pink", stat = "identity", position = "stack") +
      labs(x = "Month", y = "Expense", title = "Monthly Expense Breakdown") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
  
  # Render expense table
  output$expenseTable <- renderDataTable({
    monthly_expenses()
  })
}

# Run the app
shinyApp(ui = ui, server = server)
