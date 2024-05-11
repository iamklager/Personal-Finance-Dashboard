#### Custom functions
# All custom functions used in the dashboard.


### Dates ----
f_ProcessDateInput<- function(dates, year_start, year_end, month_start, month_end) {
  ms <- ifelse(nchar(month_start) == 1, paste0("0", month_start), month_start)
  me <- ifelse(nchar(month_end) == 1, paste0("0", month_end), month_end)
  res <- dates[dates >= paste0(year_start, "-", ms)]
  res <- res[res <= paste0(year_end, "-", me)]
  res <- res[c(1, length(res))]
  res <- as.numeric(gsub("-", "", res))
  
  return(res)
}


### Text ----
f_FormatNumber <- function(number, symbol) {
  res <- as.character(number)
  DotPos <-  unlist(gregexpr("\\.", res))
  if (DotPos > 4) {
    res <- paste0(
      substr(res, 1, DotPos - 4),
      " ",
      substr(res, DotPos -3, nchar(res))
    )
  }
  res <- paste0(res, symbol)
}
f_ProfitNumbers <- function(df, of_income = FALSE) {
  Total <- sum(df$Profit)
  PercOfInc <- Total/sum(df$Income)
  res <- round(c(Total, PercOfInc*100), 2)
  Color <- ifelse(res[1] >= 0, c_ColGreen, c_ColRed)
  DisplayText <- ifelse(of_income, f_FormatNumber(res[2], "%"), f_FormatNumber(res[1], c_CurrencySymbol[1]))
  
  tags$span(
    style = paste0(
      "color:", Color, "; ",
      "font-family: Cardo; ",
      "font-weight: bold; ",
      "margin: auto; text-align: center; ",
      "font-size: 96px;"
    ),
    DisplayText
  )
}


### Data tables ----
f_FormatDT <- function(df) {
  if (nrow(df[df$Category != "-", ]) != 0) {
    df <- df[df$Category != "-", ]
  }
  res <- datatable(
    data = df, 
    filter = list(position = "top", clear = FALSE),
    options = list(
      autoWidth = TRUE,
      paging = TRUE,
      pageLength = 15,
      scrollX = FALSE,
      scrollY = TRUE,
      searching = TRUE
    ),
    rownames = FALSE
  )
  res <- formatCurrency(table = res, columns = "Amount", currency = c_CurrencySymbol[1], digits = 2, before = FALSE, rows = NULL)
  res <- formatDate(table = res, columns = "Date", method = "toLocaleDateString", params = NULL, rows = NULL)

  res
}
