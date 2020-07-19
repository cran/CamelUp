#ifndef GAME_H
#define GAME_H

#include <Rcpp.h>
#include <stack>
#include <memory>
#include "Player.h"
#include "Board.h"
#include "LegBet.h"

using namespace Rcpp;


class Game {
private:
  std::vector<std::shared_ptr<Player>> players;
  shared_ptr<Board> board;
  std::map<std::string, std::stack<std::shared_ptr<LegBet>>> legBets; // each color has a stack, all contained in a map
  std::vector<std::string> colors;
  std::vector<std::string> rankings;
  int currentPlayerIndex;
  std::vector<std::shared_ptr<LegBet>> madeLegBets;
  bool isGameOver;
  int nSpaces;
  bool debug;

  std::stack<std::shared_ptr<Player>> overallWinnerStack;
  std::stack<std::shared_ptr<Player>> overallLoserStack;
public:
  Game();

  Game(int nSpaces, int nPlayers, bool d);

  Game(const Game & g);

  ~Game(){}

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

  std::shared_ptr<Board> getBoardPtr();

  Board getBoard();

  Game newGameObj(Game g);

  DataFrame getDiceRemDF();
};


RCPP_EXPOSED_CLASS(Game)



#endif


