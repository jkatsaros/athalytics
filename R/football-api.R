if (!require(plumber))
  install.packages("plumber", repos = "http://cran.us.r-project.org")

library(plumber)

source("ff-analytics.R")

pr() %>%
  pr_get(
    path = "/",
    responses = list("200" = list(description = "Health check."))
  ) %>%
  pr_get(
    path = "/sources/seasons",
    handler = function() { possible_season_sources },
    responses = list("200" = list(description = "Returns possible sources for entire season analytics."))
  ) %>%
  pr_get(
    path = "/sources/weeks",
    handler = function() { possible_week_sources },
    responses = list("200" = list(description = "Returns possible sources for single week analytics."))
  ) %>%
  pr_get(
    path = "/sources/positions",
    handler = function() { possible_position_sources },
    responses = list("200" = list(description = "Returns possible sources for position analytics."))
  ) %>%
  pr_get(
    path = "/seasons/<season:int>",
    params = list(
      "sources" = list(type = "string", required = FALSE, isArray = TRUE),
      "positions" = list(type = "string", required = FALSE, isArray = TRUE)
    ),
    handler = function(season, sources, positions) {
      scrape_ffanalytics(sources, positions, season)
    },
    responses = list("200" = list(description = "Returns raw data for single season and optionally specified positions using optionally specified sources."))
  ) %>%
  pr_get(
    path = "/seasons/<season:int>/players/<player:str>",
    params = list(
      "sources" = list(type = "string", required = FALSE, isArray = TRUE)
    ),
    handler = function(season, player, sources) {
      scrape_ffanalytics(sources, season)
    },
    responses = list("200" = list(description = "Returns raw data for specified player across single season using optionally specified sources."))
  ) %>%
  pr_get(
    path = "/seasons/<season:int>/weeks/<week:int>",
    params = list(
      "sources" = list(type = "string", required = FALSE, isArray = TRUE),
      "positions" = list(type = "string", required = FALSE, isArray = TRUE)
    ),
    handler = function(season, week, sources, positions) {
      scrape_ffanalytics(sources, positions, season, week)
    },
    responses = list("200" = list(description = "Returns raw data for single week within a single season and optionally specified positions using optionally specified sources."))
  ) %>%
  pr_get(
    path = "/seasons/<season:int>/weeks/<week:int>/players/<player:str>",
    params = list(
      "sources" = list(type = "string", required = FALSE, isArray = TRUE)
    ),
    handler = function(season, week, player, sources) {
      scrape_ffanalytics(sources, positions, season, week)
    },
    responses = list("200" = list(description = "Returns raw data for specified player in single week within a single season using optionally specified sources."))
  ) %>%
  pr_get(
    path = "/seasons/<season:int>/projections",
    params = list(
      "sources" = list(type = "string", required = FALSE, isArray = TRUE),
      "positions" = list(type = "string", required = FALSE, isArray = TRUE),
      "include_ecr" = list(type = "boolean", required = FALSE, isArray = FALSE),
      "include_adp" = list(type = "boolean", required = FALSE, isArray = FALSE),
      "include_aav" = list(type = "boolean", required = FALSE, isArray = FALSE),
      "include_uncertainty" = list(type = "boolean", required = FALSE, isArray = FALSE)
    ),
    handler = function(season, sources, positions) {
      scrape_data <- scrape_ffanalytics(sources, positions, season)
      projections_ffanaytics(scrape_data, include_ecr, include_adp, include_aav, include_uncertainty)
    },
    responses = list("200" = list(description = "Returns projections for single season and optionally specified positions using optionally specified sources."))
  ) %>%
  pr_get(
    path = "/seasons/<season:int>/players/<player:str>/projections",
    params = list(
      "sources" = list(type = "string", required = FALSE, isArray = TRUE),
      "include_ecr" = list(type = "boolean", required = FALSE, isArray = FALSE),
      "include_adp" = list(type = "boolean", required = FALSE, isArray = FALSE),
      "include_aav" = list(type = "boolean", required = FALSE, isArray = FALSE),
      "include_uncertainty" = list(type = "boolean", required = FALSE, isArray = FALSE)
    ),
    handler = function(season, player, sources) {
      scrape_data <- scrape_ffanalytics(sources, season)
      projections_ffanaytics(scrape_data, include_ecr, include_adp, include_aav, include_uncertainty)
    },
    responses = list("200" = list(description = "Returns projections for specified player across single season using optionally specified sources."))
  ) %>%
  pr_get(
    path = "/seasons/<season:int>/weeks/<week:int>/projections",
    params = list(
      "sources" = list(type = "string", required = FALSE, isArray = TRUE),
      "positions" = list(type = "string", required = FALSE, isArray = TRUE),
      "include_ecr" = list(type = "boolean", required = FALSE, isArray = FALSE),
      "include_adp" = list(type = "boolean", required = FALSE, isArray = FALSE),
      "include_aav" = list(type = "boolean", required = FALSE, isArray = FALSE),
      "include_uncertainty" = list(type = "boolean", required = FALSE, isArray = FALSE)
    ),
    handler = function(season, week, sources, positions) {
      scrape_data <- scrape_ffanalytics(sources, positions, season, week)
      projections_ffanaytics(scrape_data, include_ecr, include_adp, include_aav, include_uncertainty)
    },
    responses = list("200" = list(description = "Returns projections for single week within a single season and optionally specified positions using optionally specified sources."))
  ) %>%
  pr_get(
    path = "/seasons/<season:int>/weeks/<week:int>/players/<player:str>/projections",
    params = list(
      "sources" = list(type = "string", required = FALSE, isArray = TRUE),
      "include_ecr" = list(type = "boolean", required = FALSE, isArray = FALSE),
      "include_adp" = list(type = "boolean", required = FALSE, isArray = FALSE),
      "include_aav" = list(type = "boolean", required = FALSE, isArray = FALSE),
      "include_uncertainty" = list(type = "boolean", required = FALSE, isArray = FALSE)
    ),
    handler = function(season, week, player, sources) {
      scrape_data <- scrape_ffanalytics(sources, positions, season, week)
      projections_ffanaytics(scrape_data, include_ecr, include_adp, include_aav, include_uncertainty)
    },
    responses = list("200" = list(description = "Returns projections for specified player in single week within a single season using optionally specified sources."))
    )