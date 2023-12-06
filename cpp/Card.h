#ifndef CARD
#define CARD

#include <string>

/* Represents a playing card.
   This class defines a card object with a rank and suit.
   author: Davis Guest */
class Card {

private:

    int rank;
    int suit;

public:

    /* Constructs a new empty card. */
    Card() : rank(), suit() {}


    /* Constructs a new card with the specified rank and suit.
       param: r - int representing the card's rank.
       param: s - int representing the card's suit. */
    Card(int r, int s) : rank(r), suit(s) {}


    /* Gets the rank of the card.
       return: int - representing the rank of the card. */
    int getRank() {return rank;}


    /* Gets the suit of the card.
       return: int - representing the suit of the card. */
    int getSuit() {return suit;}


    // Outer-Defined Class Methods //
    std::string toString();
    int compareCard(Card& other);

};


#endif
