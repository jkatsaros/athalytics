if (!require(remotes))
  install.packages("remotes", repos = "http://cran.us.r-project.org")
if (!require(tidyverse))
  install.packages("tidyverse", repos = "http://cran.us.r-project.org")

library(remotes)
library(tidyverse)

remotes::install_github("FantasyFootballAnalytics/ffanalytics")

possible_season_sources <- c(
  "CBS",
  "ESPN",
  "FantasyPros",
  "FantasySharks",
  "FFToday",
  "NumberFire",
  "FantasyFootballNerd",
  "NFL",
  "RTSports",
  "Walterfootball"
)
possible_week_sources <- c(
  "CBS",
  "ESPN",
  "FantasyPros",
  "FantasySharks",
  "FFToday",
  "FleaFlicker",
  "NumberFire",
  "FantasyFootballNerd",
  "NFL"
)
possible_position_sources <- c(
  "QB",
  "RB",
  "WR",
  "TE",
  "DST"
)

scrape_ffanalytics <- function(
  sources,
  positions,
  season = NULL,
  week = NULL
) {
  ffanalytics::scrape_data(
    src = sources,
    pos = positions,
    season = season,
    week = week
  )
}

projections_ffanaytics <- function(
  scrape_data,
  include_ecr = FALSE,
  include_adp = FALSE,
  include_aav = FALSE,
  include_uncertainty = FALSE
) {
  projections <- ffanalytics::projects_table(scrape_data)

  if (include_ecr) {
    projections <- projections %>%
      ffanalytics::add_ecr()
  }

  if (include_adp) {
    projections <- projections %>%
      ffanalytics::add_adp()
  }

  if (include_aav) {
    projections <- projections %>%
      ffanalytics::add_aav()
  }

  if (include_uncertainty) {
    projections <- projections %>%
      ffanalytics::add_uncertainty()
  }

  projections <- projections %>%
    ffanalytics::add_player_info()

  projections
}
