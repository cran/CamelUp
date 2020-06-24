test_that("test player: constructor", {
  p <- Player$new("Michael")
  expect_equal(p$getName(), "Michael")
  expect_equal(p$getCoins(), 0)
})

test_that("test player: addCoins", {
  p <- Player$new("Michael")
  p$addCoins(10)
  expect_equal(p$getCoins(), 10)
})

test_that("test player: overall winner", {
  p <- Player$new("Michael")
  p$setOverallFirst("Blue")
  expect_equal(p$getOverallFirst(), "Blue")
})

test_that("test player: overall loser", {
  p <- Player$new("Michael")
  p$setOverallLast("Blue")
  expect_equal(p$getOverallLast(), "Blue")
})

