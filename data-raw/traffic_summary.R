## code to prepare `traffic_summary` dataset goes here

download.file(
  "https://github.com/CorrelAid/xberlin/raw/master/data/traffic_summary.rda", 
  destfile = here::here("data", "traffic_summary.rda")
)

#usethis::use_data(traffic_summary, overwrite = TRUE)
