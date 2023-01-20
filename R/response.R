# response.R

eia2_resp_data <- function(eia_resp) {

  json_body_string <- eia_resp |>
    resp_body_string()

  data <- jsonlite::fromJSON(json_body_string) |>
    purrr::pluck("response", "data")

  data
}


eia2_resp_meta_routes <- function(eia_resp) {

  json_body_string <- eia_resp |>
    resp_body_string()

  routes <- jsonlite::fromJSON(json_body_string) |>
    purrr::pluck("response", "routes")

  routes
}


eia2_resp_total <- function(eia_resp) {

  json_body_string <- eia_resp |>
    resp_body_string()

  total <- jsonlite::fromJSON(json_body_string) |>
    purrr::pluck("response", "total")

  total
}




