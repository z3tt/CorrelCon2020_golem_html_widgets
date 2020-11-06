#' bars_echarts UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @import echarts4r dplyr
mod_bars_echarts_ui <- function(id){
  ns <- NS(id)
  fullPage::pageContainer(
    h1("An interactive bar chart"),
    br(),
    shinycssloaders::withSpinner(
      echarts4r::echarts4rOutput(ns("bars"), height = "50vh")
    ),
    br(), br(),
    p("Source: Statistische Ämter des Bundes und der Länder via", 
      tags$a(href="https://unfallatlas.statistikportal.de/_opendata2020.html", "Unfallatlas"))
  )
}
    
#' bars_echarts Server Function
#'
#' @noRd 
mod_bars_echarts_server <- function(input, output, session){
  ns <- session$ns
  
  output$bars <- echarts4r::renderEcharts4r({
    # set typeface for echarts
    echarts4r::e_common(
      font_family = "Overpass",
      theme = NULL
    )
    
    # var to color mapping
    my_colors <- tibble::tibble(
      type = c("Bikes", "Cars", "Motorcycles", "Pedestrians"),
      color = c("#b03a47", "#293c55", "#6ab0b8", "#e98f6f")
    )
    
    dat <- correlcon::accidents_sum_bikes %>%
      dplyr::left_join(my_colors, by = "type")
    
    dat %>%
      dplyr::group_by(type) %>% 
      echarts4r::e_charts(Gemeinde_name) %>% 
      echarts4r::e_bar(accidents) %>% 
      echarts4r::e_x_axis(axisTick = list(interval = 0), 
                          axisLabel = list(rotate = 30), 
                          nameGap = 35) %>% 
      echarts4r::e_grid(bottom = 100, left = 150) %>% 
      echarts4r::e_toolbox(bottom = 0) %>%
      echarts4r::e_toolbox_feature(feature = "dataZoom") %>%
      echarts4r::e_toolbox_feature(feature = "dataView") %>%
      echarts4r::e_show_loading()
  })
}
    
## To be copied in the UI
# mod_bars_echarts_ui("bars_echarts_ui_1")
    
## To be copied in the server
# callModule(mod_bars_echarts_server, "bars_echarts_ui_1")
 
