# eia2

The `eia2` package provides functions to download data from the US Energy Information Administration Open Data API version 2.

Using the EIA API (via this package or other means) requires a registered API key.


## Installation

To install the development version from GitHub use

``` r
# install.packages("remotes")
remotes::install_github("jameelalsalam/eia2")
```

## Authentication

Ensure your API key is available by setting it as an environment variable. You can add it to your user-level .Renviron file by:

``` r
usethis::edit_r_environ("user")
```

And adding a line such as:
EIA_KEY=<YOUR-KEY-HERE>

After restarting, running `Sys.getenv("EIA_KEY")` should return your key.


## Explore Available Data

You can browse available datasets:

``` r
library(eia2)

#TODO: friendly metadata print
eia2()
```

And iteratively explore available data within a dataset, such as:

``` r
#TODO: friendly metadata print
elec_meta <- eia2("electricity")

# look at it generally:
elec_meta |> resp_body_json() |> str()

# info on possible routes below /electricity:
elec_meta |> eia2_resp_meta_routes() |> tibble::as_tibble()
```

And finally download data such as:

``` r

elec_retail_sales_annual_data <-
  eia2("electricity/retail-sales", list(frequency = "annual"), get_data = TRUE)

```

## Moving from API version 1

The EIA version 2 API provides a mechanism to retrieve similar data as was available via the series ID API endpoint in the version 1 API. This web form on the EIA Open Data website can help translate version 1 series IDs into version 2 routes. In addition, this package ...


## Specifying Related Data via Parameters and Facets

The EIA version 2 API organizes dataset topics using routes, and then allows specification of various parameters and facets to narrow the specific data being requested.

...


## Acknowledgements

eia2 is based on previous work by Matthew Leonawicz on the [eia](https://github.com/ropensci/eia) package. It has benefited from many useful packages and resources including httr2, ropensci package guide, and HTTP testing for R.
