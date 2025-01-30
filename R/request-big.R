

#' Retrieve data from the EIA API in Multiple Requests
#'
#' @param route to base dataset
#' @param facets list of facet filter specifications
#' @param data_cols names of data columns to retrieve
#' @param frequency data frequency
#' @param start filter start of data requested
#' @param end filter end of data requested
#' @param sort data frame specifying sorting
#' @param offset starting position, for paged results
#' @param length number of data points to retrieve
#' @param by number of data points in each page
#' @param out output data format, "json" or "xml"
#' @param api_key character api key
#'
#' @seealso [request], [eia2_req_perform()], and [eia2_resp_data()] provide
#' a stepwise workflow to build a request, perform it, and extract formatted data.
#'
#' @examples
#' \dontrun{
#' eia2("electricity/retail-sales", data_cols = "price", length = 10)
#' }
#'
#' @export
eia2_data_big <- function(
    route= "",
    facets = list(),
    data_cols = character(),
    frequency = NULL,
    start = NULL,
    end = NULL,
    sort = data.frame(
      column = "period",
      direction = "desc"
    ),
    offset = 0,
    length = NULL,
    by = 5000,
    out = "json",
    api_key = eia_get_key()
) {

  stopifnot(is.null(length) | length >= 0)
  stopifnot(by <= 5000)
  stopifnot(by > 0)
  stopifnot(offset >= 0)

  init_length <- min(length, by)

  req <- eia2_req(
    route = route,
    facets = facets,
    data_cols = data_cols,
    frequency = frequency,
    start = start,
    end = end,
    sort = sort,
    offset = offset,
    length = init_length,
    out = out,
    api_key = NULL
  )

  resp_big_1 <- eia2_req_perform(req, api_key = api_key)

  # check size
  total_n <- eia2_resp_total(resp_big_1)
  up_to_pos <- min(total_n, offset + length)

  if(FALSE) {
    # for testing
    offset <- 0
    length <- 12000
    total_n <- 11100
  }

  # store extracted data in a list
  resp_big_data <- list()
  resp_big_data[[1]] <- eia2_resp_data(resp_big_1)
  init_pos <- offset + init_length

  if (up_to_pos > init_pos) {
    offsets <- seq(from = init_pos, to = up_to_pos, by = by)
    lengths <- pmin(up_to_pos - offsets, by)

    for (i in seq_along(offsets)) {
      if (lengths[[i]] > 0) {
        resp_big_data[[i+1]] <- {
          eia2_req(
            route = route,
            facets = facets,
            data_cols = data_cols,
            frequency = frequency,
            start = start,
            end = end,
            sort = sort,
            offset = offsets[[i]],
            length = lengths[[i]],
            out = out,
            api_key = NULL
          ) |>
            eia2_req_perform() |>
            eia2_resp_data()
      }}
    }
  }

  all_data <- dplyr::bind_rows(!!!resp_big_data)
  all_data
}
