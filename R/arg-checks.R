
check_series_id <- function(x, arg_name = "series_id", call = rlang::caller_env()) {

  if (length(x) != 1 || !is.character(x)) {
    cli::cli_abort(
      c(
        "{.arg {arg_name}} must be a length-1 character.",
        "x" = "You've supplied {x}"
      ),
      call = call)
  }
  x
}


check_sort_param <- function(x, arg_name = "sort", call = rlang::caller_env()) {

  if (is.null(x)) return(x)

  if (!inherits(x, "data.frame")) {
    cli::cli_abort(
      c(
        "{.arg {arg_name}} must be a data frame with `column` and `direction`.",
        "x" = "You've supplied object type: {class(x)}"
      ),
      call = call)
  }

  if (!identical(names(x), c("column", "direction"))) {
    cli::cli_abort(
      c(
        "{.arg {arg_name}} must be a data frame with `column` and `direction`.",
        "x" = "You've supplied columns: {names(x)}"
      ),
      call = call)
  }

  if (!all(x$direction %in% c("asc", "desc"))) {
    cli::cli_abort(
      c(
        "Valid values for `direction` in {.arg {arg_name}} are 'asc' and 'desc'.",
        "x" = "You've supplied directions: {unique(x$direction)}"
      ),
      call = call)
  }
  x
}

check_facets_param <- function(x, arg_name = "facets", call = rlang::caller_env()) {

  if (is.null(x)) return(x)
  if (identical(x, list())) return(x)

  if (!inherits(x, "list") || !rlang::is_named(x)) {
    cli::cli_abort(
      c(
        "{.arg {arg_name}} must be a named list of facets.",
        "x" = "You've supplied: {x}"
      ),
      call = call)
  }
  x
}

