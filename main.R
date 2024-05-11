#### Main file
# Used to source all other files and execute the shiny application.


### Clearing environment ----
rm(list=ls())
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
cat("\014")


### General project setup ----
source("Code/General Project Setup/libraries.R")
source("Code/General Project Setup/input_constants.R")
source("Code/General Project Setup/custom_themes.R")
source("Code/General Project Setup/Custom Functions/functions_data_frames.R")
source("Code/General Project Setup/Custom Functions/functions_highcharter.R")
source("Code/General Project Setup/Custom Functions/functions_other.R")
source("Code/General Project Setup/data_import.R")
source("Code/General Project Setup/data_preprocessing.R")


### Dashboard components ----
## Tab items
source("Code/Dashboard Components/UI Components/Tab Items/ti_summary.R")
source("Code/Dashboard Components/UI Components/Tab Items/ti_income.R")
source("Code/Dashboard Components/UI Components/Tab Items/ti_expenses.R")
source("Code/Dashboard Components/UI Components/Tab Items/ti_investments.R")

## Main components
source("Code/Dashboard Components/UI Components/f_dbHeader.R")
source("Code/Dashboard Components/UI Components/f_dbBody.R")
source("Code/Dashboard Components/UI Components/f_dbFooter.R")
source("Code/Dashboard Components/UI Components/f_dbControlbar.R")
source("Code/Dashboard Components/UI Components/f_dbSidebar.R")

## UI and Server scripts
source("Code/Dashboard Components/ui.R")
source("Code/Dashboard Components/server.R")


### Running the application ----
shiny::shinyApp(ui = ui, server = server)
