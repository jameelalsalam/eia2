
# query_expand_2.R






if (FALSE) {
  name_vec <- c("frequency" = "annual", "offset" = 0)
  name_list <- list(frequency = "annual", offset = 0)
  unname_vec <- c("annual", "offset")
  unname_list <- list("ref", "ref2021")
  na_vec <- c(NA_character_)
  null_list <- c(NULL)
  df <- data.frame(
    column = "period",
    order = "desc"
  )

  param_node_type(name_vec)
  param_node_type(name_list)
  param_node_type(unname_vec)
  param_node_type(unname_list)
  param_node_type(na_vec)
  param_node_type(null_list)
  param_node_type(df)

  x <- list(msn = c("first", "second"))
  param_node_type(x)
  pluck_depth(x)
  query_expand_recurse(x, auto_unbox = FALSE)
  query_expand_recurse(x, auto_unbox = TRUE)
  query_expand_params(x)

  x2 <- list(
    facets = list(
      msn = c("first", "second"),
      sectors = c("oil", "gas")
    )
  )
  param_node_type(x2)
  pluck_depth(x2)





  list_flatten(res, name_spec = '{outer}{inner}')
}

#' Expand/Flatted Nested Objects to be Used as url query parameters
#'
#' @param params named list or character/numeric vector
#'
#' @return a flat list of name-value pairs, whose values are length-1 atomic
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

if (FALSE) {library(jsonlite); library(purrr)}

param_node_type <- function(x, auto_unbox = FALSE) {

  if ("scalar" %in% class(x)) {
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

# must return flat-list or list-of-flat-lists
query_expand_recurse <- function(x, auto_unbox = FALSE) {

  this_param_node_type <- param_node_type(x, auto_unbox = auto_unbox)

  recurse_result <- switch_param_node(
    x,
    auto_unbox = auto_unbox,
    # Base cases
    "scalar" = x,
    "unbox scalar" = unbox(x),
    "unbox param" = unbox(x),
    "flat params vector" = set_names(map(x, ~unbox(.x)), names(x)),
    "unordered atomic" = set_names(as.list(x), paste0(names(x), "[]")),
    "ordered atomic array" = set_names(x, as.character(seq_along(x)-1)) |> as.list(),

    # Recursive cases
    "df" = {
      res <- query_expand_recurse(list_transpose(as.list(x)), auto_unbox = auto_unbox) |>
        map(~set_names(.x, paste0("[", names(.x), "]"))) # wrap inner names in []
    },
    "unordered list" = {
      map(x, ~query_expand_recurse(.x, auto_unbox = auto_unbox)) |>
        #set_names(names(x)) |>
        map(~set_names(.x, paste0("[", names(.x), "]"))) # wrap inner names in []
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

