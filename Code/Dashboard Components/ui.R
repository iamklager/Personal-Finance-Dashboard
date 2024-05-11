#### User interface

ui <- dashboardPage(
  header = f_dbHeader,
  sidebar = f_dbSidebar,
  body = f_dbBody,
  controlbar = f_dbControlbar,
  footer = f_dbFooter,
  title = "Personal Finance Dashboard",
  freshTheme = theme_dbPage,
  preloader = NULL,
  options = NULL,
  fullscreen = FALSE,
  help = FALSE,
  dark = FALSE,
  scrollToTop = FALSE
)