
# query_expand_params.R


#' Expand/flatten nested objects to be used as url query parameters
#'
#' @param params named list or character/numeric vector.
#' @param auto_unbox logical, whether to unbox lists.
#'
#' @return A flat list of name-value pairs, whose values are length-1 atomic.
#'
#' @noRd
query_expand_params <- function(params, auto_unbox = FALSE) {

  # should return a flat list of name-value pairs
  # therefore, first level must be named
  # jsonlite translates a top-level character vector into an unnamed array
  # but because character/numeric vectors are a natural way to express query
  # parameters, these structures are automatically translated to lists

  stopifnot(rlang::is_named(params)) #maybe is_named2?
  if (is.character(params)) params <- as.list(params)

  params_nested_list <- query_expand_recurse(params, auto_unbox = auto_unbox)

  # very outer names are not enclosed
  res <- list_flatten(params_nested_list, name_spec = "{outer}{inner}")
  res
}


param_node_type <- function(x, auto_unbox = FALSE) {

  if (is.null(x)) {
    "null"
  } else if ("scalar" %in% class(x)) {
    "scalar"
  } else if (auto_unbox && rlang::is_atomic(x) && length(x) == 1) {
    "unbox scalar"
  } else if (auto_unbox && rlang::is_named(x) && rlang::is_atomic(x) && length(x) == 1) {
    "unbox param"
  } else if (rlang::is_named(x) && rlang::is_atomic(x)) {
    "flat params vector"
  # } else if (rlang::is_named(x) && rlang::is_list(x) &&
  #            auto_unbox && every()
  #   rlang::is_atomic(x) ||
  #   (auto_unbox && every(x, ~length(.x) %in% c(0, 1))))) {

  } else if (is.data.frame(x)) {
    "df"
  } else if (rlang::is_named(x) && rlang::is_atomic(x)) {
    "unordered atomic"
  } else if (rlang::is_named(x) && rlang::is_list(x)) {
    "unordered list"
  } else if (!rlang::is_named(x) && rlang::is_atomic(x)) {
    "ordered atomic array"
  } else if (!rlang::is_named(x) && rlang::is_list(x)) {
    "ordered list"
  } else {
    typeof(x)
  }
}

switch_param_node <- function(x, auto_unbox, ...) {
  switch(param_node_type(x, auto_unbox = auto_unbox),
         ...,
         stop("Don't know how to handle type ", typeof(x), call. = FALSE)
  )
}

wrap_inner_names_in_brackets <- function(x) {
  map(x, function(elem) {
    if (is.null(elem)) elem else set_names(elem, paste0("[", names(elem), "]"))
  })
}

# must return flat-list or list-of-flat-lists
query_expand_recurse <- function(x, auto_unbox = FALSE) {

  this_param_node_type <- param_node_type(x, auto_unbox = auto_unbox)

  recurse_result <- switch_param_node(
    x,
    auto_unbox = auto_unbox,
    # Base cases
    "null" = x,
    "scalar" = x,
    "unbox scalar" = unbox(x),
    "unbox param" = unbox(x),
    "flat params vector" = set_names(map(x, ~unbox(.x)), names(x)),
    "unordered atomic" = set_names(as.list(x), paste0(names(x), "[]")),
    "ordered atomic array" = set_names(x, as.character(seq_along(x)-1)) |> as.list(),

    # Recursive cases
    "df" = {
      query_expand_recurse(list_transpose(as.list(x)), auto_unbox = auto_unbox) |>
        wrap_inner_names_in_brackets()
    },
    "unordered list" = {
      map(x, ~query_expand_recurse(.x, auto_unbox = auto_unbox)) |>
        wrap_inner_names_in_brackets()
      },
    "ordered list" = {
      map(x, ~query_expand_recurse(.x, auto_unbox = auto_unbox)) |>
        set_names(as.character(seq_along(x)-1))
    }
  )

  # flatten when its too deep
  if(this_param_node_type == "unordered list" && pluck_depth(recurse_result) > 3) {
    recurse_result <- map(recurse_result, ~list_flatten(.x, name_spec = "{outer}{inner}"))
  }

  recurse_result
}

