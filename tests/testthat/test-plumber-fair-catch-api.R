if (!require(testthat))
  install.packages("testthat", repos = "http://cran.us.r-project.org")
if (!require(callthat))
  install.packages("callthat", repos = "http://cran.us.r-project.org")

library(testthat)
library(callthat)

test_that("health check endpoint returns 200 OK", {
  expect_silent({
    local_api <- call_that_plumber_start(
      system.file("plumber/fair-catch-api", package = "fair-catch")
    )

    api_session <- call_that_session_start(local_api)
  })

  expect_s3_class(
    get_healthcheck <- call_that_api_get(
      api_session, 
      endpoint = "/"
    ),
    "response"
  )

  expect_equal(
    get_healthcheck$status_code,
    200
  )

  expect_null(
    call_that_session_stop(api_session)
  )
})