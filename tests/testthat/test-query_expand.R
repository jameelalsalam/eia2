




testthat::test_that("expand vector parameter correctly", {

  # expand a vector of values
  expect_equal(
    query_expand_data(list(data = c("value", "price"))),
    list(
      "data[0]"="value",
      "data[1]"="price"
    ),
    ignore_attr = TRUE
  )

  # length 1 vector must still be interpreted as a vector:
  expect_equal(
    query_expand_data(list(data = "value")),
    list("data[0]"="value"),
    ignore_attr = TRUE
  )
})


testthat::test_that("expand nested facets parameter", {
  param_nested <- list(facets = list(stateid = c("CA", "CO"), scenarioid = "ref"))
  param_nested_list <- list(
    "facets[stateid][0]" = "CA",
    "facets[stateid][1]" = "CO",
    "facets[scenarioid][0]"="ref"
  )
  #param_nested_string <- "facets[stateid][]=CA&facets[stateid][]=CO&facets[scenarioid]=ref"

  expect_equal(
    query_expand_facets(param_nested),
    param_nested_list,
    ignore_attr = TRUE
  )
})
