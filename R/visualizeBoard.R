#' #' visualizeBoard
#' #'
#' #' @param g a game object
#' #'
#' #' @return
#' #' @export
#' #'
#' #' @examples
#' #' g <- Game$new(19, 3, TRUE)
#' #' visualizeBoard(g)
#' visualizeBoard <- function(g){
#'   camelDF <- g$getCamelDF()
#'   camelDF$Color <- as.character(camelDF$Color)
#'   camelDF <- arrange(camelDF, Color)
#'
#'   camelDF %>%
#'     ggplot(aes(x = Space, y = Height, fill = Color)) +
#'     geom_tile(color = "black", size = 1) +
#'     scale_fill_manual(values = as.character(camelDF$Color)) +
#'     geom_vline(xintercept = 16.5) +
#'     coord_cartesian(xlim = c(1, 19),
#'                     ylim = c(0.5,5)) +
#'     theme_classic() +
#'     labs(title = "Current State of the Game",
#'          fill = "Camel")
#' }
