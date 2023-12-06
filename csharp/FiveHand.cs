using System;
using System.Collections;
using System.Collections.Generic;

/* Represents the game of Five Hand, a poker game with 6 hands.
   The game can be played with a randomized deck or a deck loaded from a file.
   author: Davis Guest */
public class FiveHand
{
    public Deck Deck;
    public List<Hand> Hands;

    /* Constructs a new Five Hand game with a list of 6 empty hands and a deck of cards.
       If command line arguments are provided, it builds a file deck; otherwise, it builds a randomized deck.
       param: file - string representing the file to build the deck from. */
    public FiveHand(string file)
    {
        Deck = new Deck();
        Hands = new List<Hand>();

        for (int i = 0; i < 6; i++)
        {
            Hands.Add(new Hand());
        }

        if (file != "") Deck.BuildFileDeck(file);
        else Deck.BuildRandDeck();
    }
    
    /* Starts a Five Hand game.
       Type of game is determined if there is an input file.
       Then determines the winning hands in descending order.
       param: file - string representing the file to build the deck from. */
    public void Play(string file) {
        Console.WriteLine("\n*** P O K E R   H A N D   A N A L Y Z E R ***\n");

        int gameType = (file == "") ? 0 : 1;

        if (gameType == 0) {
            Console.WriteLine(
                "\n*** USING RANDOMIZED DECK OF CARDS ***\n" +
                "\n*** Shuffled 52 card deck\n" +
                Deck
            );

        } else {
            Console.WriteLine(
                "\n*** USING TEST DECK ***\n" +
                "\n*** File: " + file + "\n" +
                Deck
            );
        }

        if (Deck.Duplicate != null) {
            Console.WriteLine(
                "\n*** ERROR - DUPLICATED CARD FOUND IN DECK ***\n" +
                "\n*** DUPLICATE: " + Deck.Duplicate + " ***\n"
            );
            return;
        }

        DrawCards(gameType);

        Console.WriteLine("\n*** Here are the six hands...");

        PrintAllHands();

        if (gameType == 0) {
            Console.WriteLine(
                "\n*** Here is what remains in the deck...\n" +
                Deck
            );
        }

        Console.WriteLine("\n--- WINNING HAND ORDER ---");

        SortHands();
        PrintAllHands();
        Console.WriteLine();
    }


    /* Draws 30 cards to set up 6 hands of 5 cards.
       Alternates drawing cards among the hands.
       param: gameType - int representing if the hands should be drawn randomized or from a file input. */
    private void DrawCards(int gameType)
    {
        if (gameType == 0) {
            for (int i = 0, handNum = 0; i < 30; i++, handNum++) {
                if (handNum == 6) handNum = 0;
                Hands[handNum].AddCard(Deck.DrawCard());
            }

        } else {
            for (int i = 1, handNum = 0; i <= 30; i++) {
                Hands[handNum].AddCard(Deck.DrawCard());
                if (i % 5 == 0) handNum++;
            }
        }
    }
    
    // Prints all the hands to the console.
    private void PrintAllHands()
    {
        foreach (Hand hand in Hands)
        {
            Console.WriteLine(hand.ToString());
        }
    }

    // Sorts the hands to the winning order
    private void SortHands()
    {
        for (int p = 0; p <= Hands.Count - 2; p++)
        {
            for (int i = 0; i <= Hands.Count - 2; i++)
            {
                if (Hands[i].CompareHand(Hands[i + 1]) < 0)
                {
                    Hand t = Hands[i + 1];
                    Hands[i + 1] = Hands[i];
                    Hands[i] = t;
                }
            }
        }
    }

    /* Main method for the FiveHand game.
       Initiates the game based on command line arguments.
       param: args - string array representing command line arguments.*/
    public static void Main(string[] args)
    {
        string file = (args.Length > 0) ? args[0] : "";
        FiveHand game = new FiveHand(file);
        game.Play(file);
    }
}