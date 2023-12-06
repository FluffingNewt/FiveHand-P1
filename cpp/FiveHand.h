#ifndef FIVEHAND
#define FIVEHAND

#include <vector>
#include "Card.h"
#include "Hand.h"
#include "Deck.h"


/* Represents the game of Five Hand, a poker game with 6 hands.
   The game can be played with a randomized deck or a deck loaded from a file.
   author: Davis Guest */
class FiveHand {

private:

    Deck deck;
    std::vector<Hand> hands;

public:

    /* Constructs a new Five Hand game with a list of 6 empty hands and a deck of cards.
       If command line arguments are provided, it builds a file deck; otherwise, it builds a randomized deck.
       param: file - string representing the file to build the deck from. */
    FiveHand(std::string file) {
        hands.reserve(6);

        for (int i = 0; i < 6; i++) {
            hands.push_back(Hand());
        }

        if (!file.empty()) deck.buildFileDeck(file);
        else deck.buildRandDeck();
    }

    // Outer-Defined Class Methods //
    void play(std::string file);
    void drawCards(int gameType);
    void printAllHands();
    void sortHands();
};


#endif
