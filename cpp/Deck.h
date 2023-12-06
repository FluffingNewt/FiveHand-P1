#ifndef DECK
#define DECK

#include <string>
#include <vector>
#include "Card.h"

/* Representing a collection of a set of standard 52 playing cards, without a Joker.
   This class allows you to build a deck either randomly or from a file and provides
   methods to draw cards from the deck.
   author: Davis Guest */
class Deck {

private:

    std::vector<Card> cards;
    Card *duplicate;
    int deckType;

    // Outer-Defined Class Methods //
    std::vector <Card> shuffleDeck(std::vector<Card> deck);

public:

    /* Constructs a new Deck with an empty list of cards and a default deck type of -1. */
    Deck() : cards(), duplicate(NULL), deckType(-1) {}


    /* Gets the duplicate card of the deck.
       return: Card representing the duplicate card of the deck. */
    Card* getDuplicate() {return duplicate;}


    // Outer-Defined Class Methods //
    std::string toString();
    void buildRandDeck();
    void buildFileDeck(std::string& file);
    Card drawCard();
    std::vector<std::string> lineSplit(std::string s, char del);
    
};


#endif //PROJECT_1___C___DECK_H
