#### Tab Item - Expenses
# A expense page categorizing your expenses by categories and sources.

ti_expenses <- tabItem(
  # Tab Name
  tabName = "tn_expenses",
  
  ### Row 1
  fluidRow(
    # Expenses by category
    box(
      title = "Expenses by Category",
      width = 6,
      highchartOutput("out_ExpensesByCategory")
    ),
    # Expenses over time
    box(
      title = "Expenses Over Time",
      width = 6,
      highchartOutput("out_ExpensesOverTime")
    )
  ),
  
  ### Row 2
  fluidRow(
    # Expenses by dealer
    box(
      title = "Expenses by Dealer",
      width = 12,
      highchartOutput("out_ExpensesByDealer")
    )
  ),
  
  ### Row 3
  fluidRow(
    # Expenses sankey
    box(
      title = "Sankey",
      width = 12,
      highchartOutput("out_ExpensesSankey")
    )
  ),
  
  ### Row 4
  fluidRow(
    # Expenses as table
    box(
      title = "Expenses",
      width = 12,
      dataTableOutput("out_ExpensesTable")
    )
  )
  
)