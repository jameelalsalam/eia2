# example-more-than-5000.R

# The EIA API will only return 5000 data points at a time (in json, in XML only 300).
# For data queries with more data than this, you can make requests in a loop.
# Right now for this approach, you need to control the steps individually.

eia2("electricity/retail-sales")

req_big <- eia2_req(
  "electricity/retail-sales",
  data_cols = "revenue",
  facets = list(
    stateid = c("CO", "CA", "TX", "NH", "MN", "VA", "IL", "MD", "AK")
  ),
  length = 10000)

resp_big_1 <- eia2_req_perform(req_big)

total_n <- resp_big_1 |> eia2:::eia2_resp_total()
total_n

resp_big_data <- list()
resp_big_data[[1]] <- eia2_resp_data(resp_big_1)

if (total_n > 5000) {
  for (offset in seq(from = 5000, to = total_n, by = 5000)) {
    i <- (offset %/% 5000) + 1
    resp_big_data[[i]] <- {
      eia2_req(
        "electricity/retail-sales",
        data_cols = "revenue",
        facets = list(
          stateid = c("CO", "CA", "TX", "NH", "MN", "VA", "IL", "MD", "AK")
        ),
        offset = offset
      ) |>
        eia2_req_perform() |>
        eia2_resp_data()
    }
  }
}

data <- dplyr::bind_rows(!!!resp_big_data)

nrow(data)
total_n


