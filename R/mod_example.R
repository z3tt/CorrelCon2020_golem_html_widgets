#' example UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_example_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' example Server Function
#'
#' @noRd 
mod_example_server <- function(input, output, session){
  ns <- session$ns
 
}
    
## To be copied in the UI
# mod_example_ui("example_ui_1")
    
## To be copied in the server
# callModule(mod_example_server, "example_ui_1")
 
