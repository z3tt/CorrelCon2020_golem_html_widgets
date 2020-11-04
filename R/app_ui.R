#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny fullPage
#' @noRd
app_ui <- function(request) {
  
  options(
    spinner.type = 7,
    spinner.color="#11a579", 
    spinner.size = 1
  )
  
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here 
    fullPage::pagePiling(
      sections.color = c('#f1f1f1', '#dddddd'),
      opts = list(easing = "linear", keyboardScrolling = TRUE),
      menu = c(
        "interactive bar chart" = "bar",
        "interactive map" ="map"
      ),
      fullPage::pageSection(
        center = TRUE,
        menu = "bar",
        mod_bars_echarts_ui("bars_echarts_ui_1")
      ),
      fullPage::pageSection(
        center = TRUE,
        menu = "map",
        mod_map_tmap_ui("map_tmap_ui_1")
      )
    )
  )
}

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){
  
  add_resource_path(
    'www', app_sys('app/www')
  )
 
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'correlcon'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}

