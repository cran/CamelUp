#ifndef LEGBET_H
#define LEGBET_H

#include <Rcpp.h>
#include <stack>
#include "Player.h"

using namespace Rcpp;


class LegBet {
private:
  int value;
  std::string camelColor;
  Player * person;
public:
  LegBet(std::string color, int v);

  void makeBet(Player * p);

  int getValue();

  int evaluate(std::string first, std::string second);
};
#endif
