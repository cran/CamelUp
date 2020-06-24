#include <Rcpp.h>
#include <vector>
#include <algorithm>
#include "Space.h"
#include "Board.h"
#include "Camel.h"
#include <random>     // for random shuffle
using namespace Rcpp;
using namespace std;
// Define board class

inline int randWrapper(const int n) { return floor(unif_rand()*n); }

//' @name Board
//' @title Encapsulates a double
//' @description Type the name of the class to see its methods
//' @field new Constructor
//' @field mult Multiply by another Double object \itemize{
//' \item Paramter: other - The other Double object
//' \item Returns: product of the values
//' }
//' @export

Board::Board(){}

Board::Board(int n, bool d){
  debug = d;
  nSpaces = n;
  colors = {"Green", "White", "Yellow", "Orange", "Blue"};

  int LengthNeeded = n + 1; // make sure there are enough spaces after th finish line
  // and index is equal to space number
  for(int i=0;i<LengthNeeded;i++){
    spaces.push_back(new Space(i));
  }

  resetDice();
  initCamels();
  generateRanking();
}

Board::Board(const Board & b){
  // Rcout << "copy board";
  colors = b.colors;
  nSpaces = b.nSpaces;
  Space * currentNewSpace;
  Space * currentOldSpace;
  Camel * currentCamel;
  std::stack<Camel*> tempCamelStack;
  std::string currentColor;
  int nCamelsHere;

  Player* temp = new Player("Temp");

  // std::vector<Space*> spaces;

  int LengthNeeded = nSpaces + 1;
  // Rcout << "Length Needed : \n";
  // Rcout << LengthNeeded;
  for(int i=0;i<LengthNeeded;i++){
    // Rcout << "Space: \n";
    // Rcout << i;
    currentOldSpace = b.spaces[i];
    // std::vector<std::string> camelsToCopy = (*currentOldSpace).getCamelStrings();
    nCamelsHere = (*currentOldSpace).getNCamels();
    currentNewSpace = new Space(i); // shouldn't need additional constructor?

    if((*currentOldSpace).getPlusTile()){
      (*currentNewSpace).setPlusTile(temp);
    }
    if((*currentOldSpace).getMinusTile()){
      (*currentNewSpace).setMinusTile(temp);
    }


    for(int j=0;j<nCamelsHere;j++){
      currentCamel = (*currentOldSpace).removeCamel();
      tempCamelStack.push(currentCamel);
    }
    // Rcout << "\n second for loop \n";
    for(int j=0;j<nCamelsHere;j++){
      currentCamel = tempCamelStack.top();
      tempCamelStack.pop();
      (*currentOldSpace).addCamel(currentCamel);
      currentColor = (*currentCamel).getColor();
      currentCamel = new Camel(currentColor);

      (*currentNewSpace).addCamel(currentCamel);
      camels[currentColor] = currentCamel;
    }
    // Rcout << "second for loop complete";


    spaces.push_back(currentNewSpace);
  }

  // Rcout << "\n copying dice \n";
  int nDiceToCopy = b.dice.size();
  for(int i=0; i<nDiceToCopy; i++){
    Die currentDie = b.dice[i];
    dice.push_back(Die(currentDie.getColor()));
  }

  //unsigned seed = 0;

  std::random_shuffle(dice.begin(), dice.end(), randWrapper);// need to shuffle dice
  // Rcout << "\n copying dice  complete \n";
  getRanking();
  // Rcout << "ranking complete";

  // Rcout << "\n done copying board \n";
}

int Board::getNDiceRemaining(){
  return dice.size();
}

void Board::resetDice(){ // can't define default arg twice
  int nCamels = colors.size();

  for(int i=0;i<nCamels;i++){
    dice.push_back(colors[i]);
  }

  //shuffle dice
  // this is necessary because R can't set this seed
  if(!debug){
    unsigned seed = 0;
    shuffle(dice.begin(), dice.end(), std::default_random_engine(seed)); //shuffle dice
  }
}

void Board::initCamels(){
  int space;
  for(int i=0;i<5;i++){
    Die currentDie = dice[i];
    std::string currentColor = currentDie.getColor();

    space = currentDie.roll();
    createAddCamel(currentColor, space);
  }

}

int Board::getNCamels(){
  return camels.size();
}

void Board::fillCamelPosArrays(Rcpp::CharacterVector *camelColors, Rcpp::IntegerVector *spaceArray, Rcpp::IntegerVector * heightArray, int start){
  // Rcout << "\n filling arrays \n";
  int nCamels = colors.size();
  int index;
  std::string currentColor;
  Camel * currentCamel;
  // Rcout << "entering for loop \n";
  for(int i=0;i<nCamels;i++){
    // Rcout << i;
    index = start + i;
    currentColor = colors[i];
    // Rcout << "camel to be fetched \n";
    if(camels.find(currentColor) != camels.end()){ // if camel is in camels
      currentCamel = camels[currentColor];
      // Rcout << "camel fetched";
      // Rcout << currentCamel;
      // Rcout << (*currentCamel).getColor();
      // Rcout << (*currentCamel).getSpace();
      // Rcout << (*currentCamel).getHeight();
      (*camelColors)[index] = (*currentCamel).getColor();
      (*spaceArray)[index] = (*currentCamel).getSpace();
      (*heightArray)[index] = (*currentCamel).getHeight();
    }
  }
}

DataFrame Board::getCamelDF(){
  // DataFrame df;

  Rcpp::CharacterVector * camelColors = new CharacterVector(5);
  Rcpp::IntegerVector * spaceVec = new IntegerVector(5);
  Rcpp::IntegerVector * heightVec = new IntegerVector(5);

  if(!camels.empty()){
    fillCamelPosArrays(camelColors, spaceVec, heightVec, 0);
  }


  DataFrame df = DataFrame::create(Named("Color") = *camelColors, Named("Space") = *spaceVec, Named("Height") = *heightVec);

  return df;

}

std::string Board::moveTurn(){
  if(dice.size() < 1){
    throw std::range_error("Trying to access dice when leg is over: See Board::moveTurn");
  }

  Die currentDie = dice.back();
  dice.pop_back();
  std::string camelColor = currentDie.getColor();
  int dieValue = currentDie.roll();
  // Rcout << "Die rolled \n";

  Camel * camelToMove = camels[camelColor];
  int currentSpaceNum = (*camelToMove).getSpace();
  int currentHeight = (*camelToMove).getHeight();
  // Rcout << "got currentHeight \n";

  Space * currentSpace = spaces[currentSpaceNum];
  int currentNCamels = (*currentSpace).getNCamels();
  // Rcout << "got currentNCamels \n";


  std::stack<Camel *> temp;

  for(int i=currentHeight; i<=currentNCamels; i++){
    temp.push((*currentSpace).removeCamel());
  }
  // Rcout << "create temp stack \n";
  /*
  for(int i=0; i<nSpaces; i++){
    Space* newSpace = spaces[i];
    // Rcout << (*newSpace).getPosition();
    // Rcout << "\n";
  }
  */
  int newSpaceNum = currentSpaceNum + dieValue;
  // Rcout << "values: \n";
  // Rcout << currentSpaceNum;
  // Rcout << "\n";
  // Rcout << dieValue;
  // Rcout << "\n";

  Space* newSpace = spaces[newSpaceNum];
  // Rcout << "newSpace position correct: \n";
  // Rcout << newSpaceNum;
  // Rcout << "\n newSpace position actual: \n";
  // Rcout << (*newSpace).getPosition();
  // Rcout << "\n tempsize: \n";
  // Rcout << temp.size();
  Player* p = (*newSpace).getTilePlacedBy(); // player that placed the relevant tile
  // Rcout << "tile found";
  //  account for tiles
  if((*newSpace).getPlusTile()){
    // Rcout << "(*newSpace).getPlusTile() \n";
    Space* newSpace = spaces[currentSpaceNum + dieValue + 1];
    // Rcout << (*newSpace).getPosition();
    (*newSpace).addCamelsTop(temp);
    (*p).addCoins(1);
  } else if((*newSpace).getMinusTile()){
    // Rcout << "if((*newSpace).getMinusTile()) \n";
    Space* newSpace = spaces[currentSpaceNum + dieValue - 1];
    // Rcout << (*newSpace).getPosition();
    (*newSpace).addCamelsBottom(temp);
    (*p).addCoins(1);
  } else {
    // // Rcout << "else \n";
    // // Rcout << (*newSpace).getPosition();
    (*newSpace).addCamelsTop(temp);
  }
  // Rcout << "camels added to new space \n";




  return camelColor;
}

void Board::generateRanking(){
  ranking.clear();
  for(int i=nSpaces;i>=0;i--){
    Space* currentSpace = spaces[i];
    int nCamelsHere = (*currentSpace).getNCamels();
    if(nCamelsHere > 0){
      std::stack<Camel*> temp;
      for(int i=0; i<nCamelsHere; i++){
        Camel* c = (*currentSpace).removeCamel();
        ranking.push_back((*c).getColor());
        temp.push(c);
      }

      for(int i=0; i<nCamelsHere; i++){
        Camel* c = temp.top();
        temp.pop();
        (*currentSpace).addCamel(c);
      }
    }
  }
}

std::vector<std::string> Board::getRanking(){
  generateRanking();
  return ranking;
}

Camel* Board::getCamel(std::string color){
  return camels[color];
}

void Board::placePlusTile(int n, Player* p){
  Space* relevantSpace = spaces[n];
  (*relevantSpace).setPlusTile(p);
}

void Board::placeMinusTile(int n, Player* p){
  Space* relevantSpace = spaces[n];
  (*relevantSpace).setMinusTile(p);
}

Space* Board::getSpaceN(int n){
  return spaces[n];
}

std::vector<Die> Board::getDice(){
  return dice;
}

void Board::setDice(std::vector<Die> d){
  dice = d;
}

int Board::getFirstPlaceSpace(){
  std::vector<std::string> ranking = getRanking();
  Camel* firstPlace = camels[ranking[0]];
  return (*firstPlace).getSpace();
}

void Board::progressToEndLeg(){
  int nDice = getNDiceRemaining();
  for(int i=0; i<nDice; i++){
    moveTurn();
  }
}

void Board::progressToEndGame(){
  // Game newGame = Game(*this);

  while(getFirstPlaceSpace()<17){
    // Rcout << "first place space:";
    // Rcout << getFirstPlaceSpace();
    // Rcout << "\n";
    if(getNDiceRemaining() == 0){
      resetDice();
    }
    moveTurn();
    // Rcout << "is game over? \n";
    // Rcout << checkIsGameOver();
    // Rcout << "\n";
  }
}

void Board::clearBoard(){
  // Space* currentSpace;
  int LengthNeeded = nSpaces + 1;
  spaces.clear();
  for(int i=0;i<LengthNeeded;i++){
    spaces.push_back(new Space(i));
  }

  camels.clear();
  dice.clear();
}


void Board::createAddCamel(std::string color, int space){
  // Rcout << color;
  // Rcout << "\n";
  // Rcout << space;
  // Rcout << "\n";
  Camel * currentCamel = new Camel(color);
  Space * currentSpace = spaces[space];
  // Rcout << (*currentSpace).getNCamels();
  // Rcout << "\n";
  (*currentSpace).addCamel(currentCamel);
  camels[color] = currentCamel;
}

void Board::addCustomCamel(std::string color, int space, bool diePresent, int nBetsLeft){
  createAddCamel(color, space);
  if(diePresent){
    dice.push_back(Die(color));
  }

  // unsigned seed = 0;
  // shuffle(dice.begin(), dice.end(), std::default_random_engine(seed)); //shuffle dice
  std::random_shuffle(dice.begin(), dice.end(), randWrapper);

}


// DataFrame Board::getDiceDF(){
//   int nDice = getNDiceRemaining();
//   std::vector<std::string> colors;
//   for(int i = 0; i < nDice; i++){
//     colors.push_back(dice[i].getColor());
//   }
//   DataFrame df = DataFrame::create(Named("Dice Remaining") = colors);
//   return df;
// }

RCPP_MODULE(board_cpp){
  class_<Board>("Board")
  .constructor<int, bool>()
  .constructor<const Board &>()
  .method("getNDiceRemaining", &Board::getNDiceRemaining)
  .method("getNCamels", &Board::getNCamels)
  .method("getCamelDF", &Board::getCamelDF)
  .method("moveTurn", &Board::moveTurn)
  .method("generateRanking", &Board::generateRanking)
  .method("getRanking", &Board::getRanking)
  .method("clearBoard", &Board::clearBoard)
  .method("placePlusTile", &Board::placePlusTile)
  .method("placeMinusTile", &Board::placeMinusTile)
  .method("addCustomCamel", &Board::addCustomCamel)
  // .method("getDiceDF", &Board::getDiceDF)
  ;
}
