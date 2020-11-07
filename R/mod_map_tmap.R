#' map_tmap UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @import fullPage dplyr sf tmap
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
    ##### ADD BUTTIONS FOR SOURCE DATA -----------------------------------------
    fluidRow(
      column(2),
      column(
        8,
        shinyWidgets::radioGroupButtons(
          inputId = ns("data"),
          label = "Choose set of bike accidents",
          choices = c("All bike accidents", "Accidents on roads", "Accidents on bicycle infrastructure"),
          checkIcon = list(
            yes = icon("ok",
                       lib = "glyphicon")
          )
        )
      )
    ),
    ##### END ADD BUTTIONS FOR SOURCE DATA -------------------------------------
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
        col = "bike", alpha = .75, border.col = "white",
        palette = rev(rcartocolor::carto_pal(n = 5, "ag_Sunset")),
        breaks = c(1, 5, 10, 15, 20, 25, 30, Inf),
        legend.reverse = TRUE,
        textNA = "No Accidents in 2019",
        title = "Number of reported\nbike accidents"
      )
  })
  ##### UPDATE MAP BASED ON INPUT ----------------------------------------------
  observe({
    if(input$data == "Accidents on roads") { var <- "road" }
    if(input$data == "Accidents on bicycle infrastructure") { var <- "bike" }
    if(input$data == "All bike accidents") { var <- "total" }

    tmapProxy("map", session, {
      tm_shape(traffic_summary_int, name = "Ratio Map") +
        tm_polygons(
          id = "NAME.x",
          col = var, alpha = .75, border.col = "white",
          palette = rev(rcartocolor::carto_pal(n = 5, "ag_Sunset")),
          breaks = c(1, 5, 10, 15, 20, 25, 30, Inf),
          legend.reverse = TRUE,
          textNA = "No Accidents in 2019",
          title = "Number of reported\nbike accidents",
          popup.vars = c("District:" = "Gemeinde_name",
                         "Total number of bike accidents:" = "n_total",
                         "Accidents on bicycle infrastructure:" = "n_bike",
                         "Proportion:" = "perc_bike")
        )
    })
  })
  ##### END UPDATE MAP BASED ON INPUT ------------------------------------------
}

## To be copied in the UI
# mod_map_tmap_ui("map_tmap_ui_1")

## To be copied in the server
# callModule(mod_map_tmap_server, "map_tmap_ui_1")
