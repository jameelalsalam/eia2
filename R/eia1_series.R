

#' Request Data Using Legacy APIv1 Series ID Compatibility Endpoint
#'
#' @param series_id EIA APIv1 series ID (length 1 character)
#'
#' @return tibble with series data, or for eia1_series_req a request object
#' @export
eia1_series <- function(series_id) {

  # TODO: add offset and length to eia1_series
  # TODO: check if this endpoint respects sort order
  # 2023-03-20: endpoint appears NOT to respect `start` and `end` parameters

  stopifnot(length(series_id) == 1)

  req <- eia1_series_req(series_id)

  resp <- eia2_req_perform(req)

  eia2_resp_data(resp)
}

#' @rdname eia1_series
#' @export
eia1_series_req <- function(series_id) {

  base_url <- "https://api.eia.gov/v2/seriesid"

  req <- request(base_url) |>
    req_url_path_append(series_id)

  req
}


if(FALSE) {
  # examples:
  series_id <- "ELEC.SALES.CO-RES.A"
  resp <- eia2_req_perform(req)

  eia2_resp_data(resp)
  eia2_resp_total(resp)

  eia1_series("ELEC.SALES.CO-RES.A")

}
