## code to prepare `accidents_sum_bikes` dataset goes here

download.file(
  "https://github.com/CorrelAid/xberlin/raw/master/data/accidents_sum_bikes.rda", 
  destfile = here::here("data", "accidents_sum_bikes.rda")
)

#usethis::use_data(accidents_sum_bikes, overwrite = TRUE)
