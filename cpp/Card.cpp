#include "Card.h"

/* Returns a string representation of the card.
   return: string representing the card object. */
std::string Card::toString() {
    std::string suitLabel;
    if (suit == 0) suitLabel = "D";
    else if (suit == 1) suitLabel = "C";
    else if (suit == 2) suitLabel = "H";
    else if (suit == 3) suitLabel = "S";

    std::string face;
    if (rank == 11) face = "J";
    else if (rank == 12) face = "Q";
    else if (rank == 13) face = "K";
    else if (rank == 14) face = "A";
    return (!face.empty()) ? face + suitLabel : std::to_string(rank) + suitLabel;
}


/* Compares this card with another card based on their ranks.
   param: other - Card representing the card to be compared.
   return: int representing the difference between the two card's ranks. */
int Card::compareCard(Card &other) {
    return rank - other.rank;
}