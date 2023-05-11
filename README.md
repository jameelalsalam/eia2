
<!-- README.md is generated from README.Rmd. Please edit that file -->

# eia2

<!-- badges: start -->

[![R-CMD-check](https://github.com/jameelalsalam/eia2/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/jameelalsalam/eia2/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The `eia2` package provides functions to download data from the [US
Energy Information Administration Open Data API version
2](https://www.eia.gov/opendata/).

Using the EIA API (via this package or other means) requires a
registered API key.

The EIA provides a data browser and documentation of API concepts that
is helpful to understanding usage of this package.

## Installation

You can install the development version of eia2 from
[GitHub](https://github.com/jameelalsalam/eia2) with:

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

After restarting, running `Sys.getenv("EIA_KEY")` or `eia_get_key()`
should return your key.

Alternatively, your key can be stored in the package environment or
options using `eia_set_key()`. For security, make sure you do not record
your API key in files tracked by git or your .Rhistory.

## Explore Available Data

You can browse available datasets:

``` r
library(eia2)

eia2()
#> $routes
#>  [1] "coal"              "crude-oil-imports" "electricity"      
#>  [4] "international"     "natural-gas"       "nuclear-outages"  
#>  [7] "petroleum"         "seds"              "steo"             
#> [10] "densified-biomass" "total-energy"      "aeo"              
#> [13] "ieo"               "co2-emissions"
```

And iteratively explore routes within a dataset, such as:

``` r
eia2("electricity")
#> $id
#> [1] "electricity"
#> 
#> $name
#> [1] "Electricity"
#> 
#> $description
#> [1] "EIA electricity survey data"
#> 
#> $routes
#> [1] "retail-sales"                    "electric-power-operational-data"
#> [3] "rto"                             "state-electricity-profiles"     
#> [5] "operating-generator-capacity"    "facility-fuel"
```

When you get to the bottom of a route, there won’t be any further
routes, but you need to specify other parameters to retrieve data, such
as which data columns to retrieve.

``` r
eia2("electricity/retail-sales")
#> $id
#> [1] "retail-sales"
#> 
#> $name
#> [1] "Electricity Sales to Ultimate Customers"
#> 
#> $description
#> [1] "Electricity sales to ultimate customer by state and sector (number of customers, average price, revenue, and megawatthours of sales).  \n    Sources: Forms EIA-826, EIA-861, EIA-861M"
#> 
#> $frequency
#> [1] "monthly"   "quarterly" "annual"   
#> 
#> $facets
#> [1] "stateid"  "sectorid"
#> 
#> $data
#> [1] "revenue"   "sales"     "price"     "customers"
#> 
#> $startPeriod
#> [1] "2001-01"
#> 
#> $endPeriod
#> [1] "2023-02"
#> 
#> $defaultDateFormat
#> [1] "YYYY-MM"
#> 
#> $defaultFrequency
#> [1] "monthly"
```

And finally download data such as:

``` r
elec_retail_sales_annual_data <-
  eia2("electricity/retail-sales", frequency = "annual", data_cols = "revenue")

elec_retail_sales_annual_data
#> # A tibble: 5,000 × 7
#>    period stateid stateDescription   sectorid sectorName revenue `revenue-units`
#>     <int> <chr>   <chr>              <chr>    <chr>        <dbl> <chr>          
#>  1   2022 AL      Alabama            ALL      all secto… 10299.  million dollars
#>  2   2022 CO      Colorado           RES      residenti…  2978.  million dollars
#>  3   2022 CO      Colorado           OTH      other         NA   million dollars
#>  4   2022 CO      Colorado           IND      industrial  1357.  million dollars
#>  5   2022 CO      Colorado           COM      commercial  2446.  million dollars
#>  6   2022 CO      Colorado           ALL      all secto…  6790.  million dollars
#>  7   2022 CA      California         TRA      transport…    93.1 million dollars
#>  8   2022 CA      California         RES      residenti… 23661.  million dollars
#>  9   2022 DC      District of Colum… ALL      all secto…  1528.  million dollars
#> 10   2022 DE      Delaware           TRA      transport…     0   million dollars
#> # ℹ 4,990 more rows
```

A full API call can also specify facet filters and different start and
end dates.

``` r
elec_retail_CO <- 
  eia2("electricity/retail-sales",
       frequency = "monthly",
       facets = list(
         stateid = c("CO", "WY")
       ),
       data_cols = c("revenue"),
       start = "2020-01",
       end = "2020-03")

elec_retail_CO
#> # A tibble: 36 × 7
#>    period  stateid stateDescription sectorid sectorName  revenue `revenue-units`
#>    <chr>   <chr>   <chr>            <chr>    <chr>         <dbl> <chr>          
#>  1 2020-03 WY      Wyoming          RES      residential  28.4   million dollars
#>  2 2020-03 WY      Wyoming          TRA      transporta…   0     million dollars
#>  3 2020-03 CO      Colorado         RES      residential 177.    million dollars
#>  4 2020-03 CO      Colorado         TRA      transporta…   0.710 million dollars
#>  5 2020-03 CO      Colorado         ALL      all sectors 434.    million dollars
#>  6 2020-03 CO      Colorado         COM      commercial  161.    million dollars
#>  7 2020-03 WY      Wyoming          IND      industrial   56.3   million dollars
#>  8 2020-03 WY      Wyoming          COM      commercial   27.6   million dollars
#>  9 2020-03 WY      Wyoming          ALL      all sectors 112.    million dollars
#> 10 2020-03 CO      Colorado         OTH      other        NA     million dollars
#> # ℹ 26 more rows
```

## Moving from API version 1

The EIA version 2 API provides a mechanism to retrieve similar data as
was available via the series ID API endpoint in the version 1 API. This
web form on the EIA Open Data website can help translate version 1
series IDs into version 2 routes. In addition, this package provides a
function `eia1_series` which can make requests using legacy series id’s.

``` r
eia1_series("ELEC.SALES.CO-RES.A")
#> # A tibble: 22 × 7
#>    period stateid stateDescription sectorid sectorName   sales `sales-units`    
#>     <int> <chr>   <chr>            <chr>    <chr>        <dbl> <chr>            
#>  1   2022 CO      Colorado         RES      residential 20834. million kilowatt…
#>  2   2021 CO      Colorado         RES      residential 20625. million kilowatt…
#>  3   2020 CO      Colorado         RES      residential 20483. million kilowatt…
#>  4   2019 CO      Colorado         RES      residential 19405. million kilowatt…
#>  5   2018 CO      Colorado         RES      residential 19287. million kilowatt…
#>  6   2017 CO      Colorado         RES      residential 18615. million kilowatt…
#>  7   2016 CO      Colorado         RES      residential 18834. million kilowatt…
#>  8   2015 CO      Colorado         RES      residential 18385. million kilowatt…
#>  9   2014 CO      Colorado         RES      residential 18093. million kilowatt…
#> 10   2013 CO      Colorado         RES      residential 18529. million kilowatt…
#> # ℹ 12 more rows
```

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

## Disclaimer

This package and its authors are not affiliated with the Energy
Information Administration. If you reproduce data it should include an
acknowledgement with the publication date, such as: “Source: U.S. Energy
Information Administration (Oct 2008).” For more information, please see
[EIA’s Copyrights and Reuse
page](https://www.eia.gov/about/copyrights_reuse.php).
