# response.R

#' @export
eia2_resp_data <- function(eia_resp) {

  json_body_string <- eia_resp |>
    resp_body_string()

  data <- jsonlite::fromJSON(json_body_string) |>
    purrr::pluck("response", "data") |>
    tibble::as_tibble()

  data
}

#' @export
eia2_resp_meta_routes <- function(eia_resp) {

  json_body_string <- eia_resp |>
    resp_body_string()

  routes <- jsonlite::fromJSON(json_body_string) |>
    purrr::pluck("response", "routes") |>
    tibble::as_tibble()

  routes
}


eia2_resp_body <- function(eia_resp) {
  out <- eia_resp |>
    httr2::resp_body_json()

  out$response
}

eia2_resp_total <- function(eia_resp) {

  json_body_string <- eia_resp |>
    resp_body_string()

  total <- jsonlite::fromJSON(json_body_string) |>
    purrr::pluck("response", "total")

  total
}




