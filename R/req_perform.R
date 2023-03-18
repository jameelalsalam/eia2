
#' @export
eia2_req_perform <- function(
    req, path = NULL, verbosity = NULL, mock = getOption("httr2_mock", NULL),
    rate = getOption("eia2_rate", 4),
    api_key = Sys.getenv("EIA_KEY")) {

  resp <- req |>
    req_url_query(api_key = api_key) |>
    req_throttle(rate = rate) |>
    httr2::req_perform()

  #TODO: eia2_resp_sanitize(resp)
  resp
}

# request with API key removed from url and request object in body
eia2_resp_sanitize <- function(resp) {

  out <- resp

  out$url <- stringr::str_remove(out$url, "&api_key=[a-f0-9]+$")

  if (FALSE) {
    # TODO: also remove api key from request object in response body
    body <- resp |> resp_body_string()

    body2 <- resp |> resp_body_string() |> jsonlite::fromJSON(body) |> jsonlite::toJSON()



    req_back <- resp |> resp_body_json(simplifyVector = TRUE) |> pluck("request")

    str(resp$url)
    resp |> resp_headers()

    str(resp)
  }

  out
}
