#' map_tmap UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @import dplyr sf tmap
#' @importFrom shiny NS tagList 
mod_map_tmap_ui <- function(id){
  ns <- NS(id)
  fullPage::pageContainer(
    tags$style(
      type = "text/css", 
      "div.info.legend.leaflet-control {text-align:left; } 
       div.leaflet-control-layers-expanded {text-align:left;}"),
    h1("An interactive map"),
    br(),
    shinycssloaders::withSpinner(
      tmap::tmapOutput(ns("map"), height = 530)
    ),
    br(), br(),
    p("Source: Statistische Ämter des Bundes und der Länder via", 
      tags$a(href="https://unfallatlas.statistikportal.de/_opendata2020.html", "Unfallatlas"), 
      "• Geoportal Berlin via", 
      tags$a(href="https://data.technologiestiftung-berlin.de/", "Technologiestiftung Berlin"))
  )
}
    
#' map_tmap Server Function
#'
#' @noRd 
mod_map_tmap_server <- function(input, output, session){
  ns <- session$ns
  
  ## correct proj version for shinyapps.io
  traffic_summary_int <- traffic_summary
  sf::st_crs(traffic_summary_int) <- 3068 
  
  output$map <- renderTmap({
    
    tmap::tm_shape(traffic_summary_int, name = "Ratio Map") +
      tmap::tm_polygons(
        id = "NAME.x",
        col = "bike",
        title = "Number of reported\nbike accidents",
        palette = rev(rcartocolor::carto_pal(n = 5, "ag_Sunset")),
        breaks = c(1, 5, 10, 15, 20, 25, 30, Inf),
        alpha = .75, border.col = "white",
        legend.reverse = TRUE,
        textNA = "No Accidents in 2019",
        popup.vars = c("District:" = "Gemeinde_name",
                       "Total number of bike accidents:" = "n_total", 
                       "Accidents on bicycle infrastructure:" = "n_bike", 
                       "Proportion:" = "perc_bike")
      )
  })
}
    
## To be copied in the UI
# mod_map_tmap_ui("map_tmap_ui_1")
    
## To be copied in the server
# callModule(mod_map_tmap_server, "map_tmap_ui_1")
 
