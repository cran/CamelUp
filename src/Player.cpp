#include <Rcpp.h>
#include <string>
#include "Player.h"

using namespace Rcpp;

//' @name Player
//' @title Encapsulates a double
//' @description Type the name of the class to see its
//' @field new Constructor
//' @field mult Multiply by another Double object \itemize{
//' \item Paramter: other - The other Double object
//' \item Returns: product of the values
//' }
//' @export
//'
Player::Player(std::string n){
  name = n;
  coins = 0;
}

Player::Player(const Player & p){
  name = p.name;
  coins = p.coins;
}

void Player::addCoins(int n){
  coins += n;
}

std::string Player::getName(){
  return name;
}

int Player::getCoins(){
  return coins;
}


void Player::setOverallFirst(std::string color){
  overallFirstPlaceColor = color;
}

void Player::setOverallLast(std::string color){
  overallLastPlaceColor = color;
}

std::string Player::getOverallFirst(){
  return overallFirstPlaceColor;
}

std::string Player::getOverallLast(){
  return overallLastPlaceColor;
}


// Approach 4: Module docstrings


  RCPP_MODULE(player_cpp) {

    class_<Player>("Player")
    .constructor<std::string>()
    .method("addCoins", &Player::addCoins)
    .method("getName", &Player::getName)
    .method("getCoins", &Player::getCoins)
    .method("setOverallFirst", &Player::setOverallFirst)
    .method("setOverallLast", &Player::setOverallLast)
    .method("getOverallFirst", &Player::getOverallFirst)
    .method("getOverallLast", &Player::getOverallLast)
    ;
  }
