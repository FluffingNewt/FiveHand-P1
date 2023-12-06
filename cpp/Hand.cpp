#include "Hand.h"
#include <iostream>
#include <algorithm>

/* Adds a card to the hand's list of cards.
   param: card - Card representing the input card */
void Hand::addCard(Card &card) {cards.push_back(card);}


/* Returns a string representation of the hand.
   return: string representing the hand object. */
std::string Hand::toString() {
    std::string list;

    for (size_t i = 1; i <= cards.size(); i++) {
        if (cards[i - 1].getRank() != 10) list += " ";

        list += cards[i - 1].toString();

        if (i == 0 || i % 5 != 0) list += " ";
    }

    if (handType == 0) return list;

    if (handType == 10) list += " - Royal Straight Flush";
    else if (handType == 9) list += " - Straight Flush";
    else if (handType == 8) list += " - Four of a Kind";
    else if (handType == 7) list += " - Full House";
    else if (handType == 6) list += " - Flush";
    else if (handType == 5) list += " - Straight";
    else if (handType == 4) list += " - Three of a Kind";
    else if (handType == 3) list += " - Two Pair";
    else if (handType == 2) list += " - Pair";
    else list += " - High Card";

    return list;
}


/* Compares this hand with another hand based on their ranks.
   Used to sort each hand type and tiebreakers accordingly.
   param: other - Hand representing the hand to be compared.
   return: int representing the which hand is greater or less than. */
int Hand::compareHand(Hand &other) {
    assessHand();
    other.assessHand();

    int typeComparison = (handType - other.handType);

    return compareHandHelper(other, typeComparison, 0);
}


/* Recursive helper method for the compare_hand method
   param: other - Hand representing the hands to compare to
   param: diff - int representing the difference of the hands in the current iteration
   param: pass - int representing the number for the current pass
   return: int representing the difference between the two hands */
int Hand::compareHandHelper(Hand &other, int diff, int pass) {
    if (diff != 0) return diff;

    Card thisBreaker = getTieBreakerCard(pass);
    Card otherBreaker = other.getTieBreakerCard(pass);

    int rankDiff = (thisBreaker.getRank() - otherBreaker.getRank());
    int suitDiff = (thisBreaker.getSuit() - otherBreaker.getSuit());

    if (pass < 2 && (handType == 2 || handType == 3)) {
        if (rankDiff == 0) {
            return compareHandHelper(other, rankDiff, pass + 1);
        }

        return rankDiff;
    }

    if (rankDiff == 0) return suitDiff;
    return rankDiff;
}


/* Analyzes the current collection of cards in the hand and determines its hand type.
   The sorted instance variable is updated to contain the cards sorted by rank.
   This method sets the handType instance variable to one of the predefined hand types:
   - 10 for Royal Straight Flush
   - 9 for Straight Flush
   - 8 for Four of a Kind
   - 7 for Full House
   - 6 for Flush
   - 5 for Straight
   - 4 for Three of a Kind
   - 3 for Two Pair
   - 2 for Pair
   - 1 for High Card */
void Hand::assessHand() {
    std::vector<Card> copy = deepCopy(cards);
    sorted = sortHand(copy);

    if (isRoyalStraightFlush()) {handType = 10;}
    else if (isStraightFlush()) handType = 9;
    else if (isFourOfAKind()) handType = 8;
    else if (isFullHouse()) handType = 7;
    else if (isFlush()) handType = 6;
    else if (isStraight()) handType = 5;
    else if (isThreeOfAKind()) handType = 4;
    else if (isTwoPair()) handType = 3;
    else if (isPair()) handType = 2;
    else handType = 1;
}


/* Determines if the hand is a royal straight flush.
   return: bool representing if the hand is an RSF. */
bool Hand::isRoyalStraightFlush() {
    std::vector<int> rankList = getRankList();
    return isStraightFlush() &&
           rankList[0] == 10 &&
           rankList[4] == 14;
}


/* Determines if the hand is a straight flush.
   return: bool representing if the hand is an SF. */
bool Hand::isStraightFlush() {
    return isStraight() && isFlush();
}


/* Determines if the hand is a straight flush.
   return: bool representing if the hand is an SF. */
bool Hand::isFourOfAKind() {
    std::vector<int> rankList = getRankList();
    return (rankList[0] == rankList[3]) ||
           (rankList[1] == rankList[4]);
}


/* Determines if the hand is a full house.
   return: bool representing if the hand is a FH. */
bool Hand::isFullHouse() {
    std::vector<int> rankList = getRankList();
    return (rankList[0] == rankList[1] && rankList[2] == rankList[4]) ||
           (rankList[0] == rankList[2] && rankList[3] == rankList[4]);
}


/* Determines if the hand is a flush.
   return: bool representing if the hand is a flush. */
bool Hand::isFlush() {
    int suit = sorted[0].getSuit();

    for (size_t i = 0; i < 4; i++) {
        if (sorted[i].getSuit() != suit) return false;
    }

    return sorted[4].getSuit() == suit;
}


/* Determines if the hand is a straight.
   return: bool representing if the hand is a straight. */
bool Hand::isStraight() {
    std::vector<int> rankList = getRankList();
    if (rankList[4] == 14 && rankList[1] == 2) {
        rankList[rankList.size() - 1] = 1;
        std::sort(rankList.begin(), rankList.end());
    }

    for (size_t i = 0; i < 4; i++) {
        if (rankList[i + 1] != rankList[i] + 1) {
            return false;
        }
    }

    return true;
}


/* Determines if the hand is a three of a kind.
   return: bool representing if the hand is a TOAK. */
bool Hand::isThreeOfAKind() {
    std::vector<int> rankList = getRankList();
    return (rankList[0] == rankList[2]) ||
           (rankList[1] == rankList[3]) ||
           (rankList[2] == rankList[4]);
}


/* Determines if the hand is a two pair.
   return: bool representing if the hand is a TP. */
bool Hand::isTwoPair() {
    std::vector<int> rankList = getRankList();
    return (rankList[0] == rankList[1] && rankList[2] == rankList[3]) ||
           (rankList[0] == rankList[1] && rankList[3] == rankList[4]) ||
           (rankList[1] == rankList[2] && rankList[3] == rankList[4]);
}


/* Determines if the hand is a pair.
   return: bool representing if the hand is a pair. */
bool Hand::isPair() {
    std::vector<int> rankList = getRankList();
    for (size_t i = 0; i < 4; i++) {
        if (rankList[i] == rankList[i + 1]) {
            return true;
        }
    }

    return false;
}


/* Determines the tie breaking card of the hand depending on its handType.
   param pass - int representing the pass number
   return: Card representing the tie-breaker card. */
Card Hand::getTieBreakerCard(int pass) {
    if (handType == 10) return sorted[4];

    // Straight Flush
    if (handType == 9)
        return (sorted[4].getRank() == 14 &&
                sorted[0].getRank() == 2) ?
               sorted[3] : sorted[4];

    // Four of a Kind
    if (handType == 8) return sorted[2];

    // Full House
    if (handType == 7) return sorted[2];

    // Flush
    if (handType == 6) return sorted[4];

    // Straight
    if (handType == 5) return sorted[4];

    // Three of a Kind
    if (handType == 4) return sorted[2];

    // Two Pair
    if (handType == 3) {
        std::vector<Card> pairList;

        for (size_t i = 1; i < sorted.size(); i++) {
            Card currentCard = sorted[i];
            Card previousCard = sorted[i - 1];

            if ((currentCard.getRank() - previousCard.getRank()) == 0) {
                pairList.push_back(currentCard);
            }
        }

        Card max = pairList[0];
        Card min = pairList[0];

        for (Card &card: pairList) {
            if (card.getRank() > max.getRank()) max = card;
            if (card.getRank() < min.getRank()) min = card;
        }

        if (pass == 0) return max;
        if (pass == 1) return min;
        return getKicker();
    }

    // Pair
    if (handType == 2) {
        Card ret;

        for (size_t i = 1; i < sorted.size(); i++) {
            Card currentCard = sorted[i];
            Card previousCard = sorted[i - 1];

            if ((currentCard.getRank() - previousCard.getRank()) == 0) {
                ret = currentCard;
                break;
            }
        }

        if (pass == 0) return ret;
        if (pass == 1) return getKicker();
    }
    // High Card
    return sorted[4];
}


/* Helper method to get a sorted list of ranks in the hand.
   return: vector representing the ranks in ascending order. */
std::vector<int> Hand::getRankList() {
    std::vector<int> rankList;
    rankList.reserve(cards.size());

    for (Card &card: cards) {
        rankList.push_back(card.getRank());
    }

    std::sort(rankList.begin(), rankList.end());

    return rankList;
}


/* Gets the kicker card for pairs and two pairs.
   return: Card representing the kicker card. */
Card Hand::getKicker() {
    std::vector<Card> nonPairList;

    for (size_t i = 1; i < sorted.size(); i++) {
        Card currentCard = sorted[i];
        Card previousCard = sorted[i - 1];

        if (currentCard.getRank() != previousCard.getRank()) {
            nonPairList.push_back(currentCard);
        }
    }

    Card max = nonPairList[0];

    for (Card &card: nonPairList) {
        if (card.getRank() > max.getRank()) {
            max = card;
        }
    }

    return max;
}


/* Returns a copy of an input list of cards
   param: list - vector representing the list to be copied
   return: vector representing the copied provided list */
std::vector<Card> Hand::deepCopy(std::vector<Card> &list) {
    std::vector<Card> copy;

    for (Card &card: list) {
        Card temp(card.getRank(), card.getSuit());
        copy.push_back(temp);
    }

    return copy;
}


/* Returns a sorted version of a provided hand
   param: list - vector representing the hand of cards to be sorted
   return: vector representing the sorted hand of cards */
std::vector<Card> Hand::sortHand(std::vector<Card> &list) {
    std::vector<Card> sortedList(list);

    for (size_t p = 0; p <= sortedList.size() - 2; p++) {
        for (size_t i = 0; i <= sortedList.size() - 2; i++) {
            if (sortedList[i].compareCard(sortedList[i + 1]) > 0) {
                Card t = sortedList[i + 1];
                sortedList[i + 1] = sortedList[i];
                sortedList[i] = t;
            }
        }
    }

    return sortedList;
}