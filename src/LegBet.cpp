#include <Rcpp.h>
#include <stack>
#include <memory>
#include "Player.h"
#include "LegBet.h"
using namespace Rcpp;



// Define space class

//' @name LegBet
//' @title Encapsulates a double
//' @description Type the name of the class to see its methods
//' @field new Constructor
//' @field mult Multiply by another Double object \itemize{
//' \item Paramter: other - The other Double object
//' \item Returns: product of the values
//' }
//' @export


LegBet::LegBet(std::string color, int v){
  camelColor = color;
  value = v;
}

void LegBet::makeBet(std::shared_ptr<Player> p) {
  person = p;
}

int LegBet::getValue(){
  return value;
}

int LegBet::evaluate(std::string first, std::string second){
  int change = 1;
  if(camelColor == first){
    change = value;
  } else if (camelColor == second){
    change = 1;
  } else {
    change = -1;
  }

  (*person).addCoins(change);
  return change;
}


// Approach 4: Module docstrings
//
RCPP_EXPOSED_CLASS(LegBet)
  RCPP_MODULE(legbet_cpp) {
    using namespace Rcpp;

    class_<LegBet>("LegBet")
      .constructor<std::string,int>()
      .method("evaluate", &LegBet::evaluate)
    ;
  }
