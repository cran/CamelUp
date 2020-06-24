test_that("test camel: constructor", {
  c <- Camel$new("Blue")
  expect_equal(c$getColor(), "Blue")
  expect_equal(c$getSpace(), 0)
  expect_equal(c$getHeight(), 0)
})

test_that("test camel: set and get space/height",{
  c <- Camel$new("Blue")
  c$setSpace(3)
  expect_equal(c$getSpace(), 3)

  c$setHeight(4)
  expect_equal(c$getHeight(), 4)
})

# test_that("test camel: duplication",{
#   c <- Camel$new("Blue")
#   s <- sample(1:10, 1)
#   h <- sample(1:10, 1)
#   c$setSpace(s)
#   c$setHeight(h)
#
#   newC <- c$duplicate()
#   expect_equal(newC$getSpace(), s)
#   expect_equal(newC$getHeight(), h)
#   expect_equal(newC$getColor(), "Blue")
# })
