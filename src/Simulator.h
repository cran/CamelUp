#ifndef SIMULATOR_H
#define SIMULATOR_H

#include <Rcpp.h>
#include "Board.h"


using namespace Rcpp;


class Simulator {
private:
  Board boardObject;
public:

  Simulator(const Board & g);

  void SimTask(Board *b, int id, bool toEndLeg, Rcpp::CharacterVector *colors, Rcpp::IntegerVector *spaces, Rcpp::IntegerVector * heights, Rcpp::CharacterVector* simRankings);

  List simulateDecision(bool toEndLeg, int nSims); //if false sim to end game

};



#endif

