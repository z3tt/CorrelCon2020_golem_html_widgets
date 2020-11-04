## code to prepare `accidents_sum_all` dataset goes here

download.file(
  "https://github.com/CorrelAid/xberlin/raw/master/data/accidents_sum_all.rda", 
  destfile = here::here("data", "accidents_sum_all.rda")
)

#usethis::use_data(accidents_sum_all, overwrite = TRUE)
