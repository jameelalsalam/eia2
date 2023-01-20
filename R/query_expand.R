# expand query parameters for data and facets, which can be arrays
# the httr2 version of query_build cannot handle nested/array query params
# but once they are expanded, they work.

if(FALSE) {
  library(httr2)
  library(rlang)
  library(purrr)
  x <- list(
    frequency = list("annual"),
    facets = "scenarioid",
    data = "value"
  )

  x <- list(
    frequency = "annual",
    facets = "scenarioid",
    data = "value"
  )

  x <- list(
    frequency = "annual",
    facets = list(
      scenarioid = "ref"
    ),
    data = c("value", "price")
  )
}

# from httr2:
query_build <- function(x) {
  if (!is_list(x) || (!is_named(x) && length(x) > 0)) {
    abort("Query must be a named list")
  }

  x <- compact(x)
  if (length(x) == 0) {
    return(NULL)
  }

  bad_val <- lengths(x) != 1 | !map_lgl(x, is_atomic)
  if (any(bad_val)) {
    abort(c(
      "Query parameters must be length 1 atomic vectors.",
      paste0("Problems: ", paste0(names(x)[bad_val], collapse =", "))
    ))
  }

  is_double <- map_lgl(x, is.double)
  x[is_double] <- map_chr(x[is_double], format, scientific = FALSE)

  names <- curl::curl_escape(names(x))
  values <- map_chr(x, url_escape)

  paste0(names, "=", values, collapse = "&")
}

#' Expand `data` parameter for EIA APIv2
#'
#' @param x character vector of column names to return
#'
#' @return list of atomic length-1 parameter pairs
#'
#' The data parameter specifies the data value columns to return. It is an
#' array of names. The expansion is done as an ordered array.
#'
#' Right now this numbers them, but it doesn't need to.
#'
#' @examples
#' x <- list(data = c("price", "revenue"))
#' query_expand_data(x)
#'
query_expand_data <- function(x) {

  #component is named, length-1:
  #x <- list(data = c("price", "revenue"))
  stopifnot(length(x) == 1)
  stopifnot(rlang::is_named(x))
  stopifnot(names(x) == "data")

  #elements are an unnamed atomic vector
  stopifnot(is.null(names(x[[1]])))
  stopifnot(rlang::is_atomic(x[[1]]))

  # component name:
  names <- curl::curl_escape(names(x)) # always 'data'
  elems <- x[[1]]
  elem_nums <- seq_along(elems)-1
  out_names <- as.character(glue::glue("{names}[{elem_nums}]"))

  as.list(rlang::set_names(elems, nm = out_names))
}

#' Expand `facets` parameter for EIA APIv2
#'
#' @param x list of atomic vectors with facets specification.
#'
#' @return list of atomic length-1 parameter pairs
#'
#' @examples
#' x <- list(facets = list(stateid = c("CA", "CO"), scenarioid = "ref"))
#' query_expand_facets(x)
#'
query_expand_facets <- function(x) {

  #component is named, length-1:
  #x <- list(facets = list(stateid = c("CA", "CO"), scenarioid = "ref"))
  stopifnot(length(x) == 1)
  stopifnot(rlang::is_named(x))
  stopifnot(names(x) == "facets")

  #elements are a named list, with unnamed atomic vector values
  stopifnot(rlang::is_named(x[[1]]))
  stopifnot(purrr::every(x[[1]], rlang::is_atomic))
  stopifnot(rlang::is_list(x[[1]]))

  # component name:
  names <- curl::curl_escape(names(x))

  x2 <- vctrs::vec_c(!!! x, .name_spec = "{outer}[{inner}]")
  out_names <- paste0(names(x2), "[]")

  as.list(rlang::set_names(x2, out_names))

  # facets[stateid][]=CA&facets[stateid][]=CO&facets[scenarioid]=ref
}
