#ifndef BOARD_H
#define BOARD_H

#include <Rcpp.h>
#include <list>
#include <vector>
#include <random>     // for random shuffle

#include <algorithm>
#include <string>
#include "Space.h"
#include "Die.h"
#include "Camel.h"

using namespace std;

class Board {
private:
  int nSpaces;
  std::vector<Space*> spaces;
  std::vector<Die> dice;
  // std::vector<Camel> camels;
  std::map<std::string, Camel*> camels;
  std::vector<std::string> colors;
  bool debug;
  std::vector<std::string> ranking;
public:
  Board();

  Board(int n, bool d = false);

  Board(const Board & b);

  int getNDiceRemaining();

  void resetDice();

  void initCamels();

  int getNCamels();

  void fillCamelPosArrays(Rcpp::CharacterVector *camelColors, Rcpp::IntegerVector *spaceArray, Rcpp::IntegerVector *heightArray, int start);

  Rcpp::DataFrame getCamelDF();

  std::string moveTurn();

  void generateRanking();

  std::vector<std::string> getRanking();

  Camel* getCamel(std::string color);

  void placePlusTile(int n, Player* p);

  void placeMinusTile(int n, Player* p);

  Space* getSpaceN(int n);

  std::vector<Die> getDice();

  void setDice(std::vector<Die>);

  int getFirstPlaceSpace();

  void progressToEndLeg();

  void progressToEndGame();

  void clearBoard();

  void createAddCamel(std::string color, int space);

  void addCustomCamel(std::string color, int space, bool diePresent, int nBetsLeft);

  // DataFrame getDiceDF();
};

RCPP_EXPOSED_CLASS(Board)
#endif
