
test_that("wait to add api_key to eia2_req", {
  req <- eia2_req("electricity")

  expect_false(stringr::str_detect(req$url, "api_key"))
})

test_that("default query parameters (other than sort) not added", {

  # sort is the one currently added by default
  r0 <- eia2_req(sort = NULL)

  expect_false(stringr::str_detect(r0$url, "\\?[^[:space:]]*$"))

  r1 <- eia2_req("aeo", sort = NULL)

  expect_false(stringr::str_detect(r1$url, "\\?[[:alnum:]]*"))

})
