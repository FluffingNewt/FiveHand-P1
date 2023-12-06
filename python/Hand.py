from Card import Card

# Represents a hand of playing cards.
# This class defines a hand object that can hold a collection of card objects.
# author: Davis Guest
class Hand:

    # Initializes a new hand with an empty list of cards, its sorted variant, and a default hand type of 0.
    def __init__(self):
        self.cards = []
        self.sorted = []
        self.hand_type = 0


    # Returns a string representation of the hand.
    # return: string representing the hand object.
    def __str__(self):
        card_list = ""

        for i in range(1, len(self.cards) + 1):
            if self.cards[i - 1].get_rank() != 10:
                card_list += " "

            card_list += str(self.cards[i - 1])

            if i == 0 or i % 5 != 0:
                card_list += " "

        if self.hand_type == 0:
            return card_list
        elif self.hand_type == 10:
            card_list += " - Royal Straight Flush"
        elif self.hand_type == 9:
            card_list += " - Straight Flush"
        elif self.hand_type == 8:
            card_list += " - Four of a Kind"
        elif self.hand_type == 7:
            card_list += " - Full House"
        elif self.hand_type == 6:
            card_list += " - Flush"
        elif self.hand_type == 5:
            card_list += " - Straight"
        elif self.hand_type == 4:
            card_list += " - Three of a Kind"
        elif self.hand_type == 3:
            card_list += " - Two Pair"
        elif self.hand_type == 2:
            card_list += " - Pair"
        else:
            card_list += " - High Card"

        return card_list


    # Adds a card to the hand's list of cards.
    # param: card - Card representing the input card
    def add_card(self, card): self.cards.append(card)


    # Compares this hand with another hand based on their ranks.
    # Used to sort each hand type and tiebreakers accordingly.
    # param: other - Hand representing the hand to be compared.
    # return: int representing the which hand is greater or less than.
    def compare_hand(self, other):
        self.assess_hand()
        other.assess_hand()

        type_comparison = self.hand_type - other.hand_type

        return self.compare_hand_helper(other, type_comparison, 0)


    # Recursive helper method for the compare_hand method
    # param: other - Hand representing the hands to compare to
    # param: diff - int representing the difference of the hands in the current iteration
    # param: pass_num - int representing the number for the current pass
    # return: int representing the difference between the two hands
    def compare_hand_helper(self, other, diff, pass_num):
        if diff != 0:
            return diff

        this_breaker = self.get_tiebreaker_card(pass_num)
        other_breaker = other.get_tiebreaker_card(pass_num)

        rank_diff = this_breaker.get_rank() - other_breaker.get_rank()
        suit_diff = this_breaker.get_suit() - other_breaker.get_suit()

        if pass_num < 2 and (self.hand_type == 2 or self.hand_type == 3):
            if rank_diff == 0:
                return self.compare_hand_helper(other, rank_diff, pass_num + 1)

            return rank_diff

        if rank_diff == 0:
            return suit_diff
        else:
            return rank_diff


    # Analyzes the current collection of cards in the hand and determines its hand type.
    # The sorted instance variable is updated to contain the cards sorted by rank.
    # This method sets the hand_type instance variable to one of the predefined hand types:
    # - 10 for Royal Straight Flush
    # - 9 for Straight Flush
    # - 8 for Four of a Kind
    # - 7 for Full House
    # - 6 for Flush
    # - 5 for Straight
    # - 4 for Three of a Kind
    # - 3 for Two Pair
    # - 2 for Pair
    # - 1 for High Card
    def assess_hand(self):
        self.sorted = sort_hand(deep_copy(self.cards))

        if self.is_royal_straight_flush():
            self.hand_type = 10
        elif self.is_straight_flush():
            self.hand_type = 9
        elif self.is_four_of_a_kind():
            self.hand_type = 8
        elif self.is_full_house():
            self.hand_type = 7
        elif self.is_flush():
            self.hand_type = 6
        elif self.is_straight():
            self.hand_type = 5
        elif self.is_three_of_a_kind():
            self.hand_type = 4
        elif self.is_two_pair():
            self.hand_type = 3
        elif self.is_pair():
            self.hand_type = 2
        else:
            self.hand_type = 1


    # Determines if the hand is a royal straight flush.
    # return: Boolean representing if the hand is an RSF.
    def is_royal_straight_flush(self):
        rank_list = self.get_rank_list()
        return self.is_straight_flush() and rank_list[0] == 10 and rank_list[4] == 14


    # Determines if the hand is a straight flush.
    # return: Boolean representing if the hand is an SF.
    def is_straight_flush(self):
        return self.is_straight() and self.is_flush()


    # Determines if the hand is a straight flush.
    # return: Boolean representing if the hand is an SF.
    def is_four_of_a_kind(self):
        rank_list = self.get_rank_list()
        return rank_list[0] == rank_list[3] or rank_list[1] == rank_list[4]


    # Determines if the hand is a full house.
    # return: Boolean representing if the hand is a FH.
    def is_full_house(self):
        rank_list = self.get_rank_list()
        return ((rank_list[0] == rank_list[1] and rank_list[2] == rank_list[4]) or
                (rank_list[0] == rank_list[2] and rank_list[3] == rank_list[4]))


    # Determines if the hand is a flush.
    # return: Boolean representing if the hand is a flush.
    def is_flush(self):
        suit = self.sorted[0].get_suit()

        for i in range(0, 4):
            if self.sorted[i].get_suit() != suit:
                return False

        return self.sorted[4].get_suit() == suit


    # Determines if the hand is a straight.
    # return: Boolean representing if the hand is a straight.
    def is_straight(self):
        rank_list = self.get_rank_list()

        if rank_list.__contains__(14) and rank_list.__contains__(2):
            rank_list[rank_list.index(14)] = 1
            rank_list.sort()

        for i in range(0, 4):
            if rank_list[i + 1] != rank_list[i] + 1:
                return False

        return True


    # Determines if the hand is a three of a kind.
    # return: Boolean representing if the hand is a TOAK.
    def is_three_of_a_kind(self):
        rank_list = self.get_rank_list()

        return (rank_list[0] == rank_list[2] or
                rank_list[1] == rank_list[3] or
                rank_list[2] == rank_list[4])


    # Determines if the hand is a two pair.
    # return: Boolean representing if the hand is a TP.
    def is_two_pair(self):
        rank_list = self.get_rank_list()

        return (rank_list[0] == rank_list[1] and rank_list[2] == rank_list[3] or
                rank_list[0] == rank_list[1] and rank_list[3] == rank_list[4] or
                rank_list[1] == rank_list[2] and rank_list[3] == rank_list[4])


    # Determines if the hand is a pair.
    # return: Boolean representing if the hand is a pair.
    def is_pair(self):
        rank_list = self.get_rank_list()

        for i in range(0, 4):
            if rank_list[i] == rank_list[i + 1]:
                return True

        return False


    # Determines the tie breaking card of the hand depending on its handType.
    # param pass_num - int representing the pass number
    # return: Card representing the tie-breaker card.
    def get_tiebreaker_card(self, pass_num):
        # Royal Straight Flush
        if self.hand_type == 10:
            return self.sorted[4]
        # Straight Flush
        elif self.hand_type == 9:
            if self.sorted[4].get_rank() == 14 and self.sorted[0].get_rank() == 2:
                return self.sorted[3]
            else:
                return self.sorted[4]
        # Four of a Kind
        elif self.hand_type == 8:
            return self.sorted[2]
        # Full House
        elif self.hand_type == 7:
            return self.sorted[2]
        # Flush
        elif self.hand_type == 6:
            return self.sorted[4]
        # Straight
        elif self.hand_type == 5:
            return self.sorted[4]
        # Three of a Kind
        elif self.hand_type == 4:
            return self.sorted[2]
        # Two Pair
        elif self.hand_type == 3:
            pair_list = []

            for i in range(1, len(self.sorted)):
                current_card = self.sorted[i]
                previous_card = self.sorted[i - 1]

                if current_card.get_rank() == previous_card.get_rank():
                    pair_list.append(current_card)

            max_pair = pair_list[0]
            min_pair = pair_list[0]

            for card in pair_list:
                if card.get_rank() > max_pair.get_rank():
                    max_pair = card
                if card.get_rank() < min_pair.get_rank():
                    min_pair = card

            if pass_num == 0:
                return max_pair
            elif pass_num == 1:
                return min_pair
            else:
                return self.get_kicker()
        # Pair
        elif self.hand_type == 2:
            ret = None

            for i in range(1, len(self.sorted)):
                current_card = self.sorted[i]
                previous_card = self.sorted[i - 1]

                if current_card.get_rank() == previous_card.get_rank():
                    ret = current_card
                    break

            if pass_num == 0:
                return ret
            elif pass_num == 1:
                return self.get_kicker()

        else:
            return self.sorted[4]


    # Helper method to get a sorted list of ranks in the hand.
    # return: list representing the ranks in ascending order.
    def get_rank_list(self):
        rank_list = []
        for card in self.cards:
            rank_list.append(card.get_rank())

        rank_list.sort()
        return rank_list


    # Gets the kicker card for pairs and two pairs.
    # return: Card representing the kicker card.
    def get_kicker(self):
        non_pair_list = []
        for i in range(1, len(self.sorted)):
            curr_card = self.sorted[i]
            prev_card = self.sorted[i - 1]

            if curr_card.get_rank() != prev_card.get_rank():
                non_pair_list.append(curr_card)

        max_card = non_pair_list[0]

        for card in non_pair_list:
            if card.get_rank() > max_card.get_rank():
                max_card = card

        return max_card


# Returns a copy of an input list of cards
# param: card_list - list representing the list to be copied
# return: list representing the copied provided list
def deep_copy(card_list):
    copy = []
    for card in card_list:
        temp = Card(card.get_rank(), card.get_suit())
        copy.append(temp)

    return copy


# Returns a sorted version of a provided hand
# param: card_list - list representing the hand of cards to be sorted
# return: list representing the sorted hand of cards
def sort_hand(card_list):
    for p in range(0, len(card_list) - 1):
        for i in range(0, len(card_list) - 1):
            if card_list[i].compare_card(card_list[i + 1]) > 0:
                temp = card_list[i + 1]
                card_list[i + 1] = card_list[i]
                card_list[i] = temp

    return card_list
