#ifndef LEGBET_H
#define LEGBET_H

#include <Rcpp.h>
#include <stack>
#include <memory>
#include "Player.h"

using namespace Rcpp;


class LegBet {
private:
  int value;
  std::string camelColor;
  std::shared_ptr<Player> person;
public:
  // ~LegBet();
  LegBet(std::string color, int v);

  // ~LegBet();

  void makeBet(std::shared_ptr<Player> p);

  int getValue();

  int evaluate(std::string first, std::string second);
};
#endif
