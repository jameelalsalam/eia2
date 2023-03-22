

# scratchwork examples

#devtools::load_all(".")
library(eia2)

# Walking through the sections of the documentation:

#### Iterating through the API Tree:
# DOC SECTION: https://www.eia.gov/opendata/documentation.php#Iterating
elec_meta <- eia2("electricity")

# info on possible routes below /electricity:
elec_meta$routes

# below /electricity/retail-sales
elec_retail_meta <- eia2("electricity/retail-sales")

# this time no routes below this:
elec_retail_meta$routes


##### Examining a Metadata request:
# DOC SECTION: https://www.eia.gov/opendata/documentation.php#Examining

# so what is returned?
elec_retail_meta

# info on frequency, facets, startPerid, endPeriod, and data columns are returned

##### Facets and their available values:
# DOC SECTION: https://www.eia.gov/opendata/documentation.php#FacetValues

# you can ask about possible facet values either by constructing manually
elec_retail_facet_meta <- eia2("electricity/retail-sales/facet/sectorid")

elec_retail_facet_meta

# or with purpose-built function:
elec_retail_facet_sector <- eia2_facet("electricity/retail-sales", facet = "sectorid")

# the only difference right now is slightly different data extraction format

elec_retail_facet_sector
# we are told 6 possible values for facet sectorid: RES, COM, ALL, TRA, OTH, IND
# we can query on a sectorid not in this list, for example xxx. The API won't return
# an error--because that's a valid query. However, we won't receive any data
# returns eitehr, because the xxx sector doesn't have any data points.


#### Returning Metadata versus specific data values
# DOC SECTION: https://www.eia.gov/opendata/documentation.php#Returning
elec_retail_data_v1 <- eia2("electricity/retail-sales/data")
View(elec_retail_data_v1)

# the function `eia2()` is meant to be user-friendly, so it automatically extracts
# data from a data request response.

# from the unextracted response, you could get the total, but its not returned by `eia2()`
# another option is to control each of the steps yourself:

# 1) construct request object
elec_retail_req <- eia2_req("electricity/retail-sales/data")

# 2) perform request
elec_retail_resp <- eia2_req_perform(elec_retail_req)

# 3) extract information as needed. Check total rows, and then look at first 5000

eia2:::eia2_resp_total(elec_retail_resp)
# [1] 98208

eia2_resp_data(elec_retail_resp)


## Restrict now to a smaller set, CO only
elec_retail_CO <- eia2("electricity/retail-sales", facets = list(stateid = "CO"))
elec_retail_CO

# to retrieve data, either need to add /data to route, or specify data_cols
elec_retail_data_CO <- eia2("electricity/retail-sales/data", facets = list(stateid = "CO"))
elec_retail_data_CO

elec_retail_sales_annual_data <-
  eia2("electricity/retail-sales", frequency = "annual", data_cols = c("revenue"))


