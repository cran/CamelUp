#include <Rcpp.h>
#include <string>
#include "Die.h"

using namespace Rcpp;

//' @name Die
//' @title Encapsulates a double
//' @description Type the name of the class to see its
//' @field new Constructor
//' @field mult Multiply by another Double object \itemize{
//' \item Paramter: other - The other Double object
//' \item Returns: product of the values
//' }
//' @export
//'
Die::Die(std::string c){
  color = c;
  value = 0;
}

Die::Die(const Die & d){
  color = d.color;
  value = d.value;
}

std::string Die::getColor() {
  return color;
}

int Die::getValue(){
  return value;
}

int Die::roll(){
  Rcpp::NumericVector sample = runif(1);
  double result = sum(sample)*3 + 1;
  value = (int) result;
  return (int)result;
}



// Approach 4: Module docstrings

RCPP_EXPOSED_CLASS(Die)
  RCPP_MODULE(die_cpp) {

    class_<Die>("Die")
    .constructor<std::string>()
    .method("getColor", &Die::getColor)
    .method("getValue", &Die::getValue)
    .method("roll", &Die::roll)
    ;
  }
