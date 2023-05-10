

#' Request Data Using Legacy APIv1 Series ID Compatibility Endpoint
#'
#' @param series_id The EIA APIv1 series ID (length 1 character).
#'
#' @return tibble with series data, or for eia1_series_req a request object
#'
#' @examples
#' \dontrun{
#' eia1_series("ELEC.SALES.CO-RES.A")
#' }
#'
#' @export
eia1_series <- function(series_id) {

  # TODO: add offset and length to eia1_series
  # TODO: check if this endpoint respects sort order
  # 2023-03-20: endpoint appears NOT to respect `start` and `end` parameters

  req <- eia1_series_req(series_id)

  resp <- eia2_req_perform(req)

  eia2_resp_data(resp)
}

#' @rdname eia1_series
#' @export
eia1_series_req <- function(series_id) {

  check_series_id(series_id)

  req <- eia2_req(sort = NULL) |>
    req_url_path_append("seriesid") |>
    req_url_path_append(series_id)

  req
}



