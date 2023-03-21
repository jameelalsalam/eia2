
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

