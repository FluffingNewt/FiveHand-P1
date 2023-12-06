from Card import Card
import random

# Representing a collection of a set of standard 52 playing cards, without a Joker.
# This class allows you to build a deck either randomly or from a file and provides
# methods to draw cards from the deck.
# author: Davis Guest
class Deck:
    
    # Initializes a new Deck with an empty list of cards and a default:
    # - deck type of -1
    # - duplicate of None
    def __init__(self):
        self.cards = []
        self.duplicate = None
        self.deck_type = -1


    # Returns a string representation of the deck.
    # return: string representing the deck object.
    def __str__(self):
        card_list = ""
        for i, card in enumerate(self.cards, start=1):
            if card.get_rank() != 10:
                card_list += " "

            card_list += str(card)

            if i == len(self.cards):
                break
            elif (i == 1 or i % 13 != 0) and self.deck_type == 0:
                card_list += ","
            elif (i == 1 or i % 5 != 0) and self.deck_type == 1:
                card_list += ","
            else:
                card_list += "\n"

        return card_list


    # Builds a random deck based on a standard deck of 52 playing cards without jokers.
    # Shuffles the deck to randomize the card order.
    def build_rand_deck(self):
        self.deck_type = 0

        for suit in range(4):
            for rank in range(2, 15):
                self.cards.append(Card(rank, suit))

        random.shuffle(self.cards)


    # Builds a deck based on an input file.
    # param: filename - String representing the file to build the deck from.
    def build_file_deck(self, filename):
        self.deck_type = 1

        with open(filename, "r") as file:
            for line in file:
                line_list = line.split(",")

                for s in line_list:
                    i = 1 if s[0] == ' ' else 0

                    if s[i] == '1':
                        rank = 10
                    elif s[i] == 'J':
                        rank = 11
                    elif s[i] == 'Q':
                        rank = 12
                    elif s[i] == 'K':
                        rank = 13
                    elif s[i] == 'A':
                        rank = 14
                    else:
                        rank = int(s[i])

                    if s[2] == 'D':
                        suit = 0
                    elif s[2] == 'C':
                        suit = 1
                    elif s[2] == 'H':
                        suit = 2
                    else:
                        suit = 3

                    for card in self.cards:
                        if card.get_rank() == rank and card.get_suit() == suit:
                            self.duplicate = card

                    self.cards.append(Card(rank, suit))

        file.close()


    # Draws a card from the deck, removing the first card.
    # return: Card representing the removed card.
    def draw_card(self): return self.cards.pop(0)


    # Gets the duplicate of the deck.
    # return: Card representing a duplicate in the deck.
    def get_duplicate(self): return self.duplicate
