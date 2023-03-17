

# scratchwork examples

devtools::load_all(".")


# Walking through the sections of the documentation:

#### Iterating through the API Tree:
# DOC SECTION: https://www.eia.gov/opendata/documentation.php#Iterating
elec_meta <- eia2("electricity")

# info on possible routes below /electricity:
elec_meta

# below /electricity/retail-sales
elec_retail_meta <- eia2("electricity/retail-sales")

# this time no routes below this:
elec_retail_meta |> eia2_resp_meta_routes() |> View()


##### Examining a Metadata request:
# DOC SECTION: https://www.eia.gov/opendata/documentation.php#Examining

# so what is returned?
elec_retail_meta |> resp_body_json() |> str()

# info on frequency, facets, startPerid, endPeriod, and data columns are returned

##### Facets and their available values:
# DOC SECTION: https://www.eia.gov/opendata/documentation.php#FacetValues

elec_retail_facet_sector <- eia2("electricity/retail-sales/facet/sectorid")

elec_retail_facet_sector |> resp_body_json() |> str()
# we are told 6 possible values for facet sectorid: RES, COM, ALL, TRA, OTH, IND
# we can query on a sectorid not in this list, for example xxx. The API won't return
# an error--because that's a valid query. However, we won't receive any data
# returns eitehr, because the xxx sector doesn't have any data points.


#### Returning Metadata versus specific data values
# DOC SECTION: https://www.eia.gov/opendata/documentation.php#Returning
elec_retail_data_v1 <- eia2("electricity/retail-sales/data")
View(elec_retail_data_v1)

# from the response you can get total, but its gone now:
# eia2_resp_total(elec_retail_data_v1)

# [1] 97464
# API doc shows 7440. Maybe this is restricted to CO?

elec_retail_CO <- eia2("electricity/retail-sales", facets = list(stateid = "CO"))
elec_retail_CO |> resp_body_json() |> str()

elec_retail_data_CO <- eia2("electricity/retail-sales/data", facets = list(stateid = "CO"))





elec_retail_sales_annual_data <-
  eia2("electricity/retail-sales", frequency = "annual", data_cols = c("revenue"))


