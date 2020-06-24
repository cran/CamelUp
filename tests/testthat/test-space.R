test_that("test space: constructor", {
  s <- Space$new(5)
  expect_equal(s$getPosition(), 5)
  expect_equal(s$getNCamels(), 0)
  expect_true(!s$getPlusTile())
  expect_true(!s$getMinusTile())
})



#
# test_that("test space constructor", {
#   s <- Space$new(5)
#   c <- Camel$new("Blue")
#   # s$addCamel(c)
#   expect_equal(c$getSpace(), 5)
# })
