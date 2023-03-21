

#' Determine Valid Values of a Facet
#'
#' @param dataset route to EIA dataset
#' @param facet id of facet to query for valid values (length 1 character)
#'
#' @return tibble of valid facet values (id & name)
#' @export
#'
eia2_facet <- function(
  dataset,
  facet # "" or character()?
  # ..        # swallow extra for convenience?
  #out = "json",
  #api_key = NULL
) {

  # dataset must be specified

  # facet must be at most length 1, character
  stopifnot(length(facet) == 1)


  req <- eia2_req(
    dataset,
    sort = NULL
  ) |>
    req_url_path_append("facet") |>
    req_url_path_append(facet)

  eia_resp <- req |>
    eia2_req_perform()

  eia2_resp_facet_summary(eia_resp)
}


eia2_resp_facet_summary <- function(eia_resp) {

  json_body_string <- eia_resp |>
    resp_body_string()

  facet_values <- jsonlite::fromJSON(json_body_string) |>
    purrr::pluck("response", "facets") |>
    tibble::as_tibble()

  facet_values
}
