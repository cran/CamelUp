#ifndef DIE_H
#define DIE_H

#include <Rcpp.h>
#include <string>

// Define die class


class Die {
private:
  std::string color;
  int value;
public:
  Die(std::string c);

  Die(const Die & d);

  std::string getColor() ;

  int getValue();

  int roll();
};

#endif

