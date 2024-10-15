if (!require(plumber))
  install.packages("plumber", repos = "http://cran.us.r-project.org")
if (!require(here))
  install.packages("here", repos = "http://cran.us.r-project.org")

library(plumber)
library(here)

pr() %>%
  pr_get(
    path = "/",
    responses = list("200" = list(description = "Health check."))
  ) %>%
  pr_mount("/football", plumb(here::here("football-api.R"))) %>%
  pr_run()