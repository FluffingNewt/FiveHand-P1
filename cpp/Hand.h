#ifndef HAND
#define HAND

#include <vector>
#include <string>
#include "Card.h"

/* Represents a hand of playing cards.
   This class defines a hand object that can hold a collection of card objects.
   author: Davis Guest */
class Hand {

private:

    std::vector<Card> cards;
    std::vector<Card> sorted;
    int handType;

    // Outer-Defined Class Methods //
    void assessHand();
    bool isRoyalStraightFlush();
    bool isStraightFlush();
    bool isFourOfAKind();
    bool isFullHouse();
    bool isFlush();
    bool isStraight();
    bool isThreeOfAKind();
    bool isTwoPair();
    bool isPair();
    int compareHandHelper(Hand& other, int diff, int pass);
    Card getTieBreakerCard(int pass);
    std::vector<int> getRankList();
    Card getKicker();
    std::vector<Card> deepCopy(std::vector<Card>& list);
    std::vector<Card> sortHand(std::vector<Card>& list);

public:

    /* Constructs a new Hand with two empty lists of cards and a default hand type of 0. */
    Hand() : cards(), sorted(), handType(0) {}


    // Outer-Defined Class Methods //
    void addCard(Card& card);
    std::string toString();
    int compareHand(Hand& other);
    
};


#endif
