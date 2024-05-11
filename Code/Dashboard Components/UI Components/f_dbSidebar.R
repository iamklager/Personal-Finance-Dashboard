#### Dashboard Sidebar ----
f_dbSidebar <- dashboardSidebar(
  disable = FALSE,
  width = NULL,
  skin = "dark",
  status = "primary",
  elevation = 4,
  collapsed = FALSE,
  minified = TRUE,
  expandOnHover = TRUE,
  fixed = TRUE,
  id = "sidebar",
  customArea = NULL,
  
  ### Sidebar User Panel
  sidebarUserPanel(
    image = "https://cdn-icons-png.flaticon.com/512/1907/1907675.png",
    name = "My Finances"
  ),
  
  ### Date selectors
  div(
    style = "display: flex;",
    pickerInput(
      inputId = "input_YearStart",
      label = "Start Year",
      choices = n_AllYears,
      selected = n_AllYears[1]
    ),
    pickerInput(
      inputId = "input_MonthStart",
      label = "Start Month",
      choices = as.character(1:12),
      selected = "1"
    )
  ),
  div(
    style = "display: flex;",
    
    pickerInput(
      inputId = "input_YearEnd",
      label = "End Year",
      choices = n_AllYears,
      selected = n_AllYears[length(n_AllYears)]
    ),
    pickerInput(
      inputId = "input_MonthEnd",
      label = "End Month",
      choices = as.character(1:12),
      selected = "12"
    )
  ),
  
  ### Sidebar Menu
  sidebarMenu(
    id = "id_SidebarMenu",
    sidebarHeader("Tabs"),
    flat = FALSE,
    
    ## Summary,
    menuItem(
      text = "Summary",
      tabName = "tn_summary",
      icon = icon(name = "plus-minus", lib = "font-awesome"),
      startExpanded = TRUE
    ),
    
    ## Income,
    menuItem(
      text = "Income",
      tabName = "tn_income",
      icon = icon(name = "plus", lib = "font-awesome"),
      startExpanded = TRUE
    ),
    
    ## Expenses,
    menuItem(
      text = "Expenses",
      tabName = "tn_expenses",
      icon = icon(name = "minus", lib = "font-awesome"),
      startExpanded = TRUE
    ),
    
    ## Investments,
    menuItem(
      text = "Investments",
      tabName = "tn_investments",
      icon = icon(name = "hand-holding-dollar", lib = "font-awesome"),
      startExpanded = TRUE
    )
    
  )
)