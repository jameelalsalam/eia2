
# Tests for characteristics of EIA API v2

test_that("Maximum 5000 data points returned", {
  skip_no_api_key()

  req_inf <- eia2_req(route = "electricity/retail-sales", data_cols = "sales")
  resp_inf <- eia2_req_perform(req_inf)
  expect_equal(nrow(eia2_resp_data(resp_inf)), 5000)

  req_4999 <- eia2_req(route = "electricity/retail-sales", data_cols = "sales", length = 4999)
  resp_4999 <- eia2_req_perform(req_4999)
  expect_equal(nrow(eia2_resp_data(resp_4999)), 4999)

})
