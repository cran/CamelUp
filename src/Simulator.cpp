#include <Rcpp.h>
#include "Simulator.h"
#include "Board.h"


using namespace Rcpp;

// Define space class

//' @name Simulator
//' @title Encapsulates a double
//' @description Type the name of the class to see its methods
//' @field new Constructor
//' @field mult Multiply by another Double object \itemize{
//' \item Paramter: other - The other Double object
//' \item Returns: product of the values
//' }
//' @export


Simulator::Simulator(const Board & b){
  boardObject = Board(b);
}

void Simulator::SimTask(Board *b, int id, bool toEndLeg, Rcpp::CharacterVector *colors, Rcpp::IntegerVector *spaces, Rcpp::IntegerVector * heights, Rcpp::CharacterVector* simRankings){
  if(toEndLeg){
    (*b).progressToEndLeg();
  } else {
    (*b).progressToEndGame();
  }

  int start = 5*id;

  (*b).fillCamelPosArrays(colors, spaces, heights, start); // five entries per sim

  std::vector<std::string> ranking = (*b).getRanking();
  for(int i=0; i<5; i++){ // iterate through camels
    (*simRankings)[start + i] = ranking[i];
  }

}

List Simulator::simulateDecision(bool toEndLeg, int nSims){
  // Rcout << "function called";
  int nCamels = 5;
  int vecLength = nSims*nCamels;
  Board * boardPtr = &boardObject;

  Rcpp::CharacterVector *camelColors = new CharacterVector(vecLength);
  Rcpp::IntegerVector *spaceVec = new IntegerVector(vecLength);
  Rcpp::IntegerVector *heightVec = new IntegerVector(vecLength);

  // Rcpp::CharacterVector *firstPlace = new CharacterVector(nSims);
  // Rcpp::CharacterVector *secondPlace = new CharacterVector(nSims);
  // Rcpp::CharacterVector *thirdPlace = new CharacterVector(nSims);
  // Rcpp::CharacterVector *fourthPlace = new CharacterVector(nSims);
  // Rcpp::CharacterVector *lastPlace = new CharacterVector(nSims);

  Rcpp::CharacterVector *simRankings = new CharacterVector(5*nSims); // num camels times num sims


  std::vector<Board> duplicateGames;
  for(int i=0; i<nSims;i++){
    duplicateGames.push_back(Board(*boardPtr));
  }


  for(int i=0; i<nSims; i++){
    Board tempBoard = duplicateGames[i];
    SimTask(&tempBoard, i, toEndLeg, camelColors, spaceVec, heightVec, simRankings);

  }


  DataFrame positionDF = DataFrame::create(Named("Color") = *camelColors, Named("Space") = *spaceVec, Named("Height") = *heightVec);
  DataFrame rankingDF = DataFrame::create(Named("Color") = *simRankings); // it's clear here that the ordering is 1st through 5th repeated nSims times
  return List::create(Named("position") = positionDF, Named("ranking") = rankingDF);
}


//
RCPP_EXPOSED_CLASS(Simulator)
  RCPP_MODULE(simulator_cpp) {
    using namespace Rcpp;

    class_<Simulator>("Simulator")
      .constructor<Board>()
      .method("simulateDecision", &Simulator::simulateDecision)
    ;
  }
