
test_that("check_sort_param allows blanks", {

  expect_no_error(check_sort_param(NULL))
  expect_no_error(check_sort_param(
    tibble::tibble(column = character(), direction = character())))
  expect_no_error(check_sort_param(
    data.frame(column = character(), direction = character())))

})

test_that("check_sort_param catches invalid input", {

  expect_error(check_sort_param(
    tibble::tibble(col = character(), dir = character())))

  # TODO: should list that can be coerced be allowed?
  expect_error(check_sort_param(
    list(direction = character(), column = character())))

  # TODO: should reversing order of the columns be allowed?
  expect_error(check_sort_param(
    tibble::tibble(direction = character(), column = character())))

  # TODO: should other versions of zero-length be allowed?
  expect_error(check_sort_param(
    tibble::tibble(column = NULL, direction = NULL)))
  expect_error(check_sort_param(
    tibble::tibble(column = NA_character_, direction = NA_character_)))

})
