




testthat::test_that("expand vector parameter correctly", {

  # expand a vector of values
  expect_equal(
    query_expand_data(list(data = c("value", "price"))),
    list(
      "data[0]"="value",
      "data[1]"="price"
    )
  )

  # length 1 vector must still be interpreted as a vector:
  expect_equal(
    query_expand_data(list(data = "value")),
    list("data[0]"="value")
  )
})

testthat::test_that("expand nested facets parameter to vectors", {
  param_nested <- list(facets = list(stateid = c("CA", "CO"), scenarioid = "ref"))
  param_nested_list <- list(
    "facets[stateid][]"=c("CA", "CO"),
    "facets[scenarioid][]"="ref"
  )
  #param_nested_string <- "facets[stateid][]=CA&facets[stateid][]=CO&facets[scenarioid]=ref"

  expect_equal(
    query_expand_facets(param_nested),
    param_nested_list
  )
})
