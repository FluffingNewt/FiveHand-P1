using System;
using System.Collections;
using System.Collections.Generic;

/* Represents a hand of playing cards.
   This class defines a hand object that can hold a collection of card objects.
   It implements the IComparable interface for comparing different hands.
   author: Davis Guest */
public class Hand
{

    public List<Card> Cards;
    public List<Card> Sorted;
    public int HandType;


    // Constructs a new Hand with two empty lists of cards and a default hand type of 0.
    public Hand()
    {
        Cards = new List<Card>();
        Sorted = new List<Card>();
        HandType = 0;
    }


    /* Adds a card to the hand's list of cards.
       param: card - Card representing the input card */
    public void AddCard(Card card)
    {
        Cards.Add(card);
    }
    

    /* Returns a string representation of the hand.
       Overrides the ToString method of the Parent class.
       return: string representing the hand object. */
    public override string ToString()
    {
        string list = "";

        for (int i = 1; i <= Cards.Count; i++)
        {
            if (Cards[i - 1].Rank != 10) list += " ";
            
            list += Cards[i - 1].ToString();
            
            if (i == 0 || i % 5 != 0) list += " ";
        }
        
        if (HandType == 0) return list;

        if (HandType == 10) list += " - Royal Straight Flush";
        else if (HandType == 9) list += " - Straight Flush";
        else if (HandType == 8) list += " - Four of a Kind";
        else if (HandType == 7) list += " - Full House";
        else if (HandType == 6) list += " - Flush";
        else if (HandType == 5) list += " - Straight";
        else if (HandType == 4) list += " - Three of a Kind";
        else if (HandType == 3) list += " - Two Pair";
        else if (HandType == 2) list += " - Pair";
        else list += " - High Card";
        
        return list;
    }
    

    /* Compares this hand with another hand based on their ranks.
       Used to sort each hand type and tiebreakers accordingly.
       param: other - Hand representing the hand to be compared.
       return: int representing the which hand is greater or less than. */
    public int CompareHand(Hand other)
    {
        AssessHand();
        other.AssessHand();

        int typeComparison =(HandType - other.HandType);

        return CompareHandHelper(other, typeComparison, 0);
    }

    /* Recursive helper method for the compare_hand method
       param: other - Hand representing the hands to compare to
       param: diff - int representing the difference of the hands in the current iteration
       param: pass - int representing the number for the current pass
       return: int representing the difference between the two hands */
    private int CompareHandHelper(Hand other, int diff, int pass)
    {
        if (diff != 0) return diff;

        Card thisBreaker = GetTieBreakerCard(pass);
        Card otherBreaker = other.GetTieBreakerCard(pass);

        int rankDiff = (thisBreaker.Rank - otherBreaker.Rank);
        int suitDiff = (thisBreaker.Suit - otherBreaker.Suit);

        if (pass < 2 && (HandType == 2 || HandType == 3))
        {
            if (rankDiff == 0)
            {
                return CompareHandHelper(other, rankDiff, pass + 1);
            }

            return rankDiff;
        }

        if (rankDiff == 0) return suitDiff;
        return rankDiff;
    }


    /* Analyzes the current collection of cards in the hand and determines its hand type.
       The Sorted instance variable is updated to contain the cards sorted by rank.
       This method sets the HandType instance variable to one of the predefined hand types:
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
    private void AssessHand() {
        Sorted = SortHand(DeepCopy(Cards));

        if (IsRoyalStraightFlush()) HandType = 10;
        else if (IsStraightFlush()) HandType = 9;
        else if (IsFourOfAKind()) HandType = 8;
        else if (IsFullHouse()) HandType = 7;
        else if (IsFlush()) HandType = 6;
        else if (IsStraight()) HandType = 5;
        else if (IsThreeOfAKind()) HandType = 4;
        else if (IsTwoPair()) HandType = 3;
        else if (IsPair()) HandType = 2;
        else HandType = 1;
    }
    
    /* Determines if the hand is a royal straight flush.
       return: bool representing if the hand is an RSF. */
    private bool IsRoyalStraightFlush()
    {
        List<int> rankList = GetRankList();
        return IsStraightFlush() &&
               rankList[0] == 10 &&
               rankList[4] == 14;
    }

    /* Determines if the hand is a straight flush.
       return: bool representing if the hand is an SF. */
    private bool IsStraightFlush()
    {
        return IsStraight() && IsFlush();
    }

    /* Determines if the hand is a straight flush.
       return: bool representing if the hand is an SF. */
    private bool IsFourOfAKind()
    {
        List<int> rankList = GetRankList();
        return (rankList[0] == rankList[3]) ||
               (rankList[1] == rankList[4]);
    }

    /* Determines if the hand is a full house.
       return: bool representing if the hand is a FH. */
    private bool IsFullHouse()
    {
        List<int> rankList = GetRankList();
        return (rankList[0] == rankList[1] && rankList[2] == rankList[4]) ||
               (rankList[0] == rankList[2] && rankList[3] == rankList[4]);
    }

    /* Determines if the hand is a flush.
       return: bool representing if the hand is a flush. */
    private bool IsFlush()
    {
        int suit = Sorted[0].Suit;
        
        for (int i = 0; i < 4; i++)
        {
            if (Sorted[i].Suit != suit) return false;
        }
        
        return Sorted[4].Suit == suit;
    }

    /* Determines if the hand is a straight.
       return: bool representing if the hand is a straight. */
    private bool IsStraight()
    {
        List<int> rankList = GetRankList();
        if (rankList.Contains(14) && rankList.Contains(2))
        {
            rankList[rankList.IndexOf(14)] = 1;
            rankList.Sort();
        }
        
        for (int i = 0; i < 4; i++)
        {
            if (rankList[i + 1] != rankList[i] + 1)
            {
                return false;
            }
        }
        
        return true;
    }

    /* Determines if the hand is a three of a kind.
       return: bool representing if the hand is a TOAK. */
    private bool IsThreeOfAKind()
    {
        List<int> rankList = GetRankList();
        return (rankList[0] == rankList[2]) ||
               (rankList[1] == rankList[3]) ||
               (rankList[2] == rankList[4]);
    }

    /* Determines if the hand is a two pair.
      return: bool representing if the hand is a TP. */
    private bool IsTwoPair()
    {
        List<int> rankList = GetRankList();
        return (rankList[0] == rankList[1] && rankList[2] == rankList[3]) ||
               (rankList[0] == rankList[1] && rankList[3] == rankList[4]) ||
               (rankList[1] == rankList[2] && rankList[3] == rankList[4]);
    }

    /* Determines if the hand is a pair.
      return: bool representing if the hand is a pair. */
    private bool IsPair()
    {
        List<int> rankList = GetRankList();
        for (int i = 0; i < 4; i++)
        {
            if (rankList[i] == rankList[i + 1])
            {
                return true;
            }
        }

        return false;
    }

    /* Determines the tie breaking card of the hand depending on its handType.
       param pass - int representing the pass number
       return: Card representing the tie-breaker card. */
    private Card GetTieBreakerCard(int pass)
    {
        if (HandType == 10) return Sorted[4];

        // Straight Flush
        if (HandType == 9) return (Sorted[4].Rank == 14 &&
                                        Sorted[0].Rank == 2) ?
                                        Sorted[3] : Sorted[4];

        // Four of a Kind
        if (HandType == 8) return Sorted[2];

        // Full House
        if (HandType == 7) return Sorted[2];

        // Flush
        if (HandType == 6) return Sorted[4];

        // Straight
        if (HandType == 5) return Sorted[4];

        // Three of a Kind
        if (HandType == 4) return Sorted[2];

        // Two Pair
        if (HandType == 3) {
            List<Card> pairList = new List<Card>();

            for (int i = 1; i < Sorted.Count; i++) {
                Card currentCard = Sorted[i];
                Card previousCard = Sorted[i - 1];

                if ((currentCard.Rank - previousCard.Rank) == 0) {
                    pairList.Add(currentCard);
                }
            }

            Card max = pairList[0];
            Card min = pairList[0];

            foreach (Card card in pairList) {
                if (card.Rank > max.Rank) max = card;
                if (card.Rank < min.Rank) min = card;
            }

            if (pass == 0) return max;
            if (pass == 1) return min;
            return GetKicker();
        }

        // Pair
        if (HandType == 2) {
            Card ret = null;

            for (int i = 1; i < Sorted.Count; i++) {
                Card currentCard = Sorted[i];
                Card previousCard = Sorted[i - 1];

                if ((currentCard.Rank - previousCard.Rank) == 0) {
                    ret = currentCard;
                    break;
                }
            }

            if (pass == 0) return ret;
            if (pass == 1) return GetKicker();
        }
        // High Card
        return Sorted[4];
    }

    /* Helper method to get a sorted list of ranks in the hand.
       return: List representing the ranks in ascending order. */
    private List<int> GetRankList()
    {
        List<int> rankList = new List<int>();

        foreach (Card card in Cards)
        {
            rankList.Add(card.Rank);
        }

        rankList.Sort();

        return rankList;
    }
    
    /* Gets the kicker card for pairs and two pairs.
       return: Card representing the kicker card. */
    private Card GetKicker()
    {
        List<Card> nonPairList = new List<Card>();

        for (int i = 1; i < Sorted.Count; i++)
        {
            Card currentCard = Sorted[i];
            Card previousCard = Sorted[i - 1];

            if (currentCard.Rank != previousCard.Rank)
            {
                nonPairList.Add(currentCard);
            }
        }

        Card max = nonPairList[0];
        
        foreach (Card card in nonPairList) {
            if (card.Rank > max.Rank) {
                max = card;
            }
        }

        return max;

    }

    /* Returns a copy of an input list of cards
       param: list - List representing the list to be copied
       return: List representing the copied provided list */
    private List<Card> DeepCopy(List<Card> list)
    {
        List<Card> copy = new List<Card>();
    
        foreach (Card card in list)
        {
            Card temp = new Card(card.Rank, card.Suit);
            copy.Add(temp);
        }
    
        return copy;
    }

    /* Returns a sorted version of a provided hand
       param: list - List representing the hand of cards to be sorted
       return: List representing the sorted hand of cards */
    private List<Card> SortHand(List<Card> list)
    {
        for (int p = 0; p <= list.Count - 2; p++)
        {
            for (int i = 0; i <= list.Count - 2; i++)
            {
                if (list[i].CompareCard(list[i + 1]) > 0)
                {
                    Card t = list[i + 1];
                    list[i + 1] = list[i];
                    list[i] = t;
                }
            }
        }


        return list;
    }
    
}