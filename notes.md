
# Notes on eia2 development

- roundtrip request -> perform -> extract request from response
- test suite (including tests that run on CRAN)
  - test of low-level query_params_expand
  - test that url's are constructed as expected
  - tests for API assumptions (that do not run on CRAN)
  - tests along the lines of DB test suite
  - ensure API credentials don't leak
- CI / Github Actions
- caching of API requests
- README
- Getting started vignette
- Further split low-level function (that is flexible, close to API vocab, and won't break) from high-level UI functions
- Low-level helper for query parameters
- progress bar?: https://github.com/r-lib/httr2/issues/20
- autocompletion of available metadata?
- shiny app like the query browser?
- pkgdown
- test coverage
- ropensci package dev guide
- print method for friendlier response? (subtype of httr2 response type?)
- pretty printing with e.g., cli?
- use of vcr for recording API responses?
- DESCRIPTION file details, licensing, authorship, crediting



## Resources:

- HTTP testing in R book: https://books.ropensci.org/http-testing/index.html
- Video of UseR 2021 Tutorial on package testing: https://www.youtube.com/watch?v=tzQGg1kAzGs&t=4650s&ab_channel=RConsortium
- rOpenSci Package DevGuide: https://devguide.ropensci.org/
- R Packages book: https://r-pkgs.org/
- httr2 vignette, "Wrapping APIs": https://httr2.r-lib.org/articles/wrapping-apis.html


## Test Suite



## Continuous Integration

Ropensci advice re: CI (including Feb 2023 community call).
r-lib github actions
example of CI in eia package (although some is outdated)

## Caching API Requests

The httr2 package has response caching, but it is based on whether the API reports that it is cachable and when the results expire. In the case of the EIA API, the expiration is nearly immediate, so no significant caching is possible through the httr2 mechanism. It could be that is the right approach.

The eia package did within-session caching of requests via memoisation. This seems like it could be a feasible approach.

Within targets pipelines results are cached, and it would be wonderful to have better tools for specifying how a target based on an API call is invalidated.

Probably other ropensci API packages have examples of best-practice caching.


## Low-level helper to build array/nested query parameters

The EIAv2 API has several query parameters which are nested. However, the httr2 functions for adding query parameters to requests only work for length-1 atomic query parameters. I would like to do my best to document the extent to which there are HTTP standard formats that could be comprehensively supported for array/nested query parameters (not just the EIA API).

Specification:
- application/x-www-form-urlencoded  
- https://www.rfc-editor.org/rfc/rfc3875#section-4.1.7  


I looked into a number of packages which are mentioned in the CRAN task view for web/http, but did not find a package covering the need.

Packages I checked: 
- webutils (ropensci)
- urltools
- request
- httpuv (rstudio) -> ?
- V8 ?

### webutils


### urltools

library(urltools)
urltools::param_set("example.com", "x", c(1, 2))

### request

r <- request("example.com")
str(r)
r |> cat(rawToChar(r$content))

### httpuv

httpuv::encodeURI






