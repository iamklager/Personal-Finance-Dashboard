# Personal-Finance-Dashboard

A dashboard to monitor your personal finances. Built in R using Shiny.

## Idea

This tool allows the user to analyze their personal finances on a monthly basis.  
It consists of a [Summary](#summary) tab in which a summary of the development of one's finances is shown, an [Income](#income) tab in which the user's income is displayed, an [Expenses](#expenses) tab which is virtually identical to the income tab but displays expenses, and the [Investments](#investments) tab which provides an overview of one's investments and their development.

## Data

The tool uses the .xlsx files found in the *Data* folder as its source for incomes, expenses and the assets held by the user (note that daily price data is queried from Yahoo Finance.  

### Income

The user's income is stored in the *income.xlsx* file (feel free to connect a database or anything else that makes this more user-friendly for you), which stores the date at which the income flow occurred (*Date*), the amount (*Amount*), the product or service from which this income  stems (*Product*), its source (*Source*), as well as its category (*Category*).

### Expenses

The user's expenses are stored in the *expenses.xlsx* file, which is virtually identical to the *income.xlsx* file, except for the fact that the *Source* column is replaced by a *Dealer* column.

### Investments

In the *Assets* folder, the user can find two files (*stocks.csv* and *metals.csv*) that store his investments. The distinction into stocks and metals is mostly a design choice. However, prices for the assets in the *metals.csv* are adjusted to correspond to grams instead of ounces. Hence, the user might want to store assets such as cryptocurrencies in the *stocks.csv* to avoid wrong representations of prices.

#### Stocks

In the *stocks.csv* file, one needs to store the name which should be used for the investment (*Name*), its ticker symbol corresponding to the ticker symbols found on Yahoo Finance (*TickerSymbol*) the price (per share) at which it has been purchased (*PurchasePrice*), the date at which it has been purchased (*PurchaseDate*), how many shares have been purchased (*PurchaseQuantity*), and the currency in which the prices are listed on Yahoo Finance (*SourceCurrency*). This last column is necessary, since the tool converts all prices to EUR, as I am based in the EU.

### Metals

Again, the *metals.csv* file is virtually identical to the *stocks.csv* file and should be treated the same way.

## Requirements

To run this project, the user must have installed R and R-Studio in combination with the following libraries:
- *shiny*
- *shinyWidgets*
- *bs4Dash*
- *fresh*
- *DT*
- *highcharter*
- *readxl*
- *reshape2*
- *dplyr*
- *quantmod*


## Layout

### Sidebar

The sidebar enables the user to specify the time frame of his analysis, as well as to select the Income, Expenses, and Investments tabs.

### Summary

The summary page provides the user with their total profit or loss over the selected time frame, as well as his profit or loss as a percentage of his income.  
Additionally, his total income, expenses and the total profit or loss of his assets is displayed in one chart, while his monthly net profits and losses, as wells as their cumulative values are displayed in a second chart.

### Income

In the Income tab, three different charts display the user's total income split across categories, months and sources.  
A Sankey chart shows how the user's total income cumulates from individual positions to the different sources and lastly the different categories.  
Last, each individual income-position is displayed in a table which can be filtered.

### Expenses

As mentioned earlier, the Expenses tab is virtually identical to the Income tab.

### Investments

The investments tab displays the user's asset allocation, his assets' gains as percentages, as well as the monthly price developments of each asset.
