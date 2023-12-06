# Represents a playing card.
# This class defines a card object with a rank and suit.
# author: Davis Guest
class Card:

    # Initializes a new card with the specified rank and suit.
    # param: r - int representing the card's rank.
    # param: s - int representing the card's suit.
    def __init__(self, rank, suit):
        self.rank = rank
        self.suit = suit


    # Returns a string representation of the card.
    # return: String representing the card object.
    def __str__(self):
        suit_label = ""
        if self.suit == 0:
            suit_label = "D"
        elif self.suit == 1:
            suit_label = "C"
        elif self.suit == 2:
            suit_label = "H"
        elif self.suit == 3:
            suit_label = "S"

        face = ""
        if self.rank == 11:
            face = "J"
        elif self.rank == 12:
            face = "Q"
        elif self.rank == 13:
            face = "K"
        elif self.rank == 14:
            face = "A"

        return str(self.rank) + suit_label if not face else face + suit_label


    # Compares this card with another card based on their ranks.
    # param: other - Card representing the card to be compared.
    # return: int representing the difference between the two card's ranks.
    def compare_card(self, other):
        return self.rank - other.rank


    # Gets the rank of the card.
    # return: int representing the rank of the card.
    def get_rank(self):
        return self.rank


    # Gets the suit of the card.
    # return: int representing the suit of the card.
    def get_suit(self):
        return self.suit