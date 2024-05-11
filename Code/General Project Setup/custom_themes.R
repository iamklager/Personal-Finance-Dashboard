#### Custom theme
# The custom fresh theme used.


### Colors ----
c_BGCol1 <- "#fff1e0"
c_BGCol2 <-  "#EAC696"
c_TextCol1 <- "#000000"
c_TextCol2 <- "#666666"
c_FillCol1 <- "#C38154"


### Dashboard page themes ----
theme_dbPage <- fresh::create_theme(
  
  bs4dash_vars(
    navbar_light_color = c_TextCol1,
    navbar_light_active_color = "#FFF",
    navbar_light_hover_color = "#FFF"
  ),
  
  bs4dash_yiq(
    contrasted_threshold = 10,
    text_dark = c_TextCol2
  ),
  
  bs4dash_layout(
    main_bg = c_BGCol2
  ),
  
  bs4dash_sidebar_dark(
    bg = c_BGCol1,
    color = c_TextCol2,
    hover_color = c_TextCol1,
    submenu_bg = c_BGCol1,
    submenu_color = c_TextCol2,
    submenu_hover_color = c_TextCol1,
    submenu_active_color = c_TextCol1,
    header_color = c_TextCol1
  ),
  
  bs4dash_status(
    primary = c_FillCol1, danger = "#BF616A", light = c_BGCol1
  ),
  
  bs4dash_color(
    gray_900 = c_TextCol2, white = c_BGCol1
  )
  
)


### Highcharter themes ----
theme_HighCharts <- function(...) {
  set.seed(1234)
  c_Colors = c("#005f73", "#0a9396", "#94d2bd", "#ca6702", "#bb3e03", "#ae2012", "#9b2226")
  c_Colors = sample(c_Colors, length(c_Colors), replace = FALSE)
  theme <- list(
    colors = c_Colors,
    
    chart = list(
      backgroundColor = "#fff1e0",
      style = list(
        fontFamily = "Cardo",
        color = "#777"
      )
    ),
    
    title = list(
      align = "left",
      style = list(
        fontFamily = "Cardo",
        color = "black",
        fontWeight = "bold"
      )
    ),
    
    subtitle = list(
      align = "left",
      style = list(
        fontFamily = "Cardo",
        fontWeight = "bold"
      )
    ),
    
    yAxis = list(
      gridLineDashStyle = "Dot",
      gridLineColor = "#CEC6B9",
      lineColor = "#CEC6B9",
      minorGridLineColor = "#CEC6B9",
      labels = list(
        align = "left",
        x = 0,
        y = -2
      ),
      tickLength = 0,
      tickColor = "#CEC6B9",
      tickWidth = 1,
      title = list(
        style = list(
          color = "#74736c"
        )
      )
    ),
    
    tooltip = list(
      backgroundColor = "#FFFFFF",
      borderColor = "#76c0c1",
      style = list(
        color = "#000000"
      )
    ),
    
    legend = list(
      itemStyle = list(
        color = "#3C3C3C"
      ),
      itemHiddenStyle = list(
        color = "#606063"
      )
    ),
    
    credits = list(
      style = list(
        color = "#666"
      )
    ),
    
    labels = list(
      style = list(
        color = "#D7D7D8"
      )
    ),
    
    drilldown = list(
      activeAxisLabelStyle = list(
        color = "#F0F0F3"
      ),
      activeDataLabelStyle = list(
        color = "#F0F0F3"
      )
    ),
    
    navigation = list(
      buttonOptions = list(
        symbolStroke = "#DDDDDD",
        theme = list(
          fill = "#505053"
        )
      )
    ),
    
    legendBackgroundColor = "rgba(0, 0, 0, 0.5)",
    
    background2 = "#505053",
    
    dataLabelsColor = "#B0B0B3",
    
    textColor = "#C0C0C0",
    
    contrastTextColor = "#F0F0F3",
    
    maskColor = "rgba(255,255,255,0.3)"
  )
  
  theme <- structure(theme, class = "hc_theme")
  
  if (length(list(...)) > 0) {
    theme <- hc_theme_merge(
      theme,
      hc_theme(...)
    )
  }
  
  theme
}


### Removing variables ----
rm(c_BGCol1, c_BGCol2, c_TextCol1, c_TextCol2, c_FillCol1)