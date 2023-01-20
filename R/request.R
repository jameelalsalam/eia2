

#' Retrieve data from the EIA API
#'
#' #TODO: memoisation layer
#' #TODO: tidying of output data
#'
#' @export
eia2 <- function(
    dataset= "",
    facets = list(),
    data_cols = character(),
    frequency = NULL,
    startPeriod = NULL,
    endPeriod = NULL,
    offset = 0,
    length = 5000,
    out = "json",
    api_key = Sys.getenv("EIA_KEY")
) {
  req <- eia2_req(
    dataset = dataset,
    facets = facets,
    data_cols = data_cols,
    frequency = frequency,
    startPeriod = startPeriod,
    endPeriod = endPeriod,
    offset = offset,
    length = length,
    out = out,
    api_key = api_key
  )

  resp <- req_perform(req)

  if (length(data_cols) > 0 | stringr::str_detect(dataset, "/data$")) eia2_resp_data(resp) else resp
}


#' Request data from EIA API version 2
#'
#' @examples
#' eia2_req("electricity")
#' eia2_req("electricity/retail-sales")
#' eia2_req("electricity/retail-sales/data")
#' eia2_req("electricity/retail-sales/data", data_cols = "price")
#' eia2_req("electricity/retail-sales", data_cols = "price") # same as one above
#'
#'
#' @export
eia2_req <- function(
    dataset= "",
    facets = list(),
    data_cols = character(),
    frequency = NULL,
    startPeriod = NULL,
    endPeriod = NULL,
    offset = 0,
    length = 5000,
    out = "json",
    api_key = Sys.getenv("EIA_KEY")
    ) {

  base_url <- "https://api.eia.gov/"

  if (length(data_cols) > 0) {
    data_route <- "data/"
    dataset <- stringr::str_remove(dataset, "/data$")
    params_data <- query_expand_data(list(data = data_cols))
  } else {
    data_route <- ""
    params_data <- list(data = NULL)
  }

  if (length(facets) > 0) {
    params_facets <- query_expand_facets(list(facets = facets))
  } else {
    params_facets <- list(facets = NULL)
  }


  # set to NULL for API defaults
  if (length == 5000) length <- NULL
  if (offset == 0) offset <- NULL
  if (out == "json") out <- NULL

  all_params <- rlang::list2(
    !!! params_facets,
    !!! params_data,
    frequency = frequency,
    startPeriod = startPeriod,
    endPeriod = endPeriod,
    offset = offset,
    length = length,
    out = out,
    api_key = api_key
  ) |>
    purrr::keep(~!is.null(.x)) # not needed?

  req <- request(base_url) |>
    req_url_path_append("v2") |>
    req_url_path_append(dataset) |>
    req_url_path_append(data_route) |>
    req_url_query(!!! all_params) |>
    #req_url_query(api_key = api_key) |>
    req_user_agent("eia2 (http://github.com/jameelalsalam/eia2)")

  req
}


