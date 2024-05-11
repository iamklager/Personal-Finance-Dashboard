#### Tab Item - Assets
# An asset page showing your asset allocation and how your assets did over time.

ti_investments <- tabItem(
  # Tab Name
  tabName = "tn_investments",
  
  ### Row 1
  fluidRow(
    # Asset Allocation
    box(
      title = "Asset Allocation",
      width = 6,
      highchartOutput("out_InvestmentsAssetAllocation")
    ),
    # Gains (in %)
    box(
      title = "Asset Gains (In %)",
      width = 6,
      highchartOutput("out_InvestmentsAssetGains")
    )
  ),
  
  ### Row 2
  fluidRow(
    # Price development (metals)
    box(
      title = "Asset Price Development (Metals)",
      width = 12,
      highchartOutput("out_MetalsPriceChange")
    )
  ),
  
  ### Row 3
  fluidRow(
    # Price development (stocks)
    box(
      title = "Asset Price Development (Stocks)",
      width = 12,
      highchartOutput("out_StocksPriceChange")
    )
  )
  
)