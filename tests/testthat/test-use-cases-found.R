
test_that("mis-specifying argument as `data` instead of `data_cols` uses partial matching", {

  expect_no_error(
    eia2_req(
      "petroleum/pri/spt",
      frequency = "weekly",
      data = "value"
    )
  )
})


test_that("found queries form requests without error", {

  # example fully specified query, <5000 data points
  req_small <-
    expect_no_error(

      eia2_req(
        "petroleum/stoc/typ",
        frequency = "monthly",
        data_cols = "value",
        facets = list(
          duoarea = "NUS",
          product = "EPC0",
          series = "MCSSTUS1",
          process = "SAS"
        ))
    )

  # example query, >5000 data points
  req_big <-
    expect_no_error(
      eia2_req(
        "petroleum/pri/spt",
        frequency = "weekly",
        data_cols = "value"
      )
    )

})

if (FALSE) {
  # API access...

  resp_small <- eia2_req_perform(req_small)

  resp_small |> eia2_resp_total()
  resp_small |> eia2_resp_data() |> View()

  resp_big_1 <- eia2_req_perform(req_big)

  resp_big_1 |> eia2_resp_total()
  resp_big_1 |> eia2_resp_data() |> View()


}
