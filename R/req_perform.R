
#' Perform an eia2 request
#'
#' @param req eia2 request object
#' @param path optional path to save request response
#' @param verbosity passed to httr2::request_perform
#' @param mock passed to httr2::request_perform
#' @param rate maximum request rate in requests per second, passed to httr2::request_perform
#' @param api_key your api authentication key
#'
#' The api_key is not added to the request object until the request is performed.
#'
#' @export
eia2_req_perform <- function(
    req, path = NULL, verbosity = NULL, mock = getOption("httr2_mock", NULL),
    rate = getOption("eia2_rate", 4),
    api_key = eia_get_key()) {

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

eia2_error_msg <- function(eia_resp) {
  body <- httr2::resp_body_json(eia_resp)

  e_msg <- c(
    "x" = body$error
  )

  e_msg
}
