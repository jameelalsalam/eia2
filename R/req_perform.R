
#' Perform an eia2 request
#'
#' @description
#' After preparing a [request], call `eia2_req_perform()` to perform it, fetching
#' the results back to R as a [response].
#'
#' `eia2_req_perform()` wraps `httr2::req_perform()`. The api_key is not added
#' to the request object until the request is performed. Additionally, it
#' applies rate limit behavior to comply with API guidelines.
#'
#' @param req An eia2 [request].
#' @param path Optionally, path to save body of the response.
#' @param verbosity How much information to print? This is an integer from 0 to 3,
#'  passed to `httr2::request_perform()`.
#' @param mock A mocking function. Passed to `httr2::request_perform()`.
#' @param rate Maximum request rate in requests per second, passed to `httr2::req_throttle()`.
#' @param api_key Your API authentication key.
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


#' Remove the API key from an eia2 response
#'
#' By default, the API key appears both in the url and in the body of the
#' response describing the request.
#'
#' @noRd
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

#' Extract useful error message text from an an error HTTP response
#'
#' Used in constructing eia2 requests.
#'
#' @noRd
eia2_error_msg <- function(eia_resp) {
  body <- httr2::resp_body_json(eia_resp)

  e_msg <- c(
    "x" = body$error
  )

  e_msg
}
