#ifndef SIMULATOR_H
#define SIMULATOR_H

#include <Rcpp.h>
#include "Board.h"
#include "Game.h"


using namespace Rcpp;


class Simulator {
private:
  Board boardObject;
public:

  // Simulator(const Board & g);
//
  // Simulator(Game g);
  Simulator(const Board & g);

  // Simulator(int n);

  void SimTask(Board *b, int id, bool toEndLeg, Rcpp::CharacterVector *colors, Rcpp::IntegerVector *spaces, Rcpp::IntegerVector * heights, Rcpp::CharacterVector* simRankings);

  List simulateDecision(bool toEndLeg, int nSims); //if false sim to end game

};
RCPP_EXPOSED_CLASS(Simulator)


#endif

