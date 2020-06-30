#' Simulate moving
#'
#' @param g game object
#'
#'
simulateMoveOnce <- function(g){
  newGame <- g #TODO: come back here to fix
  while(!newGame$checkIsGameOver()){
    # print(newGame$getCamelDF())
    newGame$takeTurnMove()
  }
  # print("endSimOnce")
  return(newGame)
}

#' Simulate moving N times
#'
#' @param g game object
#' @param N number of sims
#'
#'
#' @export
simulateMoveNTimes <- function(g, N){
  # works:
  positionDFList <- list()
  # for(i in 1:N){
  #   newGame <- Game$new(g)
  #   newGame$progressToEndGame()
  #   # progressToEndGame(newGame)
  #
  #   currentDT <- data.table::as.data.table(newGame$getCamelDF())
  #   currentDT$id <- i
  #   positionDFList <- append(positionDFList, list(currentDT))
  #
  # }
  positionDFList <- lapply(1:N, FUN = function(x){
    newGame <- Game$new(g)
    newGame$progressToEndGame()
    return(data.table::as.data.table(newGame$getCamelDF()))
  })
#
#   # no_cores <- parallel::detectCores()
#   # cl <- parallel::makeCluster(no_cores)
#   # doParallel::registerDoParallel()
#   # positionDFList<-foreach::foreach(i=1:N, .combine = rbind) %dopar% {
#   #     newGame <- Game$new(g)
#   #     newGame$progressToEndGame()
#   #     newGame$getCamelDF()
#   #   }
#   #
#   # doParallel::stopImplicitCluster()

  # cl <- parallel::makeCluster(getOption("cl.cores", 2))
  # l <- list(1:N)
  # positionDFList<- parallel::parLapply(cl, l, function(x) {
  #     newGame <- Game$new(g)
  #     newGame$progressToEndGame()
  #     return(data.table::as.data.table(newGame$getCamelDF()))
  # })
  return(data.table::rbindlist(positionDFList))

}
