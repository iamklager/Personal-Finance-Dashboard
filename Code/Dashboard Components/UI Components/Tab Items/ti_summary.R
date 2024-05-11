#### Tab Item - Summary
# A summary page showing how you did over time

ti_summary <- tabItem(
  # Tab Name
  tabName = "tn_summary",
  
  ### Row 1
  fluidRow(
    # Total profit/loss
    box(
      title = "Profit/Loss (Total)",
      width = 6,
      style = "text-align: center;",
      uiOutput("out_ProfitTotal")
    ),
    # Profit/loss as percentage of income
    box(
      title = "Profit/Loss (As % of Income)",
      width = 6,
      style = "text-align: center;",
      uiOutput("out_ProfitPercOfInc")
    )
  ),
  
  ### Row 2
  fluidRow(
    # Income, Expenses, and Investments
    box(
      title = "Income, Expenses, and Investments",
      width = 4,
      highchartOutput("out_ProfitSources")
    ),
    # Profit/loss over time
    box(
      title = "Profit/Loss Over Time",
      width = 8,
      highchartOutput("out_ProfitOverTime")
    )
  )
  
)