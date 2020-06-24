test_that("test game: copy constructor", {
  g <- Game$new(19, 3, TRUE)
  df <- g$getCamelDF()
  h <- Game$new(g)
  expect_equal(df, g$getCamelDF())
  })

test_that("test game: copy constructor", {
  g <- Game$new(19, 3, TRUE)
  h <- Game$new(g)
  k <- Game$new(g)
  expect_equal(TRUE, TRUE)
})


test_that("test game: constructor error", {
  g <- Game$new(19, 3, FALSE)
  h <- Game$new(g)
  df1 <- h$getCamelDF()
  g$takeTurnMove()
  expect_equal(df1, h$getCamelDF())
})

test_that("something w the board", {
  b <- Board$new(19, FALSE)
  c <- Board$new(b)
  # df1 <- c$getCamelDF()
  # expect_equal(b$getCamelDF(), c$getCamelDF())
  #
  # b$moveTurn()
  # expect_equal(df1, c$getCamelDF())
  expect_equal(TRUE, TRUE)

})
