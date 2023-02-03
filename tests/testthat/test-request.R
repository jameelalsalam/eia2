
test_that("wait to add api_key to eia2_req", {
  req <- eia2_req("electricity")

  expect_false(stringr::str_detect(req$url, "api_key"))
})
