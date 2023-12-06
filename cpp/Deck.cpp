#include "Deck.h"
#include <fstream>
#include <iostream>
#include <sstream>

/* Returns a string representation of the deck.
   return: string representing the deck object. */
std::string Deck::toString() {
    std::string list;

    for (size_t i = 1; i <= cards.size(); i++) {
        if (cards[i - 1].getRank() != 10) list += " ";

        list += cards[i - 1].toString();

        if (i == cards.size()) break;
        else if ((i == 0 || i % 13 != 0) && deckType == 0) list += ",";
        else if ((i == 0 || i % 5 != 0) && deckType == 1) list += ",";
        else list += "\n";
    }

    return list;
}


/* Builds a random deck based on a standard deck of 52 playing cards without jokers.
   Shuffles the deck to randomize the card order. */
void Deck::buildRandDeck() {
    deckType = 0;

    for (int suit = 0; suit <= 3; suit++) {
        for (int rank = 2; rank <= 14; rank++) {
            cards.push_back(Card(rank, suit));
        }
    }

    cards = shuffleDeck(cards);
}


/* Builds a deck based on an input file.
   Stops code if an invalid file name is provided
   param: file - string representing the file to build the deck from. */
void Deck::buildFileDeck(std::string &file) {
    deckType = 1;

    std::ifstream inputFile(file);

    if (!inputFile.is_open()) {
        std::cerr << "Failed to open file: " << file << std::endl;
        return;
    }

    std::string line;
    while (inputFile) {
        std::getline(inputFile, line);
        std::vector<std::string> lineList = lineSplit(line, ',');

        for (std::string s : lineList) {
            int i = (s[0] == ' ') ? 1 : 0;

            int rank;
            if (s[i] == '1') rank = 10;
            else if (s[i] == 'J') rank = 11;
            else if (s[i] == 'Q') rank = 12;
            else if (s[i] == 'K') rank = 13;
            else if (s[i] == 'A') rank = 14;
            else rank = int(s[i]) - 48;

            int suit;
            if (s[2] == 'D') suit = 0;
            else if (s[2] == 'C') suit = 1;
            else if (s[2] == 'H') suit = 2;
            else suit = 3;

            for (Card &c: cards) {
                if (c.getRank() == rank && c.getSuit() == suit) {
                    duplicate = &c;
                }
            }

            cards.push_back(Card(rank, suit));
        }
    }

    inputFile.close();
}


/* Draws a card from the deck, removing the first card.
   return: Card representing the removed card. */
Card Deck::drawCard() {
    Card removed = cards[0];
    cards.erase(cards.begin());
    return removed;
}


/* Returns a shuffled version of a provided deck.
   param: deck - vector representing the deck to be shuffled.
   return: vector representing the shuffled deck. */
std::vector<Card> Deck::shuffleDeck(std::vector<Card> deck) {
    srand(static_cast<unsigned int>(time(nullptr)));
    int n = deck.size();

    while (n > 1) {
        n--;
        int k = rand() % (n + 1);
        Card value = deck[k];
        deck[k] = deck[n];
        deck[n] = value;
    }

    return deck;
}


/* Returns a vector of a string that has been split by a provided separator
   param: s - string representing the string to be split
   param: del - char representing the separator
   return: vector representing the split line
*/
std::vector<std::string> Deck::lineSplit(std::string s, char del) {
    std::vector<std::string> ret;
    std::stringstream ss(s);
    std::string word;

    while (!ss.eof()) {
        getline(ss, word, del);
        ret.push_back(word);
    }
    
    return ret;
}