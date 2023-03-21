
test_that("eia1_series() catches invalid inputs", {
  expect_error(eia1_series_req(
    c("AEO.2022.REF2022.EMI_CO2_RESD_NA_NA_NA_NA_MILLMETNCO2.A",
      "AEO.2022.REF2022.EMI_CO2_COMM_NA_NA_NA_NA_MILLMETNCO2.A")))
})

test_that("url as expected for basic compatibility request", {
  expect_equal(
    eia1_series_req("ELEC.SALES.CO-RES.A")$url,
    "https://api.eia.gov/v2/seriesid/ELEC.SALES.CO-RES.A")
})

if(FALSE) {
  # calling the API examples:

  req <- eia1_series_req("ELEC.SALES.CO-RES.A")
  resp <- eia2_req_perform(req)

  eia2_resp_data(resp)
  eia2_resp_total(resp)
  httr2::resp_body_json(resp) |> View()

  eia1_series("ELEC.SALES.CO-RES.A")

}
