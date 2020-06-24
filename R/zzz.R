#' @useDynLib CamelUp
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
