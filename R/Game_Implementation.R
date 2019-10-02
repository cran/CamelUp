# Alex Lyford
# Tom Rahr
# Tina Chen
# Michael Czekanski






#' Implements a classic stack with push, pop and a few other methods
#'
#' @import R6
#' @docType class
#' @export stack
#' @exportClass stack
#'
#' @examples
#' x <- stack$new()
#' x$push(5)
#' y <- x$pop()
stack <- R6Class(classname = 'Stack',
                 public = list(
                   s = NULL, #vector representing the stack itself
                   n = NA, #number of elements in stack
                   initialize = function(){
                     self$s = vector(length = 0)
                     self$n = 0
                   },
                   push = function(item){
                     #push functionality
                     self$s = c(item, self$s)
                     self$n = length(self$s)
                   },
                   #Pop top element off of the stack
                   pop = function(){
                     #pop functionality
                     if(self$n > 1){
                       temp <- self$s[[1]]
                       self$s <- self$s[2:self$n]
                       self$n <- length(self$s)
                     } else if(self$n == 1) {
                       temp <- self$s[[1]]
                       self$s <- NULL
                       self$n <- 0
                     }
                     return(temp)

                   },
                   top = function(){
                     #returns element at the top of the stack
                     if(self$n > 0)
                       return(self$s[[1]])
                     else
                       return(NA)
                   },
                   print = function() {
                     #prints elements of the stack
                     temp = NULL
                     for(x in self$s){
                       if(is.environment(self$s[[1]]) == TRUE)
                         temp <- c(temp, x$print())
                       else
                         temp <- c(temp, x)
                     }
                     return(temp)
                   }
                 ))


#' Implements camel class based off of the board game pieces
#' @export camel
#' @exportClass camel
#'
#' @examples
#' x <- camel$new("blue", 1, 1)
camel <- R6Class(classname = 'Camel',
                 public = list(
                   color = NA,
                   position = NA,
                   index = NA,
                   initialize = function(color, position = 1, index) {
                     self$color = color
                     self$position = position
                     self$index = index
                   },
                   getColor = function(){
                     return(self$color)
                   },
                   move = function(dis){
                     self$position <- self$position + dis
                   },
                   print = function(){
                     return(paste(substr(self$color,1,1)))
                   },
                   duplicate = function(){
                     return(self$clone())
                   }

                 )
)

#' Implements spaces on the board
#' @export space
#' @exportClass space
#'
#' @examples
#' x <- space$new()
space <- R6Class(classname = 'Space',
                 public = list(
                   camels = NULL,
                   plus.tile = NA,
                   minus.tile = NA,
                   tile.placed.by = NA,
                   initialize = function(){
                     self$camels <- stack$new()
                     self$plus.tile <- FALSE
                     self$minus.tile <- FALSE
                     self$tile.placed.by <- NA
                   },
                   push.camel = function(camel){
                     self$camels$push(camel)
                   },
                   pop.camel = function(){
                     return(self$camels$pop())
                   },
                   place.tile = function(plus.minus){
                     if(self$plus.tile == FALSE & self$minus.tile == FALSE){
                       if(plus.minus == 'plus'){
                         self$plus.tile = TRUE
                       } else if(plus.minus == 'minus'){
                         self$minus.tile = TRUE
                       }
                     }
                   },
                   print = function(){
                     return(paste(c(self$camels$print(), '///', self$plus.tile, self$minus.tile),collapse = ' '))
                   },
                   duplicate = function(){
                     newSpace <- space$new()
                     nCamels <- self$camels$n
                     temp <- NULL
                     # if(nCamels > 0){
                     #   for(i in 1:nCamels){
                     #
                     #     temp <- c(self$pop.camel(), temp)
                     #   }
                     #   for(i in 1:nCamels){
                     #     newSpace$push.camel(temp[[i]]$duplicate())
                     #     self$push.camel(temp[[i]])
                     #   }
                     # }
                     if(self$plus.tile){
                       newSpace$place.tile("plus")
                       newSpace$tile.placed.by <- self$tile.placed.by
                     } else if(self$minus.tile){
                       newSpace$place.tile("minus")
                       newSpace$tile.placed.by <- self$tile.placed.by
                     }
                     return(newSpace)
                   }
                 ))

#' A three sided die, assigned a color corresponding to a camel
#' @export die
#' @exportClass die
#'
#' @examples
#' x <- die$new("blue")
die <- R6Class(classname = 'Die',
               public = list(
                 color = NA,
                 initialize = function(color){
                   self$color <- color
                 },
                 roll = function(){
                   return(sample.int(3,1))
                 },
                 print = function(){
                   return(paste(c(self$color, 'Die'), collapse = ' '))
                 },
                 duplicate = function(){
                   return(self$clone())
                 }
               ))

#' A bet object that is placed for a leg on a given camel
#' @export bet
#' @exportClass bet
#'
#' @examples
#' x <- bet$new("blue", 5)
bet <- R6Class(classname = 'Bet',
               public = list(
                 color = NULL,
                 value= NULL,
                 initialize = function(color, value){
                   self$color <- color
                   self$value <- value
                 },

                 print = function() {
                   return(paste(c(substr(self$color,1,1), self$value), collapse = ''))
                 },
                 duplicate = function(){
                   return(self$clone())
                 }
               ))

#' A bet object that is placed overall on a given camel
#' @export overall.bet
#' @exportClass overall.bet
#'
#' @examples
#' s <- system$new(nPlayers = 2, players = c("Michael", "Alex"))
#' p <- s$players[[1]]
#' x <- overall.bet$new("blue", p)
overall.bet <- R6Class(classname = 'Overall.Bet',
                       public = list(
                         color = NULL,
                         player = NULL,
                         initialize = function(color, player){
                           self$color <- color
                           self$player <- player
                         },

                         print = function(){
                           return(paste(c(substr(self$color,1,1), self$player$print()), collapse = ''))
                         },
                         duplicate = function(){
                           return(self$clone())
                         }
                       ))

#' A board object on which the game is played
#' @export board
#' @exportClass board
#'
#' @examples
#' y <- system$new(nPlayers = 2, players = c("Michael", "Alex"))
#' x <- board$new(y)
board <- R6Class(classname = 'Board',
                 public = list(
                   spaces = NULL,
                   tot.camels = NULL,
                   dice.left = NULL,
                   dice.rolled = NULL,
                   system = NULL,
                   y.bets = NULL,
                   w.bets = NULL,
                   b.bets = NULL,
                   g.bets = NULL,
                   o.bets = NULL,


                   winner.bets = NULL,
                   loser.bets = NULL,
                   initialize = function(sys){
                     self$system = sys
                     self$spaces <- NULL
                     for(j in 1:19){
                       self$spaces <- c(self$spaces, space$new())
                     }
                     bet.values <- c(2,3,5)
                     self$y.bets = stack$new()
                     self$w.bets = stack$new()
                     self$b.bets = stack$new()
                     self$g.bets = stack$new()
                     self$o.bets = stack$new()
                     for(i in bet.values){
                       self$y.bets$push(bet$new('Yellow', i))
                       self$w.bets$push(bet$new('White', i))
                       self$b.bets$push(bet$new('Blue', i))
                       self$g.bets$push(bet$new('Green', i))
                       self$o.bets$push(bet$new('Orange', i))
                     }
                     self$winner.bets = stack$new()
                     self$loser.bets = stack$new()

                     colors <- c('Yellow','White','Blue','Green','Orange')
                     for(i in 1:5){
                       self$tot.camels <- c(self$tot.camels, camel$new(color = colors[i], index = i))
                       self$dice.left <- c(self$dice.left, die$new(color = colors[i]))
                     }
                     self$dice.rolled <- NULL
                     for(i in sample(self$tot.camels)){
                       pos <- sample.int(3,1)
                       self$spaces[[pos]]$push.camel(i)
                       i$position <- pos
                     }
                   },

                   choose.die = function(){

                     x <- sample.int(length(self$dice.left),1)
                     t <- NULL
                     for(y in 1:length(self$dice.left)){
                       if(y == x)
                         t <- c(t, FALSE)
                       else
                         t <- c(t, TRUE)
                     }
                     temp <- self$dice.left[[x]]
                     self$dice.rolled <- c(self$dice.rolled, temp)
                     self$dice.left <- self$dice.left[t]
                     return(temp)

                   },

                   move.camel = function(die, dis){
                     # print(c('move.camel in board', die$print()))
                     cam.colors <- NULL
                     for(cam in self$tot.camels){
                       cam.colors <- c(cam.colors, cam$getColor())
                     }

                     index <- match(die$color, cam.colors)


                     camel.m <- self$tot.camels[[index]]
                     print(c(camel.m$print(), camel.m$position, dis))
                     if(self$spaces[[camel.m$position + dis]]$plus.tile == FALSE &
                        self$spaces[[camel.m$position + dis]]$minus.tile == FALSE){
                       camel.m$move(dis)

                       temp.stack <- stack$new()
                       for(c in 1:self$spaces[[camel.m$position-dis]]$camels$n){
                         #print(paste("camel", camel.m$position, "   ", dis))
                         #print(camel.m$position-dis)
                         t <- self$spaces[[camel.m$position-dis]]$pop.camel()
                         temp.stack$push(t)
                         if(t$color == die$color){
                           break
                         }
                       }
                       # print(c("origin", self$spaces[[camel.m$position-dis]]$print()))
                       temp.length <- temp.stack$n
                       for(t in 1:temp.length){
                         z <- temp.stack$pop()
                         self$spaces[[camel.m$position]]$push.camel(z)
                         # print(c(z$color, "original z position:",z$position))
                         z$position <- camel.m$position
                         # print(c(z$color, "after z position:",z$position))
                       }
                       # print(c("destination", self$spaces[[camel.m$position]]$print()))

                     }
                     else if(self$spaces[[camel.m$position + dis]]$plus.tile == TRUE){
                       self$system$increment.purse(self$spaces[[camel.m$position+dis]]$tile.placed.by)
                       camel.m$move(dis + 1)

                       temp.stack <- stack$new()
                       for(c in 1:self$spaces[[camel.m$position-dis-1]]$camels$n){
                         t <- self$spaces[[camel.m$position-dis-1]]$pop.camel()
                         temp.stack$push(t)
                         if(t$color == die$color){
                           break
                         }
                       }
                       for(t in 1:temp.stack$n){
                         z <- temp.stack$pop()
                         self$spaces[[camel.m$position]]$push.camel(z)
                         z$position <- camel.m$position
                       }

                     }
                     else if(self$spaces[[camel.m$position + dis]]$minus.tile == TRUE){
                       self$system$increment.purse(self$spaces[[camel.m$position+dis]]$tile.placed.by)
                       camel.m$move(dis - 1)

                       temp.stack <- stack$new()
                       for(c in 1:self$spaces[[camel.m$position-dis+1]]$camels$n){
                         t <- self$spaces[[camel.m$position-dis+1]]$pop.camel()
                         temp.stack$push(t)
                         if(t$color == die$color){
                           break
                         }
                       }

                       temp.stack2 <- stack$new()
                       if(self$spaces[[camel.m$position]]$camels$n > 0){
                         for(c in 1:self$spaces[[camel.m$position]]$camels$n){
                           t2 <- self$spaces[[camel.m$position]]$pop.camel()
                           temp.stack2$push(t2)
                         }
                       }

                       for(t in 1:temp.stack$n){
                         z <- temp.stack$pop()
                         self$spaces[[camel.m$position]]$push.camel(z)
                         z$position <- camel.m$position
                       }
                       if(temp.stack2$n > 0){ #ADDED THIS IF
                         for(t in 1:temp.stack2$n){
                           z <- temp.stack2$pop()
                           self$spaces[[camel.m$position]]$push.camel(z)
                           z$position <- camel.m$position
                         }
                       }
                     }


                   },

                   reset.leg = function(){
                     bet.values <- c(2,3,5)
                     self$y.bets = stack$new()
                     self$w.bets = stack$new()
                     self$b.bets = stack$new()
                     self$g.bets = stack$new()
                     self$o.bets = stack$new()
                     for(i in bet.values){
                       self$y.bets$push(bet$new('Yellow', i))
                       self$w.bets$push(bet$new('White', i))
                       self$b.bets$push(bet$new('Blue', i))
                       self$g.bets$push(bet$new('Green', i))
                       self$o.bets$push(bet$new('Orange', i))
                     }
                     for(s in self$spaces){
                       s$plus.tile <- FALSE
                       s$minus.tile <- FALSE
                       s$tile.placed.by <- NA
                     }
                     colors <- c('Yellow','White','Blue','Green','Orange')
                     for(c in colors){
                       self$dice.left <- c(self$dice.left, die$new(color = c))
                     }
                     self$dice.rolled <- NULL
                   },

                   check.end.leg = function() {
                     if(length(self$dice.left) == 0 | self$check.end.game())
                       return(TRUE)
                     else
                       return(FALSE)
                   },

                   check.end.game = function() {
                     for(cam in self$tot.camels){
                       if(cam$position > 16){

                         return(TRUE)
                       }
                     }
                     return(FALSE)
                   },


                   print = function(){


                     space.print.list <- NULL
                     for(space in 1:16){
                       space.print.list <- c(space.print.list, self$spaces[[space]]$print())
                     }
                     space.print <- paste(space.print.list, collapse = '-')
                     sps <- strsplit(space.print, split = '-')

                     y.bet.print.list <- NULL
                     if(self$y.bets$n > 0){
                       for(y in 1:self$y.bets$n){
                         y.bet.print.list <- c(y.bet.print.list, self$y.bets$s[[y]]$print())
                       }
                       y.paste <- paste(y.bet.print.list, collapse = ' ')
                     }
                     else
                       y.paste <- ''

                     w.bet.print.list <- NULL
                     if(self$w.bets$n > 0){
                       for(w in 1:self$w.bets$n){
                         w.bet.print.list <- c(w.bet.print.list, self$w.bets$s[[w]]$print())
                       }
                       w.paste <- paste(w.bet.print.list, collapse = ' ')
                     }
                     else
                       w.paste <- ''

                     b.bet.print.list <- NULL
                     if(self$b.bets$n > 0){
                       for(b in 1:self$b.bets$n){
                         b.bet.print.list <- c(b.bet.print.list, self$b.bets$s[[b]]$print())
                       }
                       b.paste <- paste(b.bet.print.list, collapse = ' ')
                     }
                     else
                       b.paste <- ''

                     g.bet.print.list <- NULL
                     if(self$g.bets$n > 0){
                       for(g in 1:self$g.bets$n){
                         g.bet.print.list <- c(g.bet.print.list, self$g.bets$s[[g]]$print())
                       }
                       g.paste <- paste(g.bet.print.list, collapse = ' ')
                     }
                     else
                       g.paste <- ''

                     o.bet.print.list <- NULL
                     if(self$o.bets$n > 0){
                       for(o in 1:self$o.bets$n){
                         o.bet.print.list <- c(o.bet.print.list, self$o.bets$s[[o]]$print())
                       }
                       o.paste <- paste(o.bet.print.list, collapse = ' ')
                     }
                     else
                       o.paste <- ''

                     bet.print <- paste(c(y.paste, w.paste, b.paste, g.paste, o.paste), collapse = '-')

                     bs <- strsplit(bet.print, split = '-')

                     # for(i in 1:5){
                     #   print(c("in board$print()", self$tot.camels[[i]]$color, self$tot.camels[[i]]$position))
                     # }
                     #
                     # print("Dice Left")
                     # for(die in self$dice.left){
                     #   print(die$color)
                     # }
                     #
                     # print("Dice Rolled")
                     # for(die in self$dice.rolled){
                     #   print(die$color)
                     # }

                     return(list(sps, bs))
                   },
                   duplicate = function(system){
                     newBoard = board$new(system) #relates board to new system

                     newBoard$tot.camels <- NULL
                     for(c in self$tot.camels){
                       newCamel <- c$duplicate()
                       newBoard$tot.camels <- c(newBoard$tot.camels, newCamel)
                     }
                     # for(i in 1:5){
                     #   print(c( " after: ", newBoard$tot.camels[[i]]$print(), newBoard$tot.camels[[i]]$position))
                     # }
                     #duplicate winner.bets and loser.bets
                     nWinBets <- self$winner.bets$n
                     if(nWinBets > 0){
                       for(i in 1:nWinBets){
                         temp$push(self$winner.bets$pop())
                       }
                       for(i in 1:nWinBets){
                         bet <- temp$pop()
                         self$winner.bets$push(bet)
                         newBoard$winner.bets$push(bet$duplicate())
                       }
                     }

                     nLoseBets <- self$loser.bets$n
                     if(nLoseBets > 0){
                       for(i in 1:nLoseBets){
                         temp$push(self$loser.bets$pop())
                       }
                       for(i in 1:nLoseBets){
                         bet <- temp$pop()
                         self$loser.bets$push(bet)
                         newBoard$loser.bets$push(bet$duplicate())
                       }
                     }

                     newBoard$dice.left <- NULL
                     for(i in 1:length(self$dice.left)){
                       newBoard$dice.left[[i]] <- self$dice.left[[i]]$duplicate()
                     }

                     return(newBoard)
                   },
                   getTileSpaces = function(){
                     tileSpaces <- 1:19
                     tileDir <- rep("", 19)
                     for (i in 1:19){
                       currentSpace <- self$spaces[[i]]
                       if (currentSpace$plus.tile){
                         #tileSpaces[i] <- c(tileSpaces, i)
                         tileDir[i] <- paste("+1", self$system$players[[currentSpace$tile.placed.by]]$name)
                       } else if (currentSpace$minus.tile){
                         #tileSpaces[i] <- c(tileSpaces, i)
                         tileDir[i] <- paste("-1", self$system$players[[currentSpace$tile.placed.by]]$name)
                       }
                     }
                     #print("getTileSpaces")
                     #print(tileSpaces[tileDir == ""])
                     return(list(tileSpaces[tileDir == ""], tileDir))
                   }
                 ))


#' Player object to represent each player using bets and a purse
#' @export player
#' @exportClass player
#'
#' @examples
#'
#' s <- system$new(nPlayers = 2, players = c("Michael", "Alex"))
#' x <- player$new("Michael", s$board)
player <- R6Class(classname = 'Player',
                  public = list(
                    purse = NULL,
                    plus.tile = NULL,
                    minus.tile = NULL,
                    name = NULL,
                    leg.bets = NULL,
                    end.game.bets = NULL, #Doesn't seem to be uesd
                    board = NULL,
                    initialize = function(name, board){
                      self$board = board
                      self$purse = 3
                      self$name = name
                      self$plus.tile = 0
                      self$minus.tile = 0
                      self$leg.bets = NULL
                    },

                    place.bet = function(color){
                      if(color == 'Yellow' && self$board$y.bets$n != 0){
                        self$leg.bets <- c(self$leg.bets, self$board$y.bets$pop())
                        return(TRUE)
                      }
                      if(color == 'White' && self$board$w.bets$n != 0){
                        self$leg.bets <- c(self$leg.bets, self$board$w.bets$pop())
                        return(TRUE)
                      }
                      if(color == 'Blue' && self$board$b.bets$n != 0){
                        self$leg.bets <- c(self$leg.bets, self$board$b.bets$pop())
                        return(TRUE)
                      }
                      if(color == 'Green' && self$board$g.bets$n != 0){
                        self$leg.bets <- c(self$leg.bets, self$board$g.bets$pop())
                        return(TRUE)
                      }
                      if(color == 'Orange' && self$board$o.bets$n != 0){
                        self$leg.bets <- c(self$leg.bets, self$board$o.bets$pop())
                        return(TRUE)
                      }
                      return(FALSE)
                    },

                    place.winner.bet = function(color){
                      self$board$winner.bets$push(overall.bet$new(color, self))
                    },

                    place.loser.bet = function(color){
                      self$board$loser.bets$push(overall.bet$new(color, self))
                    },

                    make.move = function(isSim = FALSE){
                      # print('make.move')
                      d <- self$board$choose.die()
                      color <- d$color
                      dis <- d$roll()
                      message(c(d$print(), ' ', dis))
                      self$board$move.camel(die = d, dis = dis)

                      if(!isSim){
                        self$purse <- self$purse + 1
                      }

                      return(c(TRUE, paste0(color, ' Die rolled ', dis)))
                    },



                    print = function(){

                      print.bets <- NULL
                      for(b in self$leg.bets){
                        print.bets <- paste(c(print.bets, b$print()), collapse = '')
                      }

                      player.objs <- strsplit(x = paste(c(paste(c('Name:', self$name), collapse = ' '),
                                                          paste(c('Purse:', self$purse), collapse = ' '),
                                                          paste(c('Bets:', print.bets),collapse = ' '),
                                                          paste(c('Plus Tile:', self$plus.tile), collapse = ' '),
                                                          paste(c('Minus Tile:', self$minus.tile), collapse = ' ')),
                                                        collapse = '-'), split = '-')

                      return(player.objs)
                    },
                    duplicate = function(board){
                      newPlayer <- player$new(name = self$name, board = board) #create new player
                      newPlayer$purse <- self$purse #duplicate purse
                      newPlayer$plus.tile <- self$plus.tile #duplicate plus.tile
                      newPlayer$minus.tile <- self$minus.tile #duplciate minus.tile
                      for(bet in self$leg.bets){ #duplicae leg.bets
                        newPlayer$leg.bets <- c(newPlayer$leg.bets, bet$duplicate())
                      }
                      return(newPlayer)
                    }

                  ))

#' System class that manages overall game play
#'
#' @import tidyverse
#' @import parallel
#'
#' @export system
#' @exportClass system
#'
#' @examples
#' x <- system$new(nPlayers = 2, players = c("Michael", "Alex"))
system <- R6Class(classname = 'System',
                  public = list(
                    board = NULL,
                    n.players = NA,
                    players = NULL,
                    current.player = NULL,
                    simData = NULL,
                    gameOver = FALSE,

                    # Initialize system object
                    initialize = function(nPlayers = NULL, players = NULL, isDup = FALSE){ #NEW
                      self$board = board$new(self)
                      self$n.players <- nPlayers
                      if(is.null(nPlayers)){
                        self$n.players = as.numeric(readline(prompt = 'Enter number of players: '))
                      }
                      temp <- !is.null(players)
                      if(temp){
                        for (p in players){
                          self$players <- c(self$players, player$new(p, self$board))
                        }
                      }
                      if(!isDup & !temp){
                        for(p in 1:self$n.players){
                          p.name <- readline(prompt = paste(c("Enter Player ", p, "'s name: "), collapse = ''))
                          self$players <- c(self$players, player$new(p.name, self$board))
                        }
                      }


                      self$current.player = 1

                    },

                    simGame = function(action, nDiceSeq){

                      # print("sim game")
                      currentPurse <- self$players[[self$current.player]]$purse
                      sim <- self$duplicate()
                      name <- self$players[[self$current.player]]$name
                      #nDiceLeft <- length(self$board$dice.left)
                      lastNumDice <- max(nDiceSeq)
                      if (action == "move"){
                        for(i in nDiceSeq){
                          if(!sim$gameOver){
                            # lastNumDice <- length(sim$board$dice.left)
                            sim$take.turn("move", TRUE)

                          }

                        }
                        # while(!sim$board$check.end.leg()){
                        #   sim$take.turn("move", TRUE)
                        #
                        # }
                      } else if (stringr::str_detect(action, "winner") | stringr::str_detect(action, "loser")){
                        sim$take.turn(action)
                        while(!sim$board$check.end.game()){
                          sim$take.turn("move", TRUE)
                        }
                      } else {
                        sim$take.turn(action)
                        for(i in nDiceSeq){
                          if(!sim$gameOver){
                            # lastNumDice <- length(sim$board$dice.left)
                            sim$take.turn("move", TRUE)
                          }
                        }
                      }

                      result <- sim$initial_record(name, currentPurse)
                      # print(result)
                      result <- data.table::as.data.table(result)


                      return(result)
                    },

                    #' @import tidyverse
                    #'
                    #' @import parallel
                    simNGames = function(action, nSims){
                      camelResults <- data.table::data.table()
                      #purseResults <- NULL
                      # registerDoMC(detectCores()-1)
                      nDiceSeq <- 1:length(self$board$dice.left)
                      # camelResults <- data.frame()

                      # for(i in 1:nSims) {
                      #   camelResults <- rbind(camelResults, self$simGame(action, nDiceSeq))
                      # }
                      numCores <- parallel::detectCores() - 1
                      # my_cluster <- makeCluster(num_cores)
                      # force(self)
                      temp <- self$duplicate()
                      sims <- parallel::mclapply(1:nSims, mc.cores = numCores, FUN = function(x){
                        #print(x)
                        force(temp)
                        temp$simGame(action, nDiceSeq)
                      })

                      print(sims)
                      simsDF <- data.table::rbindlist(sims)
                      simsDF <- as.data.frame(simsDF)


                      #print("finished simNGames")
                      self$simData <- simsDF
                      #return(camelResults)
                    },


                    take.turn = function(input = NULL, isSim = FALSE){

                      if(is.null(input)){
                        input <- readline(prompt = paste(c(self$players[[self$current.player]]$name, ", it is your turn. What would you like to do? "), collapse = ''))
                      }

                      dispText <- NULL
                      #message(input)
                      # command <- stringr::str_sub(input, 1, stringr::str_locate(input, ' ')[1])
                      # message(command)
                      #print(input)
                      valid <- FALSE
                      if(stringr::str_detect(input, 'bet') == TRUE){
                        temp <- stringr::str_sub(input, (stringr::str_locate(input, ' ')[1]+1), nchar(input))
                        message(temp)
                        dispText <-  temp
                        valid <- self$players[[self$current.player]]$place.bet(stringr::str_sub(input, (stringr::str_locate(input, ' ')[1]+1), nchar(input)))
                        message(valid)
                        #dispText <-  c(dispText, valid)
                      }
                      else if(stringr::str_detect(input, 'move') == TRUE){
                        # print('move called')
                        if(length(self$board$dice.left) > 0){
                          temp <- self$players[[self$current.player]]$make.move(isSim)
                          #print(temp)
                          valid <- temp[1]
                          dispText <- temp[2]
                        }
                      }
                      else if(stringr::str_detect(input, 'plus') == TRUE){
                        if(self$players[[self$current.player]]$plus.tile == 0 & self$players[[self$current.player]]$minus.tile == 0){
                          if(self$board$spaces[[as.numeric(stringr::str_sub(input,(stringr::str_locate(input, ' ')[1]+1)))]]$plus.tile == FALSE &
                             self$board$spaces[[as.numeric(stringr::str_sub(input,(stringr::str_locate(input, ' ')[1]+1)))]]$minus.tile == FALSE){
                            if(self$board$spaces[[as.numeric(stringr::str_sub(input,(stringr::str_locate(input, ' ')[1]+1)))]]$camels$n == 0){
                              self$board$spaces[[as.numeric(stringr::str_sub(input,(stringr::str_locate(input, ' ')[1]+1)))]]$plus.tile <- TRUE
                              self$board$spaces[[as.numeric(stringr::str_sub(input,(stringr::str_locate(input, ' ')[1]+1)))]]$tile.placed.by <- self$current.player
                              self$players[[self$current.player]]$plus.tile <- as.numeric(stringr::str_sub(input, (stringr::str_locate(input, ' ')[1]+1)))
                              dispText <- paste0("Plus tile placed on space ", stringr::str_sub(input,(stringr::str_locate(input, ' ')[1]+1)), " by ", self$players[[self$current.player]]$name)
                              valid <- TRUE
                            }
                            else
                              valid <- FALSE
                          }
                          else
                            valid <- FALSE
                        }
                        else
                          valid <- FALSE
                      }
                      else if(stringr::str_detect(input, 'minus') == TRUE){
                        if(self$players[[self$current.player]]$plus.tile == 0 & self$players[[self$current.player]]$minus.tile == 0){
                          if(self$board$spaces[[as.numeric(stringr::str_sub(input,(stringr::str_locate(input, ' ')[1]+1)))]]$plus.tile == FALSE &
                             self$board$spaces[[as.numeric(stringr::str_sub(input,(stringr::str_locate(input, ' ')[1]+1)))]]$minus.tile == FALSE){
                            if(self$board$spaces[[as.numeric(stringr::str_sub(input,(stringr::str_locate(input, ' ')[1]+1)))]]$camels$n == 0){
                              self$board$spaces[[as.numeric(stringr::str_sub(input,(stringr::str_locate(input, ' ')[1]+1)))]]$minus.tile <- TRUE
                              self$board$spaces[[as.numeric(stringr::str_sub(input,(stringr::str_locate(input, ' ')[1]+1)))]]$tile.placed.by <- self$current.player
                              self$players[[self$current.player]]$minus.tile <- as.numeric(stringr::str_sub(input, (stringr::str_locate(input, ' ')[1]+1)))
                              dispText <- paste0("Minus tile placed on space ", stringr::str_sub(input,(stringr::str_locate(input, ' ')[1]+1)), "by ", self$players[[self$current.player]]$name)
                              valid <- TRUE
                            }
                            else
                              valid <- FALSE
                          }
                          else
                            valid <- FALSE
                        }
                        else
                          valid <- FALSE
                      }

                      else if(stringr::str_detect(input, 'winner') == TRUE){
                        self$players[[self$current.player]]$place.winner.bet(color = stringr::str_sub(input,(stringr::str_locate(input, ' ')[1]+1)))
                        dispText <- "Overall Winner bet placed"
                        valid <- TRUE
                      }
                      else if(stringr::str_detect(input, 'loser') == TRUE){
                        self$players[[self$current.player]]$place.loser.bet(color = stringr::str_sub(input,(stringr::str_locate(input, ' ')[1]+1)))
                        dispText <- "Overall Loser bet placed"
                        valid <- TRUE
                      }
                      if(valid == TRUE){
                        self$increase.current.player()
                      }


                      if(self$board$check.end.game() == TRUE){

                        self$eval.leg()
                        self$eval.end.game()
                        self$gameOver <- TRUE

                        max <- 0
                        game.winner <- NA
                        for(p in self$players){
                          if(p$purse > max){
                            game.winner <- p$name
                            max <- p$purse
                          }
                        }
                        self$print()
                        dispText <- paste(c("Game Over! ", game.winner, " is the winner!"), collapse = '')
                        message(dispText)

                      }


                      else{
                        if(self$board$check.end.leg() == TRUE){
                          self$eval.leg()
                          self$reset.leg()
                        }
                      }


                      self$print()
                      return(dispText)

                    },

                    increase.current.player = function(){
                      if(self$current.player == self$n.players)
                        self$current.player <- 1
                      else
                        self$current.player <- self$current.player + 1
                    },

                    increment.purse = function(player){
                      self$players[[player]]$purse <- self$players[[player]]$purse + 1
                    }
                    ,

                    eval.leg = function(){

                      for(i in 19:1){
                        if(self$board$spaces[[i]]$camels$n > 1){
                          winner <- self$board$spaces[[i]]$camels$pop()
                          r.up <- self$board$spaces[[i]]$camels$top()
                          self$board$spaces[[i]]$camels$push(winner)
                          break
                        }
                        else if(self$board$spaces[[i]]$camels$n == 1){
                          winner <- self$board$spaces[[i]]$camels$top()
                          for(j in (i-1):1){
                            if(self$board$spaces[[j]]$camels$n > 0){
                              r.up <- self$board$spaces[[j]]$camels$top()
                              break
                            }
                          }
                          break
                        }
                      }
                      message(c("Winner: ", winner$print(), "  Runner-Up: ", r.up$print()))

                      for(p in self$players){
                        for(b in p$leg.bets){
                          if(b$color == winner$color)
                            p$purse <- p$purse + b$value
                          else if(b$color == r.up$color)
                            p$purse <- p$purse + 1
                          else
                            p$purse <- p$purse - 1
                        }

                      }
                    },

                    reset.leg = function(){
                      self$board$reset.leg()
                      for(p in self$players){
                        p$leg.bets <- NULL
                        p$plus.tile <- 0
                        p$minus.tile <- 0
                      }
                    },

                    eval.end.game = function(){
                      for(i in 19:1){
                        if(self$board$spaces[[i]]$camels$n > 0){
                          winner <- self$board$spaces[[i]]$camels$pop()
                          self$board$spaces[[i]]$camels$push(winner)
                          break
                        }
                      }
                      for(i in 1:19){
                        if(self$board$spaces[[i]]$camels$n == 1){
                          loser <- self$board$spaces[[i]]$camels$pop()
                          self$board$spaces[[i]]$camels$push(loser)
                          break
                        }
                        else if(self$board$spaces[[i]]$camels$n > 1){
                          temp <- stack$new()
                          for(c in 1:self$board$spaces[[i]]$camels$n){
                            t <- self$board$spaces[[i]]$camels$pop()
                            temp$push(t)
                          }
                          loser <- temp$pop()
                          temp$push(loser)
                          for(c in 1:temp$n){
                            t <- temp$pop()
                            self$board$spaces[[i]]$camels$push(t)
                          }
                        }
                      }
                      bet.vals <- stack$new()
                      for(i in c(1,2,3,5,8)){
                        bet.vals$push(i)
                      }
                      if(self$board$winner.bets$n > 0){
                        temp <- stack$new()
                        for(p in 1:self$board$winner.bets$n){
                          t <- self$board$winner.bets$pop()
                          temp$push(t)
                        }
                        for(q in 1:temp$n){
                          b <- temp$pop()
                          if(b$color == winner$color){
                            b$player$purse <- b$player$purse + bet.vals$pop()
                          }
                          else{
                            b$player$purse <- b$player$purse - 1
                          }
                        }
                      }
                      bet.vals <- stack$new()
                      for(i in c(1,2,3,5,8)){
                        bet.vals$push(i)
                      }

                      temp2 <- stack$new()
                      if(self$board$loser.bets$n > 0){
                        for(p in 1:self$board$loser.bets$n){
                          t <- self$board$loser.bets$pop()
                          temp2$push(t)
                        }
                        for(q in 1:temp2$n){
                          b <- temp2$pop()
                          if(b$color == loser$color){
                            b$player$purse <- b$player$purse + bet.vals$pop()
                          }
                          else{
                            b$player$purse <- b$player$purse - 1
                          }
                        }
                      }

                    },

                    initial_record = function(name = NULL, originalPurse = 0){



                      camels.in.order <- NULL
                      x.values <- NULL
                      y.values <- NULL
                      for(i in 19:1){
                        if(self$board$spaces[[i]]$camels$n > 1){
                          length <- self$board$spaces[[i]]$camels$n
                          temp.stack <- stack$new()
                          for(j in 1:length){
                            temp <- self$board$spaces[[i]]$camels$pop()
                            temp.stack$push(temp)
                            camels.in.order[[temp$index]] <- temp$color
                            x.values[[temp$index]] <- i
                            y.values[[temp$index]] <- length + 1 - j
                          }
                          for(j in 1:length){
                            self$board$spaces[[i]]$camels$push(temp.stack$pop())
                          }
                        }
                        else if(self$board$spaces[[i]]$camels$n == 1){
                          temp <- self$board$spaces[[i]]$camels$pop()
                          camels.in.order[[temp$index]] <- temp$color
                          x.values[[temp$index]] <- i
                          y.values[[temp$index]] <- 1
                          self$board$spaces[[i]]$camels$push(temp)
                        }
                      }


                      current.purse <- self$players[[self$current.player]]$purse
                      if(!is.null(name))
                        for(p in self$players){
                          if (p$name == name){
                            current.purse <- p$purse
                          }
                        }
                      output.table <- data.table::data.table("Color" = c(camels.in.order, "Player"), "X" = c(x.values, current.purse - originalPurse), "Y" = c(y.values, current.purse - originalPurse))

                      return(output.table)

                    },

                    post_record = function(initial.camel.order, initial.camel.positions, previous.player, initial.purse){

                      output.vector <- c()
                      for(c in 1:5){
                        output.vector <- c(output.vector, initial.camel.order[[i]]$position - initial.camel.positions[[i]])
                      }

                      output.vector <- c(output.vector, self$players[[previous.player]]$purse - initial.purse)

                      # print(paste(output.vector, collapse=''))

                    },

                    print = function(){

                      b.print <- self$board$print()
                      p.print <- NULL
                      for(p in self$players){
                        p.print <- c(p.print, p$print())
                      }

                      return(list(b.print, p.print, paste(c('Current player: ', self$players[[self$current.player]]$name), collapse = '')))
                    },
                    duplicate = function(){
                      # print("NOW DUPLICATING SYSTEM")
                      # print("creating new system")
                      newSystem <- system$new(nPlayers = self$n.players, isDup = TRUE)
                      # print("duplicating board")
                      newSystem$board <- self$board$duplicate(newSystem)
                      # print("duplicating players")
                      newSystem$current.player <- self$current.player
                      for(p in self$players){
                        # print("Duplicate player")
                        newSystem$players <- c(newSystem$players, p$duplicate(newSystem$board))
                      }
                      newSystem$board$spaces <- c()
                      for(i in 1:19){
                        newSystem$board$spaces <- c(newSystem$board$spaces, self$board$spaces[[i]]$duplicate())
                        temp <- NULL
                        while(self$board$spaces[[i]]$camels$n > 0){
                          temp <- c(self$board$spaces[[i]]$pop.camel(), temp)
                        }

                        nCamel <- length(temp)
                        if(nCamel > 0){
                          for(j in 1:nCamel){
                            k <- 1
                            while(temp[[j]]$color != self$board$tot.camels[[k]]$color){
                              k <- k + 1
                            }
                            newSystem$board$spaces[[i]]$push.camel(newSystem$board$tot.camels[[k]])
                            self$board$spaces[[i]]$push.camel(self$board$tot.camels[[k]])
                          }
                        }
                      }

                      return(newSystem)
                    },

                    graphGame = function(){
                      data <- self$initial_record()
                      tiles <- self$board$getTileSpaces()
                      #fullColors <- c("blue", "darkgreen", "orange", "white", "yellow")
                      camelColors <- cleanColors(data$Color)
                      if(nrow(data) == 1){
                        plt <- ggplot2::ggplot(data, ggplot2::aes(x = X, y = Y)) +
                          ggplot2::geom_blank() +
                          ggplot2::coord_cartesian(xlim = c(1, 19),
                                                   ylim = c(0.49, 5.49)) +
                          ggplot2::scale_x_continuous(breaks = 1:19) +
                          ggplot2::geom_vline(xintercept = 16.5) +
                          ggplot2::theme_classic() +
                          ggplot2::guides(color = FALSE, size = FALSE) +
                          ggplot2::theme(legend.background = ggplot2::element_rect(colour = 'black', fill = 'white', linetype='solid'),
                                         legend.key = ggplot2::element_rect(color = "black"))
                        return(plt)
                      }

                      filteredData <- dplyr::filter(data, Color != "Player")
                      plt <- ggplot2::ggplot(filteredData, mapping = ggplot2::aes(x = X, y = Y, fill = Color, color = "black", width = 1)) +
                        ggplot2::geom_tile() +
                        ggplot2::scale_fill_manual(values = camelColors) +
                        ggplot2::coord_cartesian(xlim = c(1, 19),
                                                 ylim = c(0.49, 5.49)) +
                        ggplot2::scale_x_continuous(breaks = 1:19, labels = (paste(1:19, tiles[[2]], sep = "\n"))) +
                        ggplot2::geom_vline(xintercept = 16.5) +
                        ggplot2::theme_classic() +
                        ggplot2::guides(color = FALSE, size = FALSE) +
                        ggplot2::theme(legend.background = ggplot2::element_rect(colour = 'black', fill = 'white', linetype='solid'),
                                       legend.key = ggplot2::element_rect(color = "black"))
                      return(plt)
                    },

                    purseTable = function(){
                      purses <- c()
                      names <- c()
                      for (p in self$players){
                        purses <- c(purses, p$purse)
                        names <- c(names, p$name)
                      }
                      result <- data.table::data.table("Name" = names, "Purse" = purses)
                      return(result)
                    },
                    graphCamelSim = function(color, data, action, type, vLinesBool) {
                      nSims <- nrow(data)/6
                      vLines <- c(16.5)

                      filteredData <- dplyr::filter(data, Color == color)

                      if(type != "purse"){
                        avg <- mean(filteredData$X)
                        stdDevX <- sd(filteredData$X)
                      } else {
                        playerData <- dplyr::filter(data, Color == "Player")
                        avg <- mean(playerData$X)
                        stdDevX <- sd(playerData$X)
                        vLines <- NULL
                      }


                      if(length(vLinesBool) > 0){

                        expVal <- eval(vLinesBool[1])
                        std1 <- eval(vLinesBool[2])
                        std2 <- eval(vLinesBool[3])

                        if (!is.na(std2)){
                          vLines <- c(vLines, avg + 2*stdDevX, avg - 2*stdDevX)
                          std1 <- TRUE
                        }

                        if (!is.na(std1)){
                          vLines <- c(vLines, avg + stdDevX, avg - stdDevX)
                          expVal <- TRUE
                        }

                        if(!is.na(expVal)){
                          vLines <- c(vLines, avg)
                        }
                      }

                      if(type == "stack"){

                        tempData <- dplyr::group_by(filteredData, X, Y)
                        tempData <- dplyr::summarize(tempData, "count" = n())
                        tempData <- dplyr::mutate(tempData, Probability = count/sum(tempData$count))

                        plt <- ggplot2::ggplot(tempData, ggplot2::aes(x = X, y = Y), width = 10) +
                          ggplot2::geom_tile(ggplot2::aes(alpha = Probability), color = "black", fill = ifelse(color == "White",
                                                                                                               "black",
                                                                                                               color),
                                             width = 0.9) +
                          ggplot2::coord_cartesian(xlim = c(1, 19)) +
                          ggplot2::ylim(0, 5.49) +
                          ggplot2::scale_x_continuous(breaks = 1:19) +
                          ggplot2::scale_y_continuous(labels = c("0.00", "1.00", "2.00", "3.00", "4.00", "5.00"),
                                                      breaks = 0:5) +
                          ggplot2::geom_vline(xintercept = vLines) +
                          ggplot2::theme_classic() +
                          ggplot2::labs(x = "Space",
                                        y = "Height",
                                        title = paste("2-Dimensional Plot of Camel Simulation Results. Mean = ", round(mean(filteredData$X), 4), ". ", "Std. Dev. = ", round(sd(filteredData$X), 4)))
                        #print("test")
                        #print(mean(tempData$X))
                      }
                      if(type == "space"){
                        Camel <- "blue"
                        tempData <- dplyr::group_by(filteredData, X)
                        tempData <- dplyr::summarize(tempData, "count" = n())
                        tempData <- dplyr::mutate(tempData, "Probability" = count/nSims)

                        plt <- ggplot2::ggplot(tempData, ggplot2::aes(x = X, y = Probability)) +
                          ggplot2::geom_bar(stat = "identity",
                                            fill = ifelse(color == "White",
                                                          "black",
                                                          color),
                                            mapping = ggplot2::aes(color = color),
                                            width = 0.9) +
                          ggplot2::geom_text(ggplot2::aes(label = round(Probability, 3)), position=ggplot2::position_dodge(width=0.9), vjust=-0.25) +
                          ggplot2::coord_cartesian(xlim = c(1, 19)) +
                          ggplot2::scale_x_continuous(breaks = 1:19) +
                          ggplot2::ylim(0,1)+
                          ggplot2::geom_vline(xintercept = vLines) +
                          ggplot2::theme_classic() +
                          ggplot2::labs(x = "Space",
                                        y = "Probability",
                                        title = paste("Space vs. Probability Simulation Results. Mean = ", round(mean(filteredData$X), 4), ". ", "Std. Dev. = ", round(sd(filteredData$X), 4))) +
                          ggplot2::scale_color_manual("Camel",
                                                      values = "black",
                                                      breaks = color)


                      }
                      if(type == "purse"){
                        tempData <- dplyr::filter(data, Color == "Player")

                        tempData <- dplyr::group_by(tempData, X)
                        tempData <- dplyr::summarize(tempData, "count" = n())
                        tempData <- dplyr::mutate(tempData, "Probability" = count/nSims)
                        print(tempData)
                        plt <- ggplot2::ggplot(tempData, ggplot2::aes(x = X, y = Probability)) +
                          ggplot2::geom_bar(stat = "identity",
                                            fill = ifelse(color == "White",
                                                          "black",
                                                          color)
                                            , width = 0.9) +
                          ggplot2::geom_text(ggplot2::aes(label = round(Probability, 3)), position=ggplot2::position_dodge(width=0.9), vjust=-0.25) +
                          ggplot2::scale_x_continuous(breaks = -1:10) +
                          ggplot2::ylim(0,1)+
                          ggplot2::geom_vline(xintercept = vLines) +
                          ggplot2::theme_classic() +
                          ggplot2::labs(x = "Number of Coins",
                                        y = "Probability",
                                        title = paste0("Purse vs. Probability Simulation Results. Mean = ", round(mean(tempData$X), 2)), ". ", "Std. Dev. = ", round(sd(tempData$X),2))
                        #coord_cartesian(xlim = c(1, 19)) +
                        #ggplot2::scale_x_continuous(breaks = 1:19) +
                        #ggplot2::geom_vline(xintercept = 17) +
                        #theme_classic()
                      }
                      return(plt)
                    },
                    createSimGraphs = function(color, action, nSims, vLinesBool = rep(FALSE, 3)){
                      print(action)
                      if(is.null(self$simData)){
                        self$simNGames(action, nSims)
                      }
                      data <- self$simData
                      stack <- self$graphCamelSim(color, data, action, type = "stack", vLinesBool)
                      space <- self$graphCamelSim(color, data, action, type = "space", vLinesBool)
                      if(stringr::str_detect(action, "bet") | stringr::str_detect(action, "winner") | stringr::str_detect(action, "loser")){
                        p <- self$graphCamelSim(color, data, action, type = "purse", vLinesBool)
                        a <- gridExtra::grid.arrange(stack, space, p, nrow = 3)
                        # pushViewport(viewport(layout = grid.layout(3, 1), xscale = c(0,19)))
                        # purse <- self$graphCamelSim(color, data, action, type = "purse")
                        # grid::print(purse, vp = viewport(layout.pos.row = 3, layout.pos.col = 1))
                        # grid::print(space, vp = viewport(layout.pos.row = 2, layout.pos.col = 1))
                        # grid::print(stack, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))
                      } else {
                        a <- gridExtra::grid.arrange(stack, space, nrow = 2)
                        # pushViewport(viewport(layout = grid.layout(2, 1), xscale = c(0,19)))
                        # grid::print(space, vp = viewport(layout.pos.row = 2, layout.pos.col = 1))
                        # grid::print(stack, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))
                      }
                      return(a)
                    },
                    clearBoard = function(){
                      self$board$tot.camels <- NULL
                      self$board$spaces <- NULL
                      for(j in 1:19){
                        self$board$spaces <- c(self$board$spaces, space$new())
                      }
                      self$board$dice.left <- NULL
                      self$board$dice.rolled <- NULL
                    },

                    changeCamel = function(color, space){
                      colors <- c('Yellow','White','Blue','Green','Orange')
                      i <- 0
                      #c <- colors[i]
                      c <- ""
                      while(c != color){
                        i <- i + 1
                        c <- colors[i]
                      }
                      newCamel <- camel$new(color, space, i)
                      self$board$spaces[[space]]$push.camel(newCamel)
                      self$board$tot.camels[[i]] <- newCamel
                      #c$position <- space
                    },

                    createBetsTable = function(){
                      selfBoard <- self$board

                      yellow <- rep("None", 3)
                      tempY <- NULL
                      yN <- selfBoard$y.bets$n
                      if(yN > 0){
                        for(i in 1:yN){
                          currentBet <- selfBoard$y.bets$pop()
                          tempY <- c(tempY, currentBet)
                          yellow[i] <- currentBet$value
                        }
                      }


                      blue <- rep("None", 3)
                      tempB <- NULL
                      bN <- selfBoard$b.bets$n
                      if(bN > 0){
                        for(i in 1:bN){
                          currentBet <- selfBoard$b.bets$pop()
                          tempB <- c(tempB, currentBet)
                          blue[i] <- currentBet$value
                        }
                      }

                      white <- rep("None", 3)
                      tempW <- NULL
                      wN <- selfBoard$w.bets$n
                      if(wN > 0){
                        for(i in 1:wN){
                          currentBet <- selfBoard$w.bets$pop()
                          tempW <- c(tempW, currentBet)
                          white[i] <- currentBet$value
                        }
                      }

                      orange <- rep("None", 3)
                      tempO <- NULL
                      oN <- selfBoard$o.bets$n
                      if(oN > 0){
                        for(i in 1:oN){
                          currentBet <- selfBoard$o.bets$pop()
                          tempO <- c(tempO, currentBet)
                          orange[i] <- currentBet$value
                        }
                      }

                      green <- rep("None", 3)
                      tempG <- NULL
                      gN <- selfBoard$g.bets$n
                      if(gN > 0){
                        for(i in 1:gN){
                          currentBet <- selfBoard$g.bets$pop()
                          tempG <- c(tempG, currentBet)
                          green[i] <- currentBet$value
                        }
                      }

                      for(i in yN:1){
                        selfBoard$y.bets$push(tempY[i])
                      }
                      for(i in bN:1){
                        selfBoard$b.bets$push(tempB[i])
                      }
                      for(i in wN:1){
                        selfBoard$w.bets$push(tempW[i])
                      }
                      for(i in oN:1){
                        selfBoard$o.bets$push(tempO[i])
                      }
                      for(i in gN:1){
                        selfBoard$g.bets$push(tempG[i])
                      }
                      return(data.table::data.table("Yellow" = yellow[1],
                                                    "White" = white[1],
                                                    "Blue" = blue[1],
                                                    "Green" = green[1],
                                                    "Orange" = orange[1]))
                    },

                    createDiceTable = function(){
                      selfBoard <- self$board
                      colors <- NULL
                      for (die in selfBoard$dice.left){
                        colors <- c(colors, die$color)
                      }
                      if(length(colors) == 0){
                        return(data.table::data.table("Dice Remaining" = "None"))
                      }
                      return(data.table::data.table("Dice Remaining" = colors))
                    },
                    changeBets = function(color, num){
                      betVals <- c(2, 3, 5)
                      newBets <- stack$new()
                      if (num > 0){
                        for(i in 1:num){
                          newBets$push(bet$new(color, betVals[i]))
                        }
                      }
                      if(color == "Yellow"){
                        self$board$y.bets <- newBets
                      }
                      if(color == "Green"){
                        self$board$g.bets <- newBets
                      }
                      if(color == "Blue"){
                        self$board$b.bets <- newBets
                      }
                      if(color == "White"){
                        self$board$w.bets <- newBets
                      }
                      if(color == "Orange"){
                        self$board$o.bets <- newBets
                      }
                    },
                    changeDie = function(color, left){
                      if(left){
                        self$board$dice.left <- c(self$board$dice.left, die$new(color))
                      } else {
                        self$board$dice.rolled <- c(self$board$dice.rolled, die$new(color))
                      }
                    },
                    changeName = function(oldName, newName){
                      for (p in self$players){
                        if (p$name == oldName){
                          p$name <- newName
                          break
                        }
                      }
                    },
                    playersNames = function(){
                      names <- NULL
                      for (p in self$players){
                        names <- c(names, p$name)
                      }
                      return(names)
                    },
                    placeTile = function(type, num, name){
                      i <- 2
                      #print("selecting player 1")
                      player <- self$players[[1]]
                      currentName <- player$name
                      #print("finding player")
                      while(currentName != name){
                        player <- self$players[[i]]
                        currentName <- player$name
                        i <- i + 1
                      }

                      boardSpace <- self$board$spaces[[num]]
                      if (type == "Plus"){
                        player$plus.tile <- num
                        boardSpace$plus.tile <- TRUE
                      } else { #type == "Minus"
                        player$minus.tile <- num
                        boardSpace$minus.tile <- TRUE
                      }
                      boardSpace$tile.placed.by <- name
                    }
                  ))

#' Correctly orders colors for graphing
#'
#' @param subColors a subset of the full set of colors of camels
#' @return colors in correct order for the game
cleanColors <- function(subColors){
  #creates camel colors for graphing based on the list of colors provided
  #useful in graphing custom games when not all camels are on the board
  fullGraphColors <- c("blue", "darkgreen", "orange", "white", "yellow")
  fullCamelColors <- c("Blue", "Green", "Orange", "White", "Yellow")
  outputColors <- c()
  for(i in 1:5){
    if (fullCamelColors[i] %in% subColors){
      outputColors <-  c(outputColors, fullGraphColors[i])
    }
  }
  return(outputColors)
}

