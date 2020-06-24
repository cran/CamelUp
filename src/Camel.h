#ifndef CAMEL_H
#define CAMEL_H

#include <Rcpp.h>
#include <string>

// define camel class
class Camel {
private:
  std::string color;
  int space;
  int height;

public:
  Camel();

  Camel(std::string c);

  Camel(const Camel&);

  std::string getColor();

  int getSpace();

  int getHeight();

  void setSpace(int n);

  void setHeight(int n);

  Camel duplicate();

};
#endif
