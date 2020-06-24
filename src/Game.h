#ifndef GAME_H
#define GAME_H

#include <Rcpp.h>
#include <stack>
#include "Player.h"
#include "Board.h"
#include "LegBet.h"

using namespace Rcpp;


class Game {
private:
  std::vector<Player*> players;
  Board* board;
  std::map<std::string, std::stack<LegBet*>> legBets; // each color has a stack, all contained in a map
  std::vector<std::string> colors;
  std::vector<std::string> rankings;
  int currentPlayerIndex;
  std::vector<LegBet*> madeLegBets;
  bool isGameOver;
  int nSpaces;
  bool debug;

  std::stack<Player *> overallWinnerStack;
  std::stack<Player *> overallLoserStack;
public:
  Game();

  Game(int nSpaces, int nPlayers, bool d);

  Game(const Game & g);

  DataFrame getPurseDF();

  DataFrame getCamelDF();

  std::vector<std::string> getRanking();

  std::string takeTurnMove();

  void resetLegBets();

  DataFrame getLegBetDF();

  void takeTurnLegBet(std::string camelColor);

  int getNMadeLegBets();

  void evaluateLegBets();

  void endTurn();

  bool checkIsGameOver();

  void takeTurnPlaceTile(int n, bool plus);

  int getFirstPlaceSpace();

  void progressToEndGame();

  void takeTurnPlaceOverallWinner(std::string color);

  int getNOverallWinnersPlaced();

  void takeTurnPlaceOverallLoser(std::string color);

  int getNOverallLosersPlaced();

  void evaluateOverallBets();

  // void progressToEndLeg();

  Board * getBoard();

  Game newGameObj(Game g);

  DataFrame getDiceRemDF();
};


RCPP_EXPOSED_CLASS(Game)



#endif


