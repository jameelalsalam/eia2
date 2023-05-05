
#' Convert API version 1 series IDs to version 2 request specifications
#'
#' @param series_id character vector of series IDs
#'
#' Work In Progress -- doesn't work yet.
#'
#' @return list of v2 request specifications (same format as returned by API)
#'
#' @examples
#' \dontrun{
#' series_id <- c("TOTAL.TECCEUS.A", "TOTAL.TERCEUS.A")
#' req_specs_v2 <- eia1_translate(series_id)
#' }
#'
eia1_translate <- function(series_id) {

  seriesid_routes <- paste("seriesid", series_id, sep = "/")

  # limit to 4 / second (but b/c of response time, in practice slower)
  list_reqs <- purrr::map(seriesid_routes, ~eia2_req(.x) |> req_throttle(rate = 4))

  list_resps <- list()
  for (i in seq_along(list_reqs)) {
    print(list_reqs[[i]]$url)
    list_resps[[i]] <- req_perform(list_reqs[[i]])
  }

  list_request_spec <- purrr::map(list_resps, function(resp) {
    body_list <- resp |> resp_body_string() |> jsonlite::fromJSON()
    body_list$request
  })

  list_request_spec
}




