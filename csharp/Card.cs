using System;

/* Represents a playing card.
   This class defines a card object with a rank and suit.
   It implements the IComparable interface for comparing cards based on their rank.
   author: Davis Guest */
public class Card
{

    public int Rank { get; }
    public int Suit { get; }

    /* Constructs a new card with the specified rank and suit.
       param: r - int representing the card's rank.
       param: s - int representing the card's suit. */
    public Card(int r, int s)
    {
        Rank = r;
        Suit = s;
    }


    /* Returns a String representation of the card.
       Overrides the ToString method of the Parent class.
       return: string representing the card object. */
    public override string ToString()
    {
        String suitLabel = "";
        if (Suit == 0) suitLabel = "D";
        else if (Suit == 1) suitLabel = "C";
        else if (Suit == 2) suitLabel = "H";
        else if (Suit == 3) suitLabel = "S";

        String face = "";
        if (Rank == 11) face = "J";
        else if (Rank == 12) face = "Q";
        else if (Rank == 13) face = "K";
        else if (Rank == 14) face = "A";

        return (face != "") ? face + suitLabel : Rank + suitLabel;
    }


    /* Compares this card with another card based on their ranks.
       param: other - Card representing the card to be compared.
       return: int representing the difference between the two card's ranks. */
    public int CompareCard(Card other)
    {
        return Rank - other.Rank;
    }
}