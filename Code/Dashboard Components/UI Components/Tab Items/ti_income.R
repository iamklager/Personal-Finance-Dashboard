#### Tab Item - Income
# A income page categorizing your income by categories and sources.

ti_income <- tabItem(
  # Tab Name
  tabName = "tn_income",
  
  ### Row 1
  fluidRow(
    # Income by category
    box(
      title = "Income by Category",
      width = 6,
      highchartOutput("out_IncomeByCategory")
    ),
    # Income over time
    box(
      title = "Income Over Time",
      width = 6,
      highchartOutput("out_IncomeOverTime")
    )
  ),
  
  ### Row 2
  fluidRow(
    # Income by source
    box(
      title = "Income by Source",
      width = 12,
      highchartOutput("out_IncomeBySource")
    )
  ),
  
  ### Row 3
  fluidRow(
    # Income sankey
    box(
      title = "Sankey",
      width = 12,
      highchartOutput("out_IncomeSankey")
    )
  ),
  
  ### Row 4
  fluidRow(
    # Income as table
    box(
      title = "Income",
      width = 12,
      dataTableOutput("out_IncomeTable")
    )
  )
  
)