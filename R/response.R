#' Extract formatted data from responses
#'
#' @description
#' If you use the stepwise workflow of `eia2_request()` -> `eia2_req_perform()`,
#' then the next step is to extract useful data from the responses.
#'
#' For data requests, `eia2_resp_data()` returns body data as a tibble.
#'
#' For metadata requests:
#' * `eia2_resp_meta_routes()` returns metadata on child routes as a tibble.
#' * `eia2_resp_meta_summary()` returns a summary metadata lists.
#'
#' @export
eia2_resp_data <- function(eia_resp) {

  json_body_string <- eia_resp |>
    resp_body_string()

  data <- jsonlite::fromJSON(json_body_string) |>
    purrr::pluck("response", "data") |>
    tibble::as_tibble()

  data
}

#' @describeIn eia2_resp_data
#' @export
eia2_resp_meta_routes <- function(eia_resp) {

  json_body_string <- eia_resp |>
    resp_body_string()

  routes <- jsonlite::fromJSON(json_body_string) |>
    purrr::pluck("response", "routes") |>
    tibble::as_tibble()

  routes
}

#' @noRd
eia2_resp_body <- function(eia_resp) {
  out <- eia_resp |>
    httr2::resp_body_json()

  out$response
}

#' @describeIn eia2_resp_data
#' @export
eia2_resp_meta_summary <- function(eia_resp) {

  resp_body_json <- eia_resp |>
    httr2::resp_body_string() |>
    jsonlite::fromJSON()

  resp_ll <- purrr::pluck(resp_body_json, "response")

  resp_meta_summary <- resp_ll |>
    purrr::modify_in("routes", ~purrr::pluck(.x, "id")) |>
    purrr::modify_in("frequency", ~purrr::pluck(.x, "id")) |>
    purrr::modify_in("facets", ~purrr::pluck(.x, "id")) |>
    purrr::modify_in("data", names) |>
    purrr::discard(~isTRUE(.x == "")) |>
    purrr::discard(is.null)

  resp_meta_summary
}

#' @noRd
eia2_resp_total <- function(eia_resp) {

  json_body_string <- eia_resp |>
    resp_body_string()

  total <- jsonlite::fromJSON(json_body_string) |>
    purrr::pluck("response", "total")

  total
}




