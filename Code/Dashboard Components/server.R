#### Server

server <- function(input, output) {
  ### Reactive values
  ## List of reactive values
  r_ReactVals <- reactiveValues()
  
  ## Date range
  n_DateRangeR <- reactive({
    f_ProcessDateInput(
      dates       = c_AllDates, 
      year_start  = input$input_YearStart, 
      year_end    = input$input_YearEnd, 
      month_start = input$input_MonthStart, 
      month_end   = input$input_MonthEnd
    )
  })
  
  ## Other reactive values
  observe({
    ## Data frames
    df_IncomeR <- df_Income[intersect(which(df_Income$YearMonthNum >= n_DateRangeR()[1]), which(df_Income$YearMonthNum <= n_DateRangeR()[2])), ]
    df_IncomeR <- f_ReduceFilledDFs(df_IncomeR, "Category")
    df_ExpensesR <- df_Expenses[intersect(which(df_Expenses$YearMonthNum >= n_DateRangeR()[1]), which(df_Expenses$YearMonthNum <= n_DateRangeR()[2])), ]
    df_ExpensesR <- f_ReduceFilledDFs(df_ExpensesR, "Category")
    df_InvestmentsR <- df_Investments[intersect(which(df_Investments$YearMonthNum >= n_DateRangeR()[1]), which(df_Investments$YearMonthNum <= n_DateRangeR()[2])), ]
    df_InvestmentsR <- f_ReduceFilledDFs(df_InvestmentsR, "Name")
    df_InvestmentsPricesR <- df_InvestmentsPrices[intersect(
      which(df_InvestmentsPrices$YearMonthNum >= n_DateRangeR()[1]),
      which(df_InvestmentsPrices$YearMonthNum <= n_DateRangeR()[2])
    ), ]
    df_ProfitLossR <- f_ProfitLossDF(df_IncomeR, df_ExpensesR, df_InvestmentsR)
    if ( as.numeric(gsub("-", "", df_ProfitLossR[1, "YearMonth"])) < n_DateRangeR()[1] ) {
      df_ProfitLossR <- df_ProfitLossR[-1, ]
    }
    
    r_ReactVals$df_IncomeR <- df_IncomeR
    r_ReactVals$df_ExpensesR <- df_ExpensesR
    r_ReactVals$df_InvestmentsR <- df_InvestmentsR
    r_ReactVals$df_InvestmentsPricesR <- df_InvestmentsPricesR
    r_ReactVals$l_Assets <- split(df_InvestmentsR, df_InvestmentsR$AssetType)
    r_ReactVals$l_AssetsPrices <- split(df_InvestmentsPricesR, df_InvestmentsPricesR$AssetType)
    r_ReactVals$df_ProfitLossR <- df_ProfitLossR
    
    ## Profit numbers
    r_ReactVals$n_ProfitNumbers <- f_ProfitNumbers(df_ProfitLossR)
  })
  
  
  ### Outputs
  ## Summary
  output$out_ProfitTotal <- renderUI({ f_ProfitNumbers(r_ReactVals$df_ProfitLossR, FALSE) })
  output$out_ProfitPercOfInc <- renderUI({ f_ProfitNumbers(r_ReactVals$df_ProfitLossR, TRUE) })
  output$out_ProfitSources <- renderHighchart({ f_hcProfitSources(r_ReactVals$df_ProfitLossR) })
  output$out_ProfitOverTime <- renderHighchart({ f_hcProfitLossOverTime(r_ReactVals$df_ProfitLossR) })
  
  ## Income
  output$out_IncomeTable <- DT::renderDataTable({ f_FormatDT(r_ReactVals$df_IncomeR[, 1:5]) })
  output$out_IncomeByCategory <- renderHighchart({ fc_hcBarBy(r_ReactVals$df_IncomeR, "Category") })
  output$out_IncomeOverTime <- renderHighchart({ fc_hcAmountOverTime(r_ReactVals$df_IncomeR, c_ColGreen) })
  output$out_IncomeSankey <- renderHighchart({ f_hcSankey(
    r_ReactVals$df_IncomeR, c("Amount", "Category", "Source", "Product"), "Income", TRUE
  )})
  output$out_IncomeBySource <- renderHighchart({ fc_hcBarBy(r_ReactVals$df_IncomeR, "Category", "Source") })
  
  ## Expenses
  output$out_ExpensesTable <- DT::renderDataTable({ f_FormatDT(r_ReactVals$df_ExpensesR[, 1:5]) })
  output$out_ExpensesByCategory <- renderHighchart({ fc_hcBarBy(r_ReactVals$df_ExpensesR, "Category") })
  output$out_ExpensesOverTime <- renderHighchart({ fc_hcAmountOverTime(r_ReactVals$df_ExpensesR, c_ColRed) })
  output$out_ExpensesSankey <- renderHighchart({ f_hcSankey(
    r_ReactVals$df_ExpensesR, c("Amount", "Category", "Dealer", "Product"), "Expenses", FALSE
  )})
  output$out_ExpensesByDealer <- renderHighchart({ fc_hcBarBy(r_ReactVals$df_ExpensesR, "Category", "Dealer") })
  
  ## Investments
  output$out_InvestmentsAssetAllocation <- renderHighchart({ f_hcAssetAllocation(r_ReactVals$df_InvestmentsR) })
  output$out_InvestmentsAssetGains <- renderHighchart({ f_hcAssetGains(r_ReactVals$df_InvestmentsR, n_DateRangeR()[1]) })
  output$out_MetalsPriceChange <- renderHighchart({ f_hcAssetPriceDevelopment(r_ReactVals$l_AssetsPrices[["Metals"]]) })
  output$out_StocksPriceChange <- renderHighchart({ f_hcAssetPriceDevelopment(r_ReactVals$l_AssetsPrices[["Stocks"]]) })
}
