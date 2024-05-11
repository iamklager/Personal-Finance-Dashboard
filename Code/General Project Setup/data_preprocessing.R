#### Data preprocessing
# All of the processing of data necessary before running the shiny application.


### Formatting dates ----
# Month and year column
df_Income$YearMonth <- substr(df_Income$Date, 1, 7)
df_Expenses$YearMonth <- substr(df_Expenses$Date, 1, 7)
# Numeric version for easier filtering of the reactive data frames
df_Income$YearMonthNum <- as.numeric(gsub("-", "", df_Income$YearMonth))
df_Expenses$YearMonthNum <- as.numeric(gsub("-", "", df_Expenses$YearMonth))


### Filling NAs in Income & Expenses ----
df_Income   <- f_FillNAs(df_Income, c_NAFill, n_NAFill)
df_Expenses <- f_FillNAs(df_Expenses, c_NAFill, n_NAFill)


### Processing investments ----
# Metals
df_Metals <- split(df_Metals, list(df_Metals$TickerSymbol))
l_Metals <- lapply(df_Metals, f_GetAssetPrices, "metal")
df_Metals <- bind_rows(lapply(l_Metals, function(x) { x$Asset }))
df_Metals$AssetType <- "Metals"
df_MetalsPrices <- bind_rows(lapply(l_Metals, function(x) { x$Prices }))
df_MetalsPrices$AssetType <- "Metals"

# Stocks
df_Stocks <- split(df_Stocks, list(df_Stocks$TickerSymbol))
l_Stocks <- lapply(df_Stocks, f_GetAssetPrices, "stock")
df_Stocks <- bind_rows(lapply(l_Stocks, function(x) { x$Asset }))
df_Stocks$AssetType <- "Stocks"
df_StocksPrices <- bind_rows(lapply(l_Stocks, function(x) { x$Prices }))
df_StocksPrices$AssetType <- "Stocks"

# Total investments
df_Investments <- rbind(df_Metals, df_Stocks)
df_Investments$YearMonthNum <- as.numeric(gsub("-", "", df_Investments$YearMonth))

# Total investments prices
df_InvestmentsPrices <- rbind(df_MetalsPrices, df_StocksPrices)
df_InvestmentsPrices$YearMonthNum <- as.numeric(gsub("-", "", df_InvestmentsPrices$YearMonth))


### Date vector for start selection ----
c_AllDates <- seq(as.Date(min(df_Income$Date, df_Expenses$Date)), Sys.Date(), by = "days")
c_AllDates <- unique(substr(c_AllDates, 1, 7))
if (!b_LimitDatesToIncExp) {
  c_AllDates <- sort(union(c_AllDates, df_Investments$YearMonth))
}
n_AllYears <- as.numeric(sort(unique(substr(c_AllDates, 1, 4))))


### Adding empty observations if no entries for a certain month ----
df_Income            <- f_FillEmptyMonths(df_Income)
df_Expenses          <- f_FillEmptyMonths(df_Expenses)
df_Investments       <- f_FillEmptyMonths(df_Investments)
df_InvestmentsPrices <- f_FillEmptyMonths(df_InvestmentsPrices)


### Removing variables ----
rm(
  df_Metals, df_MetalsPrices, df_Stocks, df_StocksPrices, l_Metals, l_Stocks,
  b_LimitDatesToIncExp, f_FillNAs, f_GetAssetPrices
)

