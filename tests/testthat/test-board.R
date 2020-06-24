test_that("test board: constructor", {
  b <- Board$new(19, FALSE)
  expect_equal(b$getNDiceRemaining(), 5)
  expect_equal(b$getNCamels(), 5)
})

test_that("test board: initCamels", {
  set.seed(1)
  b <- Board$new(19, TRUE)

  df <- b$getCamelDF()
  true_df <- data.frame(Color = c("Green", "White", "Yellow", "Orange", "Blue"),
                        Space = c(1, 2, 2, 3, 1),
                        Height = c(1, 1, 2, 1, 2))

  expect_equal(df, true_df)
})

test_that("test board: moveTurn", {
  set.seed(1)
  b <- Board$new(19, TRUE)

  df <- b$getCamelDF()
  true_df <- data.frame(Color = c("Green", "White", "Yellow", "Orange", "Blue"),
                        Space = c(1, 2, 2, 3, 1),
                        Height = c(1, 1, 2, 1, 2))

  expect_equal(df, true_df)
})

test_that("test board: moveTurn2", {
  set.seed(1)
  b <- Board$new(19, TRUE)
  b$moveTurn()
  df <- b$getCamelDF()
  true_df <- data.frame(Color = c("Green", "White", "Yellow", "Orange", "Blue"),
                        Space = c(1, 2, 2, 3, 4),
                        Height = c(1, 1, 2, 1, 1))

  expect_equal(df, true_df)
})

# test_that("test board: copy constructor runs", {
#   set.seed(1)
#   b <- Board$new(19, TRUE)
#   c <- Board$new(b)
#   expect_that(TRUE, TRUE)
# })
