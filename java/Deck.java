import java.util.Collections;
import java.util.ArrayList;
import java.util.List;
import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

/**
 * Representing a collection of a set of standard 52 playing cards, without a Joker.
 * This class allows you to build a deck either randomly or from a file and provides
 * methods to draw cards from the deck.
 * @author Davis Guest
 */
public class Deck {

    private List<Card> cards;
    private Card duplicate;
    private int deckType;

    /**
     * Constructs a new Deck with an empty list of cards and a default:
     * - deckType of -1
     * - duplicate of null
     */
    public Deck() {
        cards = new ArrayList<>();
        duplicate = null;
        deckType = -1;
    }


    /**
     * Returns a string representation of the deck.
     * Overrides the toString method of the Object class.
     * @return String representing the deck object.
     */
    @Override
    public String toString() {
        String list = "";

        for (int i = 1; i <= cards.size(); i++) {
            if (cards.get(i - 1).getRank() != 10) list += " ";

            list += cards.get(i - 1);

            if (i == cards.size()) break;
            else if ((i == 0 || i % 13 != 0) && deckType == 0) list += ",";
            else if ((i == 0 || i % 5 != 0) && deckType == 1) list += ",";
            else list += "\n";
        }

        return list;
    }


    /**
     * Builds a random deck based on a standard deck of 52 playing cards without jokers.
     * Shuffles the deck to randomize the card order.
     */
    public void buildRandDeck() {
        deckType = 0;

        for (int suit = 0; suit <= 3; suit++) {
            for (int rank = 2; rank <= 14; rank++) {
                cards.add(new Card(rank, suit));
            }
        }

        Collections.shuffle(cards);
    }


    /**
     * Builds a deck based on an input file.
     * @param file - String representing the file to build the deck from.
     * @throws FileNotFoundException - exception thrown if the specified file is not found.
     */
    public void buildFileDeck(String file) throws FileNotFoundException {
        deckType = 1;
        
        File f = new File(file);
        Scanner scan = new Scanner(f);

        while (scan.hasNextLine()) {
            String line = scan.nextLine();
            String[] lineList = line.split(",");

            for (String s : lineList) {
                int i = (s.charAt(0) == ' ') ? 1 : 0;

                int rank;
                if (s.charAt(i) == '1') rank = 10;
                else if (s.charAt(i) == 'J') rank = 11;
                else if (s.charAt(i) == 'Q') rank = 12;
                else if (s.charAt(i) == 'K') rank = 13;
                else if (s.charAt(i) == 'A') rank = 14;
                else rank = Character.getNumericValue(s.charAt(i));
                

                int suit;
                if (s.charAt(2) == 'D') suit = 0;
                else if (s.charAt(2) == 'C') suit = 1;
                else if (s.charAt(2) == 'H') suit = 2;
                else suit = 3;
                

                for (Card card : cards) {

                    if (card.getRank() == rank && card.getSuit() == suit) {
                        duplicate = card;
                    }

                }
                
                cards.add(new Card(rank, suit));
            }
        }

        scan.close();
    }


    /**
     * Draws a card from the deck, removing the first card.
     * @return Card representing the removed card.
     */
    public Card drawCard() {return cards.remove(0);}


    /**
     * Gets the duplicate of the deck.
     * @return Card representing a duplicate in the deck.
     */
    public Card getDuplicate() {return duplicate;}

}
