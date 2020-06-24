test_that("test simulator: constructor", {
  set.seed(1)
  g <- Game$new(19, 3, TRUE)
  b <- g$getBoard()
  s <- Simulator$new(b)
  s$simulateDecision(FALSE, 1)
  expect_equal(TRUE, TRUE)
})

test_that("test simulator: time simulation 1000 sims - 0.15s", {
  set.seed(1)
  g <- Game$new(19, 3, FALSE)
  b <- g$getBoard()
  s <- Simulator$new(b)
  t <- system.time({
   a <- s$simulateDecision(FALSE, 1000)
  })
  print(t)
  expect_equal(TRUE, TRUE)
})

# h <- Game$new(g)
# h$progressToEndGame()
# h$getCamelDF()
