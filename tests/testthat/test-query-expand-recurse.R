

testthat::test_that("expand: ordered array param", {

  expect_equal(
    query_expand_params(list(msn = c("first", "second"))),
    list(`msn[0]` = "first", `msn[1]` = "second")
  )

  expect_equal(
    query_expand_params(list(msn = c("first"))),
    list(`msn[0]` = "first")
  )
})

testthat::test_that("expand: unordered nested param", {

  param_nest_unorder <- list(facets = list(sector = "buildings", region = "USA"))

  expect_equal(
    query_expand_params(param_nest_unorder, auto_unbox = FALSE),
    list(`facets[sector][0]` = "buildings", `facets[region][0]` = "USA")
  )
})

testthat::test_that("expand: df", {

  #df <- data.frame(column = c("period", "value"), order = c("desc", "asc"))

  expect_equal(
    query_expand_params(
      list("sort" = data.frame(
        column = c("period", "value"),
        order = c("desc", "asc")))
      ),
    list(
      "sort[0][column]" = "period",
      "sort[0][order]" = "desc",
      "sort[1][column]" = "value",
      "sort[1][order]" = "asc"),
    ignore_attr = TRUE
  )

  #sort[0][column]=period&sort[0][direction]=desc&sort[1][column]=sectorid&sort[1][direction]
})

testthat::test_that("auto_unbox works", {
  param_nest_unorder <- list(facets = list(sector = "buildings", region = "USA"))

  expect_equal(
    query_expand_params(param_nest_unorder, auto_unbox = TRUE),
    list("facets[sector]" = "buildings", "facets[region]" = "USA"),
    ignore_attr = TRUE
  )

  expect_equal(
    query_expand_params(list(facets = list(msn = "first")), auto_unbox = TRUE),
    list("facets[msn]" = "first"),
    ignore_attr = TRUE
  )

  expect_equal(
    query_expand_params(list(msn = c("first")), auto_unbox = TRUE),
    list("msn" = "first"),
    ignore_attr = TRUE
  )

})

testthat::test_that("null parameters preserved", {
  expect_equal(
    query_expand_params(list(api_key = NULL)),
    list(api_key = NULL)
  )
})

