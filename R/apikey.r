#' Function to set api key
#'
#' @param apikey Character api key
#'
#' @return nothing
#' @export
#'
#' @examples
#' \dontrun{
#'   SetEIAPIKey()
#' }
SetEIAPIKey <- function(apikey = NA){
  # 1. check input ----
  if (is.na(apikey)){
    try(apikey <- getOption(".EIA_KEY") )
    if(is.null(apikey)){warning(paste("Please supply EIA API Key"))}
  }

  options(.EIA_KEY = apikey)
  if(!is.null(getOption(".EIA_KEY"))){
    message("EIA api key has been set")
  }
}


#' Retrieve a previously stored key for EIA api
#'
#' @return character api key from EIA
#' @export
#'
#' @examples
#' \dontrun{
#'   GetEIAAPIKey()
#' }
GetEIAAPIKey <- function(){
  key <- getOption(".EIA_KEY")
  if(is.null(key)){
    warning("please set api key using function SetEIAPIKey")
  }
  return(key)
}
