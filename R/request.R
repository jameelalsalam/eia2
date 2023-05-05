

#' Retrieve data from the EIA API
#'
#' @param route to base dataset
#' @param facets list of facet filter specifications
#' @param data_cols names of data columns to retrieve
#' @param frequency data frequency
#' @param start filter start of data requested
#' @param end filter end of data requested
#' @param sort data frame specifying sorting
#' @param offset starting position, for paged results
#' @param length number of data points to retrieve
#' @param out output data format, "json" or "xml"
#' @param api_key character api key
#'
#' @examples
#' \dontrun{
#' eia2_req("electricity/retail-sales", data_cols = "price")
#' }
#'
#' @export
eia2 <- function(
    route= "",
    facets = list(),
    data_cols = character(),
    frequency = NULL,
    start = NULL,
    end = NULL,
    sort = data.frame(
      column = "period",
      direction = "desc"
    ),
    offset = 0,
    length = 5000,
    out = "json",
    api_key = eia_get_key()
) {
  req <- eia2_req(
    route = route,
    facets = facets,
    data_cols = data_cols,
    frequency = frequency,
    start = start,
    end = end,
    sort = sort,
    offset = offset,
    length = length,
    out = out,
    api_key = NULL
  )

  resp <- eia2_req_perform(req, api_key = api_key)

  if (length(data_cols) > 0 | stringr::str_detect(route, "/data$")) {
    # data requests
    eia2_resp_data(resp)
  } else {
    # default summary for metadata requests
    eia2_resp_meta_summary(resp)
  }
}


#' Request data from EIA API version 2
#'
#' @param route to base dataset
#' @param facets list of facet filter specifications
#' @param data_cols names of data columns to retrieve
#' @param frequency data frequency
#' @param start filter start of data requested
#' @param end filter end of data requested
#' @param sort data frame specifying sorting
#' @param offset starting position, for paged results
#' @param length number of data points to retrieve
#' @param out output data format, "json" or "xml"
#' @param api_key character api key, or NULL to omit
#'
#' @examples
#' eia2_req("electricity")
#' eia2_req("electricity/retail-sales")
#' eia2_req("electricity/retail-sales/data")
#' eia2_req("electricity/retail-sales/data", data_cols = "price")
#' eia2_req("electricity/retail-sales", data_cols = "price") # same as one above
#'
#' @export
eia2_req <- function(
    route= "",
    facets = list(),
    data_cols = character(),
    frequency = NULL,
    start = NULL,
    end = NULL,
    sort = data.frame(
      column = "period",
      direction = "desc"
    ),
    offset = 0,
    length = 5000,
    out = "json",
    api_key = NULL
    ) {

  base_url <- "https://api.eia.gov/"

  if (length(data_cols) > 0) {
    if (!stringr::str_detect(route, "/data$")) route <- paste0(route, "/data")
    params_data <- query_expand_data(list(data = data_cols))
  } else {
    params_data <- list(data = NULL)
  }

  # expand complex parameters
  check_facets_param(facets)
  if (length(facets) > 0) {
    params_facets <- query_expand_facets(list(facets = facets))
  } else {
    params_facets <- list(facets = NULL)
  }

  check_sort_param(sort)
  if (length(sort) > 0) {
    params_sort <- query_expand_sort(list(sort = sort))
  } else {
    params_sort <- list(sort = NULL)
  }

  # set to NULL for API defaults
  if (length == 5000) length <- NULL
  if (offset == 0) offset <- NULL
  if (out == "json") out <- NULL

  all_params <- rlang::list2(
    !!! params_facets,
    !!! params_data,
    frequency = frequency,
    start = start,
    end = end,
    !!! params_sort,
    offset = offset,
    length = length,
    out = out,
    api_key = api_key
  ) |>
    purrr::keep(~!is.null(.x)) # not needed?

  req <- request(base_url) |>
    req_url_path_append("v2") |>
    req_url_path_append(route) |>
    req_url_query(!!! all_params) |>
    #req_url_query(api_key = api_key) |>
    req_user_agent("eia2 (http://github.com/jameelalsalam/eia2)") |>
    req_error(body = eia2_error_msg)

  req
}


