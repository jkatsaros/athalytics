if (!require(remotes))
  install.packages("remotes", repos = "http://cran.us.r-project.org")
if (!require(tidyverse))
  install.packages("tidyverse", repos = "http://cran.us.r-project.org")
if (!require(lubridate))
  install.packages("lubridate", repos = "http://cran.us.r-project.org")

library(remotes)
library(tidyverse)
library(lubridate)

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
  sources = NULL,
  positions = NULL,
  season = NULL,
  week = NULL
) {
  if (sources == NULL) {
    if (week != NULL) {
      sources <- possible_week_sources
    } else {
      sources <- possible_season_sources
    }
  }
  
  if (positions == NULL) {
    positions <- possible_position_sources
  }
  
  if (week != NULL) {
    if (!any(sources %in% possible_week_sources)) {
      warning("At least one of the provided 'source(s)' is/are invalid.")
    }
  } else {
    if (!any(sources %in% possible_season_sources)) {
      warning("At least one of the provided 'source(s)' is/are invalid.")
    }
  }
  
  if (!any(positions %in% possible_position_sources)) {
    warning("At least one of the provided 'position(s)' is/are invalid.")
  }
  
  if (year(season) > year(now())) {
    warning("The provided 'season' is invalid.")
  }
  
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
  if (!is.list(scrape_data)) {
    warning("The provided 'scrape_data' is invalid.")
  }
  
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
