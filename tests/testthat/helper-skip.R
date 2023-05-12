#' Skip tests when no API key is available
#'
#' Intended to be used with all tests that access the EIA API
#'
skip_no_api_key <- function() {
  testthat::skip_if(is.null(suppressWarnings(eia2::eia_get_key())))
}

