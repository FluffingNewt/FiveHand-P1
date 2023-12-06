#include "FiveHand.h"
#include <iostream>

/* Starts a Five Hand game.
   Type of game is determined if there is an input file.
   Then determines the winning hands in descending order.
   param: file - string representing the file to build the deck from. */
void FiveHand::play(std::string file) {
    std::cout << "\n*** P O K E R   H A N D   A N A L Y Z E R ***\n" << std::endl;

    int gameType = (file == "") ? 0 : 1;

    if (gameType == 0) {
        std::cout <<
                  "\n*** USING RANDOMIZED DECK OF CARDS ***\n" <<
                  "\n*** Shuffled 52 card deck\n" <<
                  deck.toString() << std::endl;
    } else {
        std::cout <<
                  "\n*** USING TEST DECK ***\n" <<
                  "\n*** File: " << file << "\n" <<
                  deck.toString() << std::endl;
    }

   if (deck.getDuplicate() != NULL) {
       std::cout <<
                 "\n*** ERROR - DUPLICATED CARD FOUND IN DECK ***\n" <<
                 "\n*** DUPLICATE: " << deck.getDuplicate()->toString() << " ***\n" << std::endl;
       return;
   }

    drawCards(gameType);

    std::cout << "\n*** Here are the six hands..." << std::endl;

    printAllHands();

    if (gameType == 0) {
        std::cout <<
                  "\n*** Here is what remains in the deck...\n" <<
                  deck.toString() << std::endl;
    }

    std::cout << "\n--- WINNING HAND ORDER ---" << std::endl;

    sortHands();
    printAllHands();
    std::cout << std::endl;
}


/* Draws 30 cards to set up 6 hands of 5 cards.
   Alternates drawing cards among the hands.
   param: gameType - int representing if the hands should be drawn randomized or from a file input. */
void FiveHand::drawCards(int gameType) {
    Card temp;
    if (gameType == 0) {
        for (int i = 0, handNum = 0; i < 30; i++, handNum++) {
            if (handNum == 6) handNum = 0;
            temp = deck.drawCard();
            hands[handNum].addCard(temp);
        }
    } else {
        for (int i = 1, handNum = 0; i <= 30; i++) {
            temp = deck.drawCard();
            hands[handNum].addCard(temp);
            if (i % 5 == 0) handNum++;
        }
    }
}


// Prints all the hands to the console.
void FiveHand::printAllHands() {
    for (Hand &hand: hands) {
        std::cout << hand.toString() << std::endl;
    }
}


// Sorts the hands to the winning order
void FiveHand::sortHands() {
    for (int p = 0; p <= hands.size() - 2; p++) {
        for (int i = 0; i <= hands.size() - 2; i++) {
            if (hands[i].compareHand(hands[i + 1]) < 0) {
                Hand temp = hands[i + 1];
                hands[i + 1] = hands[i];
                hands[i] = temp;
            }
        }
    }
}


/* Main method for the FiveHand game.
   Initiates the game based on command line arguments.
   param: agrc - int representing the number of command line arguments.
   param: argv - string array representing command line arguments.v*/
int main(int argc, char *argv[]) {
    std::string file = (argc > 1) ? argv[1] : "";
    FiveHand game(file);
    game.play(file);

    return 0;
}




