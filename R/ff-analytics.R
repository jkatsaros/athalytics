if (!require(devtools))
  install.packages("remotes", repos = "http://cran.us.r-project.org")
if (!require(tidyverse))
  install.packages("tidyverse", repos = "http://cran.us.r-project.org")
if (!require(glue))
  install.packages("glue", repos = "http://cran.us.r-project.org")
if (!require(lubridate))
  install.packages("lubridate", repos = "http://cran.us.r-project.org")

library(remotes)
library(tidyverse)
library(glue)
library(lubridate)

devtools::install_github("FantasyFootballAnalytics/ffanalytics")

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
  if (!is.null(season) & (!is.integer(season) | year(season) > year(now()))) {
    stop(glue::glue("The following 'season' is invalid: {season}."))
  }
  
  if (!is.null(week) & (!is.integer(week) | week < 1 | week > 52)) {
    stop(glue::glue("The following 'week' is invalid: {week}."))
  }
  
  if (!is.null(sources)) {
    if (!is.null(week)) {
      if (!any(sources %in% possible_week_sources)) {
        not_in <- setdiff(possible_week_sources, sources)
        if (length(not_in) == 1) {
          stop(glue::glue("The following 'sources' is not a valid source: {not_in}."))
        }
        stop(glue::glue("The following 'sources' are not valid sources: {not_in}."))
      }
    } else {
      if (!any(sources %in% possible_season_sources)) {
        not_in <- setdiff(possible_season_sources, sources)
        if (length(not_in) == 1) {
          stop(glue::glue("The following 'sources' is not a valid source: {not_in}."))
        }
        stop(glue::glue("The following 'sources' are not valid sources: {not_in}."))
      }
    }
  }
  
  if (!is.null(positions)) {
    if (!any(positions %in% possible_position_sources)) {
      not_in <- setdiff(possible_position_sources, positions)
      if (length(not_in) == 1) {
        stop(glue::glue("The following 'positions' is not a valid source: {not_in}."))
      }
      stop(glue::glue("The following 'positions' are not valid sources: {not_in}."))
    }
  }
  
  if (is.null(sources)) {
    if (!is.null(week)) {
      sources <- possible_week_sources
      message(glue::glue("Defaulted to the following 'sources': {possible_week_sources}."))
    } else {
      sources <- possible_season_sources
      message(glue::glue("Defaulted to the following 'sources': {possible_season_sources}."))
    }
  }
  
  if (is.null(positions)) {
    positions <- possible_position_sources
    message(glue::glue("Defaulted to the following 'positions': {possible_position_sources}."))
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
    stop("The provided 'scrape_data' is invalid.")
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
