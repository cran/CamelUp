#' @useDynLib CamelUp
NULL


# Avoid CMD check note Namespace in Imports field not imported from
# https://github.com/hadley/r-pkgs/issues/203
#' @import methods
NULL

# Rcpp::loadModule("double_cpp", TRUE)
Rcpp::loadModule("die_cpp", TRUE)
Rcpp::loadModule("camel_cpp", TRUE)
Rcpp::loadModule("space_cpp", TRUE)
Rcpp::loadModule("board_cpp", TRUE)
Rcpp::loadModule("player_cpp", TRUE)
Rcpp::loadModule("legbet_cpp", TRUE)
Rcpp::loadModule("game_cpp", TRUE)
Rcpp::loadModule("simulator_cpp", TRUE)
