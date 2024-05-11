#### Highcharter functions
# All custom functions used to generate highcharter charts.


### Profit Loss ----
f_hcProfitSources <- function(df, xcol) {
  df <- df[, c("YearMonth", "Income", "Expenses", "Investments")]
  df <- reshape2::melt(data = df, id.vars = "YearMonth", variable.name = "Source", value.name = "Amount")
  df <- aggregate.data.frame(df$Amount, list(df$Source), sum)
  colnames(df) <- c("Source", "Amount")
  df$Amount <- round(df$Amount, 2)
  res <- hchart(
    df,
    "column",
    hcaes(x = Source, y = Amount, group = "Source")
  )
  res <- hc_plotOptions(hc = res, column = list(borderWidth = 0))
  res <- hc_add_theme(hc = res, hc_thm = theme_HighCharts())
  res
}

f_hcProfitLossOverTime <- function(df) {
  df <- aggregate.data.frame(df$Profit, list(df$YearMonth), sum)
  colnames(df) <- c("Month", "Profit")
  df$Profit <- round(df$Profit, 2)
  df$Color <- ifelse(df$Profit >= 0, c_ColGreen, c_ColRed)
  df$CumProfit <- round(cumsum(df$Profit), 2)
  res <- hchart(df, "column", hcaes(x = Month, y = Profit, color = Color))
  res <- hc_plotOptions(hc = res, column = list(borderWidth = 0))
  res <- hc_add_series(res, data = df$CumProfit, type = "line", color = c_ColGray, name = "Profit Cumulated")
  res <- hc_add_theme(hc = res, hc_thm = theme_HighCharts())
  res
}


### Income & Expenses ----
fc_hcBarBy <- function(df, xcol, gcol = NULL) {
  if (xcol == "YearMonth") {
    xcol <- "Month"
    colnames(df)[colnames(df) == "YearMonth"] <- "Month"
  }
  if (is.null(gcol)) {
    df <- df[, c(xcol, gcol, "Amount")]
    colnames(df)[1] <- c("a")
    df <- aggregate.data.frame(df$Amount, list(df$a), sum)
    colnames(df) <- c("a", "Amount")
    df$Amount <- round(df$Amount, 2)
    
    res <- hchart(df, "column", hcaes(x = a, y = Amount, group = a))
    res <- hc_plotOptions(hc = res, column = list(borderWidth = 0))
  } else {
    df <- df[, c(xcol, gcol, "Amount")]
    colnames(df)[1:2] <- c("a", "g")
    df <- aggregate.data.frame(df$Amount, list(df$a, df$g), sum)
    colnames(df) <- c("a", "g", "Amount")
    df$Amount <- round(df$Amount, 2)
    
    res <- hchart(df, "column", hcaes(x = a, y = Amount, group = g))
    res <- hc_plotOptions(hc = res, column = list(stacking = "normal", borderWidth = 0))
  }
  res <- hc_xAxis(res, title = list(text = xcol))
  res <- hc_add_theme(hc = res, hc_thm = theme_HighCharts())
  res
}

fc_hcAmountOverTime <- function(df, color) {
  df <- aggregate.data.frame(df$Amount, list(df$YearMonth), sum)
  colnames(df) <- c("Month", "Amount")
  df$Amount <- round(df$Amount, 2)
  df$Color <- color
  res <- hchart(df, "column", hcaes(x = Month, y = Amount, color = Color))
  res <- hc_plotOptions(hc = res, column = list(borderWidth = 0))
  res <- hc_add_theme(hc = res, hc_thm = theme_HighCharts())
  res
}

f_hcSankey <- function(df, cols, total_name, flip = FALSE) {
  df <- as.data.frame(df[, cols])
  
  l_Sankey <- list()
  for (col2 in unique(df[, cols[2]])) {
    df_Sub <- df[df[, cols[2]] == col2, ]
    l_Sankey[[col2]] <- list(
      from = total_name, 
      to = col2, 
      weight = sum(df_Sub[, cols[1]])
    )
    names(l_Sankey) <- NULL
    
    for (col3 in unique(df_Sub[, cols[3]])) {
      df_Sub2 <- df_Sub[df_Sub[, cols[3]] == col3, ]
      l_Sankey[[col3]] <- list(
        from = col2,
        to = ifelse(col3 == col2, paste0(col3, " "), col3),
        weight = sum(df_Sub2[, cols[1]])
      )
      names(l_Sankey) <- NULL
      
      for (col4 in unique(df_Sub2[, cols[4]])) {
        df_Sub3 <- df_Sub2[df_Sub2[, cols[4]] == col4, ]
        l_Sankey[[col4]] <- list(
          from = col3,
          to = ifelse(col4 %in% c(col2, col3), paste0(col4, "  "), col4),
          weight = sum(df_Sub3[, cols[1]])
        )
        names(l_Sankey) <- NULL
      }
      
    }
    
  }
  df_Sankey <- as.data.frame(bind_rows(l_Sankey))
  df_Sankey$weight = round(df_Sankey$weight, 2)
  if (flip) {
    df_Sankey <- df_Sankey[, c(2, 1, 3)]
    colnames(df_Sankey)[1:2] <- c("from", "to")
  }
  
  res <- highchart(theme = theme_HighCharts())
  res <- hc_chart(res, type = 'sankey')
  res <- hc_add_series(res, data = df_Sankey)
  res
}


### Assets ----
f_hcAssetAllocation <- function(df) {
  df <- df[df$YearMonthNum == max(df$YearMonthNum), ]
  df$NetPrice <- round(df$NetPrice, 2)
  res <- hchart(
    df,
    "column",
    hcaes(x = AssetType, y = NetPrice, group = Name)
  )
  res <- hc_plotOptions(hc = res, column = list(borderWidth = 0, stacking = "normal"))
  res <- hc_xAxis(res, title = list(text = "Asset Type"))
  res <- hc_yAxis(res, title = list(text = "Total Assets"))
  res <- hc_add_theme(hc = res, hc_thm = theme_HighCharts())
  res
}

f_hcAssetGains <- function(df, yearmonth) {
  df <- df[as.numeric(gsub("-", "", df$YearMonth)) >= yearmonth, ]
  df <- split(df, df$Name)
  df <- dplyr::bind_rows(lapply(df, function(x) {
    x$GainPercent <- (sum(x$MonthlyProfitTotal)/x$PurchasePrice[nrow(x)])
    x <- x[x$YearMonthNum == max(x$YearMonthNum), ]
    return(x)
  }))
  df$GainPercent <- round(df$GainPercent*100, 2)
  res <- hchart(
    df,
    "column",
    hcaes(x = AssetType, y = GainPercent, group = Name)
  )
  res <- hc_plotOptions(hc = res, column = list(borderWidth = 0, stacking = "normal"))
  res <- hc_xAxis(res, title = list(text = "Asset Type"))
  res <- hc_yAxis(res, title = list(text = "Gain (In %)"))
  res <- hc_add_theme(hc = res, hc_thm = theme_HighCharts())
  res
}

f_hcAssetPriceDevelopment <- function(df) {
  df <- split(df, df$Name)
  df <- bind_rows(lapply(df, function(x) {
    x <- rbind(
      x[1, ],
      bind_rows(lapply(split(x, x$YearMonthNum), function(y) { y[nrow(y), ]}))
    )
    x$DeltaPrice <- round((x$Price/x$Price[1])*100, 2)
    
    return(x)
  }))
  
  res <- hchart(
    df,
    "line",
    hcaes(x = YearMonth, y = DeltaPrice, group = Name)
  )
  res <- hc_xAxis(res, title = list(text = "Month"))
  res <- hc_yAxis(res, title = list(text = "Price (In % of Starting Price)"))
  res <- hc_add_theme(hc = res, hc_thm = theme_HighCharts())
  res
}


