test_that("test tile: plus tile",{
  set.seed(1)
  g <- Game$new(19, 3, TRUE)

  g$takeTurnPlaceTile(4, TRUE)
  g$takeTurnMove()
  df <- g$getCamelDF()
  true_df <- data.frame(Color = c("Green", "White", "Yellow", "Orange", "Blue"),
                        Space = c(1, 2, 2, 3, 5),
                        Height = c(1, 1, 2, 1, 1))
  expect_equal(df, true_df)

  df <- g$getPurseDF()
  true_df <- data.frame(Player = c("Player 0", "Player 1", "Player 2"),
                        Coins = c(2, 0, 0))
  expect_equal(df, true_df)

})

test_that("test tile: plus tile",{
  set.seed(1)
  g <- Game$new(19, 3, TRUE)

  g$takeTurnPlaceTile(4, FALSE)
  g$takeTurnMove()
  df <- g$getCamelDF()
  true_df <- data.frame(Color = c("Green", "White", "Yellow", "Orange", "Blue"),
                        Space = c(1, 2, 2, 3, 3),
                        Height = c(1, 1, 2, 2, 1))
  expect_equal(df, true_df)

  df <- g$getPurseDF()
  true_df <- data.frame(Player = c("Player 0", "Player 1", "Player 2"),
                        Coins = c(2, 0, 0))
  expect_equal(df, true_df)
})
