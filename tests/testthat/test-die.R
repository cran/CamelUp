test_that("test die: constructor", {
  d <- Die$new("Blue")
  expect_equal(d$getColor(), "Blue")
  expect_equal(d$getValue(), 0)
})

test_that("test die: roll", {
  d <- Die$new("Blue")
  set.seed(1)
  expect_equal(d$roll(), 1)
  expect_equal(d$getValue(), 1)
})
