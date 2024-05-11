#### Data frame functions
# All custom functions used to process data frames.


### General ----
f_FillEmptyMonths <- function(df) {
  c_MissingDates <- c_AllDates[!(c_AllDates %in% df$YearMonth)]
  if (length(c_MissingDates) != 0) {
    for (d in c_MissingDates) {
      n <- nrow(df) + 1
      df[n, intersect(which(sapply(df, is.numeric)), which(colnames(df) != "YearMonthNum"))] <- 0
      df[n, intersect(which(sapply(df, is.character)), which(colnames(df) != "YearMonth"))] <- "-"
      df[n, "YearMonth"] <- d
      df[n, "YearMonthNum"] <- as.numeric(gsub("-", "", d))
      if ("Date" %in% colnames(df)) {
        df[n, "Date"] <- as.Date(paste0(d, "-01"))
        df <- df[order(df$Date), ]
      } else {
        df <- df[order(df$YearMonth), ]
      }
    }
  }
  return(df)
}
f_ReduceFilledDFs <- function(df, some_col) {
  if (nrow(df[df[, some_col] != "-", ])) {
    df <- df[df[, some_col] != "-", ]
  }
  return(df)
}
f_FillNAs <- function(df, char_value = "Missing Value", num_value = 0) {
  numcols <- which(sapply(df, is.numeric))
  charcols <- which(sapply(df, is.character))
  df[, numcols] <- lapply(df[, numcols], function(x) {
    ifelse(is.na(x), num_value, x)
  })
  df[, charcols] <- lapply(df[, charcols], function(x) {
    ifelse(is.na(x), char_value, x)
  })
  
  return(df)
}


### Profit Loss ----
f_ProfitLossDF <- function(Income, Expenses, Investments) {
  Income <- aggregate.data.frame(
    x = Income$Amount,
    by = list(Income$YearMonth),
    FUN = sum
  )
  colnames(Income) <- c("YearMonth", "Income")
  
  Expenses <- aggregate.data.frame(
    x = Expenses$Amount,
    by = list(Expenses$YearMonth),
    FUN = sum
  )
  colnames(Expenses) <- c("YearMonth", "Expenses")
  Expenses$Expenses <- -Expenses$Expenses
  
  Investments <- aggregate.data.frame(
    x = Investments$MonthlyProfitTotal,
    by = list(Investments$YearMonth),
    FUN = sum
  )
  colnames(Investments) <- c("YearMonth", "Investments")
  
  res <- base::merge(x = Income, y = Expenses, all = TRUE)
  res <- base::merge(x = res, y = Investments, all = TRUE)
  res[is.na(res)] <- 0
  res$Profit <- res$Income + res$Expenses + res$Investments
  res[, 2:4] <- apply(res[, 2:4], 2, round, 2)
  
  return(res)
}


### Assets ----
f_QueryAsset <- function(df) {
  symbol <- df$TickerSymbol[1]
  asset <- df$Name[1]
  
  # Loading existing asset prices
  file_exists <- file.exists(paste0("Data/Assets/Prices/", asset, "_prices.csv"))
  if (file_exists) {
    df_AssetPrices <- read.csv(paste0("Data/Assets/Prices/", asset, "_prices.csv"), sep = ";")
    start_date <- max(as.Date(df_AssetPrices$Date), na.rm = TRUE) + 1
  } else {
    df_AssetPrices <- NULL
    start_date <- min(df$PurchaseDate)
  }
  
  # Querying new asset prices
  df_AssetPricesNew <- tryCatch(
    { # Try
      foo <- as.data.frame(loadSymbols(
        Symbols = symbol,
        src = "yahoo",
        from = start_date,
        env = NULL
      ))
      message(paste0("Queried prices for ", asset, "."))
      colnames(foo) <- c("Open", "High", "Low", "Close", "Volume", "Adjusted")
      foo$Date <- row.names(foo)
      row.names(foo) <- NULL
      foo <- foo[!(foo$Date %in% df_AssetPrices$Date), ]
      foo
    }, 
    error = function(e) { # Catch
      message(paste0("Prices for ", asset, " are already up to date."))
      NULL
    }
  )
  df_AssetPrices <- rbind(df_AssetPrices, df_AssetPricesNew)
  write.table(df_AssetPrices, paste0("Data/Assets/Prices/", asset, "_prices.csv"), sep = ";", row.names = FALSE)
  
  # For cases with missing prices
  for (i in 2:nrow(df_AssetPrices)) {
    if (is.na(df_AssetPrices$Adjusted[i])) {
      df_AssetPrices$Adjusted[i] <- df_AssetPrices$Adjusted[i-1]
    }
  }
  df_AssetPrices <- df_AssetPrices[, c("Date", "Adjusted")]
  colnames(df_AssetPrices)[2] <- "Price"
  df_AssetPrices$Name <- asset
  
  return(df_AssetPrices)
}
f_GetAssetPrices <- function(df, type) {
  # Case of empty data frames
  if (nrow(df) == 0) {
    asset <- data.frame(
      YearMonth = NULL, Name = NULL, Price = NULL, PurchasePrice = NULL,
      NetPrice = NULL, MonthlyProfitTotal = NULL
    )
    return(asset)
  }
  
  # Date format
  df$PurchaseDate <- as.Date(df$PurchaseDate)
  
  # Querying assets
  asset <- f_QueryAsset(df)
  
  # Merging onto old purchase data
  asset <- merge(
    x = asset, y = df[, c("PurchasePrice", "PurchaseDate", "PurchaseQuantity")], 
    by.x = "Date", by.y = "PurchaseDate", all.x = TRUE
  )
  
  # Price adjustment for metals (gram to ounce) or stocks (price * quantity)
  if (type == "stock") {
    asset$PurchasePrice <- asset$PurchasePrice*asset$PurchaseQuantity
  } else if (type == "metal") {
    asset$Price <- asset$Price/28.3495
  }
  
  # Converting currency to EUR
  if (df$SourceCurrency[1] != "EUR") {
    currency <- as.data.frame(loadSymbols(
      Symbols = paste0("EUR", df$SourceCurrency[1], "=X"),
      src = "yahoo",
      from = df$PurchaseDate[1],
      env = NULL
    ))
    currency <- data.frame(
      Date = rownames(currency),
      xRate = currency[, ncol(currency)]
    )
    asset <- merge(asset, currency)
    asset$Price <- asset$Price/asset$xRate
    asset <- asset[, 1:(ncol(asset) - 1)]
  }
  
  # Purchase price
  asset$PurchasePrice[is.na(asset$PurchasePrice)] <- 0
  asset$PurchasePrice <- cumsum(asset$PurchasePrice)
  
  # Purchase quantity
  asset$PurchaseQuantity[is.na(asset$PurchaseQuantity)] <- 0
  asset$PurchaseQuantity <- cumsum(asset$PurchaseQuantity)
  
  # Price changes
  asset$DeltaDailyPrice <- c(0, diff(asset$Price))
  
  # Total daily profit
  asset$DailyProfitTotal <- c(
    asset$Price[1]*asset$PurchaseQuantity[1] - asset$PurchasePrice[1],
    asset$DeltaDailyPrice[-1]*asset$PurchaseQuantity[-1]
  )
  
  # Prices separated (for price development)
  prices <- asset[, c("Date", "Name", "Price")]
  prices$YearMonth <- format(as.Date(prices$Date), "%Y-%m")
  prices <- bind_rows(lapply(split(prices, prices$YearMonth), function(x) {
    x[c(1, nrow(x)), ] 
  }))
  row.names(prices) <- NULL
  
  # Monthly profit
  asset$YearMonth <- format(as.Date(asset$Date), "%Y-%m")
  asset <- split(asset, list(asset$YearMonth))
  asset <- bind_rows(lapply(asset, function(x) {
    x$MonthlyProfitTotal <- sum(x$DailyProfitTotal)
    x$NetPrice <- x$Price * x$PurchaseQuantity
    x <- x[nrow(x), c("Name", "YearMonth", "Price", "PurchasePrice", "NetPrice" ,"MonthlyProfitTotal")]
  }))
  
  # Result
  res <- list(
    Asset = asset, 
    Prices = prices
  )
  
  return(res)
}

