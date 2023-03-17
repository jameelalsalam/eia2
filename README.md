
<!-- README.md is generated from README.Rmd. Please edit that file -->

# eia2

<!-- badges: start -->
<!-- badges: end -->

The `eia2` package provides functions to download data from the US
Energy Information Administration Open Data API version 2.

Using the EIA API (via this package or other means) requires a
registered API key.

## Installation

You can install the development version of eia2 from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("jameelalsalam/eia2")
```

## Authentication

Ensure your API key is available by setting it as an environment
variable. You can add it to your user-level .Renviron file by:

``` r
usethis::edit_r_environ("user")
```

And adding a line such as: EIA_KEY=<YOUR-KEY-HERE>

After restarting, running `Sys.getenv("EIA_KEY")` should return your
key.

## Explore Available Data

You can browse available datasets:

``` r
library(eia2)

eia2() |> eia2_resp_meta_routes()
#> # A tibble: 14 x 3
#>    id                name                            description                
#>    <chr>             <chr>                           <chr>                      
#>  1 coal              Coal                            "EIA coal energy data"     
#>  2 crude-oil-imports Crude Oil Imports               "Crude oil imports by coun~
#>  3 electricity       Electricity                     "EIA electricity survey da~
#>  4 international     International                   "Country level production,~
#>  5 natural-gas       Natural Gas                     "EIA natural gas survey da~
#>  6 nuclear-outages   Nuclear Outages                 "EIA nuclear outages surve~
#>  7 petroleum         Petroleum                       "EIA petroleum gas survey ~
#>  8 seds              State Energy Data System (SEDS) "Estimated production, con~
#>  9 steo              Short Term Energy Outlook       "Monthly short term (18 mo~
#> 10 densified-biomass Densified Biomass               "EIA densified biomass dat~
#> 11 total-energy      Total Energy                    "These data represent the ~
#> 12 aeo               Annual Energy Outlook           "Annual U.S. projections u~
#> 13 ieo               International Energy Outlook    "Annual international proj~
#> 14 co2-emissions     State CO2 Emissions             "EIA CO2 Emissions data"
```

And iteratively explore routes within a dataset, such as:

``` r
elec_meta <- eia2("electricity")

elec_meta |> eia2_resp_meta_routes() 
#> # A tibble: 6 x 3
#>   id                              name                                   descr~1
#>   <chr>                           <chr>                                  <chr>  
#> 1 retail-sales                    Electricity Sales to Ultimate Custome~ "Elect~
#> 2 electric-power-operational-data Electric Power Operations (Annual and~ "Month~
#> 3 rto                             Electric Power Operations (Daily and ~ "Hourl~
#> 4 state-electricity-profiles      State Specific Data                    "State~
#> 5 operating-generator-capacity    Inventory of Operable Generators       "Inven~
#> 6 facility-fuel                   Electric Power Operations for Individ~ "Annua~
#> # ... with abbreviated variable name 1: description
```

When you get to the bottom of a route, there won’t be any further
routes:

``` r
eia2("electricity/retail-sales") |> eia2_resp_meta_routes()
#> # A tibble: 0 x 0
```

But to retrieve data, you also need to specify other parameters, such as
the data columns you want to retrieve.

(TODO: example of how to figure out valid data columns and filters)

And finally download data such as:

``` r
elec_retail_sales_annual_data <-
  eia2("electricity/retail-sales", frequency = "annual", data_cols = "revenue")

elec_retail_sales_annual_data
#> # A tibble: 5,000 x 7
#>    period stateid stateDescription sectorid sectorName     revenue revenue-uni~1
#>     <int> <chr>   <chr>            <chr>    <chr>            <dbl> <chr>        
#>  1   2022 ID      Idaho            RES      residential      1028. million doll~
#>  2   2022 TN      Tennessee        RES      residential      5435. million doll~
#>  3   2022 TN      Tennessee        OTH      other              NA  million doll~
#>  4   2022 TN      Tennessee        IND      industrial       1570. million doll~
#>  5   2022 TN      Tennessee        COM      commercial       4322. million doll~
#>  6   2022 TN      Tennessee        ALL      all sectors     11327. million doll~
#>  7   2022 SD      South Dakota     TRA      transportation      0  million doll~
#>  8   2022 SD      South Dakota     RES      residential       646. million doll~
#>  9   2022 SD      South Dakota     OTH      other              NA  million doll~
#> 10   2022 SD      South Dakota     IND      industrial        259. million doll~
#> # ... with 4,990 more rows, and abbreviated variable name 1: `revenue-units`
```

``` r


```

## Moving from API version 1

The EIA version 2 API provides a mechanism to retrieve similar data as
was available via the series ID API endpoint in the version 1 API. This
web form on the EIA Open Data website can help translate version 1
series IDs into version 2 routes. In addition, this package …

## Specifying Related Data via Parameters and Facets

The EIA version 2 API organizes dataset topics using routes, and then
allows specification of various parameters and facets to narrow the
specific data being requested.

…

## Acknowledgements

eia2 is based on previous work by Matthew Leonawicz on the
[eia](https://github.com/ropensci/eia) package. It has benefited from
many useful packages and resources including httr2, ropensci package
guide, and HTTP testing for R.
