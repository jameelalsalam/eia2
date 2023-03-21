

#' Request Data Using Legacy APIv1 Series ID
#'
#' @return data
#' @export
eia1_series <- function(series_id) {

  # TODO: add offset and length to eia1_series
  # TODO: check if this endpoint respects sort order
  # 2023-03-20: endpoint appears NOT to respect `start` and `end` parameters

  req <- eia1_series_req(series_id)

  resp <- eia2_req_perform(req)

  eia2_resp_data(resp)
}

#' Request Data Using Legacy APIv1 Series ID
#'
#' @return request object
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
