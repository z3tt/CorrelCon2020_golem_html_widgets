#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # List the first level callModules here
  callModule(mod_bars_echarts_server, "bars_echarts_ui_1")
  callModule(mod_map_tmap_server, "map_tmap_ui_1")
}
