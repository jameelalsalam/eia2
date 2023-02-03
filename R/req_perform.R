
eia2_req_perform <- function(
    req, path = NULL, verbosity = NULL, mock = getOption("httr2_mock", NULL),
    rate = getOption("eia2_rate", 4),
    api_key = Sys.getenv("EIA_KEY")) {

  req |>
    req_url_query(api_key = api_key) |>
    req_throttle(rate = rate) |>
    httr2::req_perform()
}
