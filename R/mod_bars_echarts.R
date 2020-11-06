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
    ##### ADD BUTTIONS FOR SOURCE DATA + CHART TYPE ----------------------------
    fluidRow(
      column(
        4,
        shinyWidgets::radioGroupButtons(
          inputId = ns("data"),
          label = "Choose data",
          choices = c("All accidents", "Bike accidents"),
          checkIcon = list(
            yes = icon("ok",
                       lib = "glyphicon")
          )
        )
      ),
      column(
        4,
        uiOutput(ns("types_select_generated"))
      ),
      column(
        4,
        shinyWidgets::radioGroupButtons(
          inputId = ns("chart"),
          label = "Choose chart type",
          choices = c("Dodged bars", "Stacked bars"),
          selected = "Stacked bars",
          checkIcon = list(
            yes = icon("ok",
                       lib = "glyphicon")
          )
        )
      )
    ),
    ##### END ADD BUTTIONS FOR SOURCE DATA + CHART TYPE ------------------------
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
  
  ##### ADD SELECTED OUTPUT ----------------------------------------------------
  output$types_select_generated <- renderUI({
    
    selectizeInput(
      ns("types_select"),
      "Choose road user",
      choices = c("Bikes", "Cars", "Motorcycles", "Pedestrians"),
      selected = c("Bikes", "Cars"),
      multiple = TRUE
    )
  })
  ##### END ADD SELECTED OUTPUT ------------------------------------------------
  
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
    
    ##### ADD VARIOUS DATA SOURCES ---------------------------------------------
    if (input$data == "All accidents") { dat <- xberlin::accidents_sum_all }
    if (input$data == "Bike accidents") { dat <- xberlin::accidents_sum_bikes }
    
    dat <- dplyr::left_join(dat, my_colors, by = "type")
    ##### END ADD VARIOUS DATA SOURCES -----------------------------------------
    
     e <- dat %>%
      dplyr::group_by(type) %>% 
      echarts4r::e_charts(Gemeinde_name) %>% 
      #echarts4r::e_bar(accidents) %>% 
      echarts4r::e_x_axis(axisTick = list(interval = 0), 
                          axisLabel = list(rotate = 30), 
                          nameGap = 35) %>% 
      echarts4r::e_grid(bottom = 100, left = 150) %>% 
      echarts4r::e_toolbox(bottom = 0) %>%
      echarts4r::e_toolbox_feature(feature = "dataZoom") %>%
      echarts4r::e_toolbox_feature(feature = "dataView") %>%
      echarts4r::e_show_loading()
    
    ##### CHANGE CHART TYPE BASED ON INPUT -------------------------------------
    if (input$chart == "Dodged bars") {
      e %>% echarts4r::e_bar(accidents)
    } else {
      e %>% echarts4r::e_bar(accidents, stack = "grp")
    }
    ##### END CHANGE CHART TYPE BASED ON INPUT ---------------------------------
  })
}
    
## To be copied in the UI
# mod_bars_echarts_ui("bars_echarts_ui_1")
    
## To be copied in the server
# callModule(mod_bars_echarts_server, "bars_echarts_ui_1")
 
