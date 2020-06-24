#include <Rcpp.h>
#include <stack>
#include "Space.h"
#include "Camel.h"
#include "Player.h"

using namespace Rcpp;



// Define space class

//' @name Space
//' @title Encapsulates a double
//' @description Type the name of the class to see its methods
//' @field new Constructor
//' @field mult Multiply by another Double object \itemize{
//' \item Paramter: other - The other Double object
//' \item Returns: product of the values
//' }
//' @export

Space::Space(){}

Space::Space(int pos){
  position = pos;
  nCamels = 0;
  plusTile = false;
  minusTile = false;
  tilePlacedBy = new Player("");
}

Space::Space(Space & s){
  position = s.position;
  nCamels = 0;

  // int nCamelsHere = s.nCamels;
  // std::vector<std::string> camelsToCopy = s.getCamelStrings();
  // for(int i=nCamelsHere;i>0;i--){
  //   addCamel(new Camel(camelsToCopy[i]));
  // }
}

int Space::getPosition() {
  return position;
}

void Space::addCamel(Camel * c){
  camels.push(c);
  nCamels += 1;
  (*c).setHeight(nCamels);
  (*c).setSpace(position);
}

int Space::getNCamels(){
  return nCamels;
}

Camel * Space::removeCamel(){
  Camel * result = camels.top();
  camels.pop();
  nCamels -= 1;
  return result;
}

bool Space::getPlusTile(){
  return plusTile;
}

bool Space::getMinusTile(){
  return minusTile;
}

// add camels to top of stack for when camels move forward
void Space::addCamelsTop(std::stack<Camel*> camelsToMove){
  int nCamelsToMove = camelsToMove.size();
  for(int i=0; i<nCamelsToMove; i++){
    Camel * c = camelsToMove.top();
    camelsToMove.pop();
    addCamel(c);
  }
}

// add camels to bottom of stack for when camels move backward
// this funciton is untested
void Space::addCamelsBottom(std::stack<Camel*> camelsToMove){
  int nCamels = getNCamels();
  std::stack<Camel*> temp;
  for(int i=0; i<nCamels; i++){
    Camel * c = removeCamel();
    temp.push(c);
  }


  int nCamelsToMove = camelsToMove.size();
  for(int i=0; i<nCamelsToMove; i++){
    Camel * c = camelsToMove.top();
    camelsToMove.pop();
    addCamel(c);
  }

  for(int i=0; i<nCamels; i++){
    Camel * c = temp.top();
    temp.pop();
    addCamel(c);
  }
}

void Space::setPlusTile(Player* p){
  plusTile = true;
  setTilePlacedBy(p);
}

void Space::setMinusTile(Player* p){
  minusTile = true;
  setTilePlacedBy(p);
}

void Space::setTilePlacedBy(Player* p){
  tilePlacedBy = p;
}

Player* Space::getTilePlacedBy(){
  return tilePlacedBy;
}

std::vector<Camel *>  Space::getCamelPointers(){
  std::stack<Camel *> tempCamelStack;
  Camel* currentCamel;
  std::vector<Camel *> result;
  for(int i=0;i<nCamels;i++){
    currentCamel = camels.top();
    tempCamelStack.push(currentCamel);
    camels.pop();
  }

  for(int i=0;i<nCamels;i++){
    currentCamel = tempCamelStack.top();
    tempCamelStack.pop();
    addCamel(currentCamel);
    result.push_back(currentCamel);
  }
  return result;
}

std::vector<std::string>  Space::getCamelStrings(){
  std::stack<Camel *> tempCamelStack;
  Camel* currentCamel;
  std::vector<std::string> result;
  for(int i=0;i<nCamels;i++){
    currentCamel = camels.top();
    tempCamelStack.push(currentCamel);
    camels.pop();
  }

  for(int i=0;i<nCamels;i++){
    currentCamel = tempCamelStack.top();
    tempCamelStack.pop();
    addCamel(currentCamel);
    result.push_back((*currentCamel).getColor());
  }
  return result;
}

void Space::clearSpace(){
  for(int i=0;i<nCamels;i++){
    removeCamel();
  }
}
// int Space::testAddCamel(){
//   Camel b = Camel("Blue");
//   Camel g = Camel("Green");
//   addCamel(b);
//   addCamel(g);
//   // result.push_back(g.getColor());
//
//   return g.getHeight();
// }

// Approach 4: Module docstrings
//
RCPP_EXPOSED_CLASS(Space)
  RCPP_MODULE(space_cpp) {
    using namespace Rcpp;

    class_<Space>("Space")
      .constructor<int>()
      .method("getPosition", &Space::getPosition)
      .method("getNCamels", &Space::getNCamels)
      .method("getPlusTile", &Space::getPlusTile)
      .method("getMinusTile", &Space::getMinusTile)
      // .method("testAddCamel", &Space::testAddCamel)
    ;
  }
