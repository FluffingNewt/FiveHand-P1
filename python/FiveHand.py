from Hand import Hand
from Deck import Deck
import sys

# Represents the game of Five Hand, a poker game with 6 hands.
# The game can be played with a randomized deck or a deck loaded from a file.
# author: Davis Guest
class FiveHand:


    # Initializes a new Five Hand game with a list of 6 empty hands and a deck of cards.
    # If command line arguments are provided, it builds a file deck; otherwise, it builds a randomized deck.
    # param: file_name - String representing the file to build the deck from.
    def __init__(self, file_name):
        self.deck = Deck()
        self.hands = []

        for i in range(0, 6):
            self.hands.append(Hand())

        if len(file_name) != 0:
            self.deck.build_file_deck(file_name)
        else:
            self.deck.build_rand_deck()


    # Starts a Five Hand game.
    # Type of game is determined if there is an input file.
    # Then determines the winning hands in descending order.
    # param: file_name - String representing the file to build the deck from.
    def play(self, file_name):
        print("\n*** P O K E R   H A N D   A N A L Y Z E R ***\n")

        game_type = 0 if len(file_name) == 0 else 1

        if game_type == 0:
            print("\n*** USING RANDOMIZED DECK OF CARDS ***\n" +
                  "\n*** Shuffled 52 card deck\n" +
                  str(self.deck))

        else:
            print("\n*** USING TEST DECK ***\n" +
                  "\n*** File: " + file + "\n" +
                  str(self.deck))

        if self.deck.get_duplicate() != None:
            print("\n*** ERROR - DUPLICATED CARD FOUND IN DECK ***\n" +
                  "\n*** DUPLICATE: " + self.deck.get_duplicate() + " ***\n")
            return

        self.draw_cards(game_type)

        print("\n*** Here are the six hands...")

        self.print_all_hands()

        if game_type == 0:
            print("\n*** Here is what remains in the deck...\n" +
                  str(self.deck))

        print("\n--- WINNING HAND ORDER ---")

        self.sort_hands()
        self.print_all_hands()


    # Draws 30 cards to set up 6 hands of 5 cards.
    # Alternates drawing cards among the hands.
    # param: game_type - int representing if the hands should be drawn randomized or from a file input.
    def draw_cards(self, game_type):
        if game_type == 0:
            hand_num = 0
            for i in range(0, 30):
                if hand_num == 6:
                    hand_num = 0
                self.hands[hand_num].add_card(self.deck.draw_card())
                hand_num += 1
        else:
            hand_num = 0
            for i in range(1, 31):
                self.hands[hand_num].add_card(self.deck.draw_card())
                if i % 5 == 0:
                    hand_num += 1


    # Prints all the hands to the console.
    def print_all_hands(self):
        for hand in self.hands:
            print(str(hand))


    # Sorts the hands to the winning order
    def sort_hands(self):
        for p in range(0, len(self.hands) - 1):
            for i in range(0, len(self.hands) - 1):
                if self.hands[i].compare_hand(self.hands[i + 1]) < 0:
                    temp = self.hands[i + 1]
                    self.hands[i + 1] = self.hands[i]
                    self.hands[i] = temp


# Main Method Calls
file = sys.argv[1] if len(sys.argv) == 2 else ""
game = FiveHand(file)
game.play(file)