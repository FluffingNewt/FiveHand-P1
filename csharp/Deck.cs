using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;

/* Representing a collection of a set of standard 52 playing cards, without a Joker.
   This class allows you to build a deck either randomly or from a file and provides
   methods to draw cards from the deck.
   author: Davis Guest */
public class Deck
{

    public List<Card> Cards;
    public Card Duplicate { get; set; }
    public int DeckType;

    /* Constructs a new Deck with an empty list of cards and a default deck type of -1. */
    public Deck()
    {
        Cards = new List<Card>();
        DeckType = -1;
    }
    

    /* Returns a string representation of the deck.
       Overrides the ToString method of the Parent class.
       return: string representing the deck object. */
    public override string ToString()
    {
        string list = "";
        
        for (int i = 1; i <= Cards.Count; i++) {
            if (Cards[i - 1].Rank != 10) list += " ";
            
            list += Cards[i - 1];
            
            if (i == Cards.Count) break;
            else if ((i == 0 || i % 13 != 0) && DeckType == 0) list += ",";
            else if ((i == 0 || i % 5 != 0) && DeckType == 1) list += ",";
            else list += "\n";
        }

        return list;
    }


    /* Builds a random deck based on a standard deck of 52 playing cards without jokers.
       Shuffles the deck to randomize the card order. */
    public void BuildRandDeck()
    {
        DeckType = 0;

        for (int suit = 0; suit <= 3; suit++) {
            for (int rank = 2; rank <= 14; rank++) {
                Cards.Add(new Card(rank, suit));
            }
        }
        
        Cards = ShuffleDeck(Cards);
    }


    /* Builds a deck based on an input file.
       param: file - String representing the file to build the deck from. */
    public void BuildFileDeck(string file)
    {
        DeckType = 1;

        string[] lineList = File.ReadAllLines(file);
        
        foreach (string line in lineList)
        {
            string[] cards = line.Split(",");

            foreach (string card in cards)
            {
                int i = (card[0] == ' ') ? 1 : 0;

                int rank = 0;
                if (card[i] == '1') rank = 10;
                else if (card[i] == 'J') rank = 11;
                else if (card[i] == 'Q') rank = 12;
                else if (card[i] == 'K') rank = 13;
                else if (card[i] == 'A') rank = 14;
                else rank = (int)Char.GetNumericValue(card, i);

                int suit = 0;
                if (card[2] == 'D') suit = 0;
                else if (card[2] == 'C') suit = 1;
                else if (card[2] == 'H') suit = 2;
                else suit = 3;

                foreach (Card c in Cards)
                {
                    if (c.Rank == rank && c.Suit == suit)
                    {
                        Duplicate = c;
                    }
                }

                Cards.Add(new Card(rank, suit));
            }
        }
    }


    /* Draws a card from the deck, removing the first card.
       return: Card representing the removed card. */
    public Card DrawCard()
    {
        Card removed = Cards[0];
        Cards.RemoveAt(0);
        return removed;
    }


    /* Returns a shuffled version of a provided deck.
       param: deck - List representing the deck to be shuffled.
       return: List representing the shuffled deck. */
    private List<Card> ShuffleDeck(List<Card> deck)
    {
        Random rng = new Random();
        int n = deck.Count;

        while (n > 1)
        {
            n--;
            int k = rng.Next(n + 1);
            Card value = deck[k];
            deck[k] = deck[n];
            deck[n] = value;
        }

        return deck;
    }
}