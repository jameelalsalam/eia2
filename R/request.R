

#' Retrieve data from the EIA API
#'
#' @export
eia2 <- function(
    dataset= "",
    route = "",
    params = list(),
    get_data = FALSE,
    offset = 0,
    length = 5000,
    out = "json",
    api_key = Sys.getenv("EIA_KEY")
) {
  req <- eia2_req(
    dataset = dataset,
    route = route,
    params = params,
    get_data = get_data,
    length = length,
    out = out,
    api_key = api_key
  )

  resp <- req_perform(req)
  resp
}


#' Request data from EIA API version 2
#'
#' @export
eia2_req <- function(
    dataset= "",
    route = "",
    params = list(),
    get_data = FALSE,
    offset = 0,
    length = 5000,
    out = "json",
    api_key = Sys.getenv("EIA_KEY")
    ) {

  base_url <- "https://api.eia.gov/"
  data_route <- if(get_data) "data/" else ""

  # set to NULL for API defaults
  if (length == 5000) length <- NULL
  if (offset == 0) offset <- NULL
  if (out == "json") out <- NULL

  all_params <- rlang::list2(
    !!! params,
    offset = offset,
    length = length,
    api_key = api_key
  ) |>
    purrr::keep(~!is.null(.x))

  req <- request(base_url) |>
    req_url_path_append("v2") |>
    req_url_path_append(dataset) |>
    req_url_path_append(route) |>
    req_url_path_append(data_route) |>
    req_url_query(!!! all_params) |>
    #req_url_query(api_key = api_key) |>
    req_user_agent("eia2 (http://github.com/jameelalsalam/eia2)")

  req
}

eia2_resp_data <- function(eia_resp) {

}

