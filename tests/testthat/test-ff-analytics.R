if (!require(testthat))
  install.packages("testthat", repos = "http://cran.us.r-project.org")
if (!require(glue))
  install.packages("glue", repos = "http://cran.us.r-project.org")
if (!require(lubridate))
  install.packages("lubridate", repos = "http://cran.us.r-project.org")

library(testthat)
library(glue)
library(lubridate)

source("../../R/ff-analytics.R")

test_that("'scrape_ffanalytics' produces an error when the 'season' parameter is not a number", {
  expect_error(
    scrape_ffanalytics(
      NULL,
      NULL,
      "NIL",
      NULL
    ),
    "The following 'season' is invalid: NIL."
  )
})

test_that("'scrape_ffanalytics' produces an error when the 'season' parameter is not a valid year", {
  expect_error(
    scrape_ffanalytics(
      NULL,
      NULL,
      -1,
      NULL
    ),
    "The following 'season' is invalid: -1."
  )
})

test_that("'scrape_ffanalytics' produces an error when the 'season' parameter exceeds the current year", {
  expect_error(
    scrape_ffanalytics(
      NULL,
      NULL,
      .Machine$integer.max,
      NULL
    ),
    "The following 'season' is invalid: "
  )
})

test_that("'scrape_ffanalytics' produces an error when the 'week' parameter is not a number", {
  expect_error(
    scrape_ffanalytics(
      NULL,
      NULL,
      "NIL",
      NULL
    ),
    "The following 'week' is invalid: NIL."
  )
})

test_that("'scrape_ffanalytics' produces an error when the 'week' parameter is not a positive number", {
  expect_error(
    scrape_ffanalytics(
      NULL,
      NULL,
      -1,
      NULL
    ),
    "The following 'week' is invalid: -1."
  )
})

test_that("'scrape_ffanalytics' produces an error when the 'week' parameter exceeds the number of weeks in a year", {
  expect_error(
    scrape_ffanalytics(
      NULL,
      NULL,
      .Machine$integer.max,
      NULL
    ),
    "The following 'week' is invalid: "
  )
})

test_that("'scrape_ffanalytics' produces an error when the 'week' parameter is not null and 'sources' parameter contains a value that is not in 'possible_week_sources' vector", {
  expect_error(
    scrape_ffanalytics(
      c("NIL"),
      NULL,
      NULL,
      1
    ),
    "The following 'sources' is not a valid source: NIL"
  )
})

test_that("'scrape_ffanalytics' produces an error when the 'week' parameter is not null and 'sources' parameter contains values that are not in 'possible_week_sources' vector", {
  expect_error(
    scrape_ffanalytics(
      c("NIL1", "NIL2", "NIL3"),
      NULL,
      NULL,
      1
    ),
    "The following 'sources' are not valid sources: NIL1, NIL2, NIL3."
  )
})

test_that("'scrape_ffanalytics' produces an error when the 'season' parameter is not null and 'sources' parameter contains a value that is not in 'possible_season_sources' vector", {
  expect_error(
    scrape_ffanalytics(
      c("NIL"),
      NULL,
      year(now()),
      NULL
    ),
    "The following 'sources' is not a valid source: NIL"
  )
})

test_that("'scrape_ffanalytics' produces an error when the 'season' parameter is not null and 'sources' parameter contains values that are not in 'possible_season_sources' vector", {
  expect_error(
    scrape_ffanalytics(
      c("NIL1", "NIL2", "NIL3"),
      NULL,
      year(now()),
      NULL
    ),
    "The following 'sources' are not valid sources: NIL1, NIL2, NIL3."
  )
})

test_that("'scrape_ffanalytics' produces an error when the 'positions' parameter is not null and contains a value that is not in 'possible_position_sources' vector", {
  expect_error(
    scrape_ffanalytics(
      NULL,
      c("NIL"),
      NULL,
      NULL
    ),
    "The following 'positions' is not a valid source: NIL"
  )
})

test_that("'scrape_ffanalytics' produces an error when the 'positions' parameter is not null and contains values that are not in 'possible_position_sources' vector", {
  expect_error(
    scrape_ffanalytics(
      NULL,
      c("NIL1", "NIL2", "NIL3"),
      NULL,
      NULL
    ),
    "The following 'positions' are not valid sources: NIL1, NIL2, NIL3."
  )
})

test_that("'scrape_ffanalytics' defaults to 'possible_week_sources' when the 'sources' parameter is null and the 'week' parameter is not null", {
  expect_message(
    scrape_ffanalytics(
      NULL,
      NULL,
      NULL,
      1
    ),
    glue::glue("Defaulted to the following 'sources': {possible_week_sources}.")
  )
})

test_that("'scrape_ffanalytics' defaults to 'possible_season_sources' when the 'sources' parameter is null and the 'season' parameter is not null", {
  expect_message(
    scrape_ffanalytics(
      NULL,
      NULL,
      year(now()),
      NULL
    ),
    glue::glue("Defaulted to the following 'sources': {possible_week_sources}.")
  )
})

test_that("'scrape_ffanalytics' defaults to 'possible_position_sources' when the 'positions' parameter is null", {
  expect_message(
    scrape_ffanalytics(
      NULL,
      NULL,
      NULL,
      NULL
    ),
    glue::glue("Defaulted to the following 'positions': {possible_position_sources}.")
  )
})