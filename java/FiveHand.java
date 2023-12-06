import java.util.Collections;
import java.util.List;
import java.util.ArrayList;
import java.io.FileNotFoundException;

/**
 * Represents the game of Five Hand, a poker game with 6 hands.
 * The game can be played with a randomized deck or a deck loaded from a file.
 * @author Davis Guest
 */
public class FiveHand {

    private Deck deck;
    private List<Hand> hands;

    /**
     * Constructs a new Five Hand game with a list of 6 empty hands and a deck of cards.
     * If command line arguments are found, it builds a file deck; otherwise, it builds a randomized deck.
     * @param file - String representing the file to build the deck from.
     * @throws FileNotFoundException - exception thrown if the specified file is not found.
     */
    public FiveHand(String file) throws FileNotFoundException {
        deck = new Deck();
        hands = new ArrayList<>();

        for (int i = 0; i < 6; i++) {
            hands.add(new Hand());
        }

        if (file != null) deck.buildFileDeck(file);
        else deck.buildRandDeck();
    }


    /**
     * Starts a Five Hand game.
     * Type of game is determined if there is an input file.
     * Then determines the winning hands in descending order.
     * @param file - String representing the file to build the deck from.
     */
    public void play(String file) {
        System.out.println("\n*** P O K E R   H A N D   A N A L Y Z E R ***\n");

        int gameType = (file == null) ? 0 : 1;

        if (gameType == 0) {
            System.out.println(
                    "\n*** USING RANDOMIZED DECK OF CARDS ***\n" +
                            "\n*** Shuffled 52 card deck\n" +
                            deck
            );

        } else {
            System.out.println(
                    "\n*** USING TEST DECK ***\n" +
                            "\n*** File: " + file + "\n" +
                            deck
            );
        }

        if (deck.getDuplicate() != null) {
            System.out.println(
                    "\n*** ERROR - DUPLICATED CARD FOUND IN DECK ***\n" +
                            "\n*** DUPLICATE: " + deck.getDuplicate() + " ***\n"
            );
            return;
        }

        drawCards(gameType);

        System.out.println("\n*** Here are the six hands...");

        printAllHands();

        if (gameType == 0) {
            System.out.println(
                    "\n*** Here is what remains in the deck...\n" +
                            deck
            );
        }

        System.out.println("\n--- WINNING HAND ORDER ---");

        Collections.sort(hands);
        printAllHands();
        System.out.println();
    }


    /**
     * Draws 30 cards to set up 6 hands of 5 cards.
     * Alternates drawing cards among the hands.
     * @param gameType - int representing if the hands should be drawn randomized or from a file input.
     */
    private void drawCards(int gameType) {
        if (gameType == 0) {
            for (int i = 0, handNum = 0; i < 30; i++, handNum++) {
                if (handNum == 6) handNum = 0;
                hands.get(handNum).addCard(deck.drawCard());
            }

        } else {
            for (int i = 1, handNum = 0; i <= 30; i++) {
                hands.get(handNum).addCard(deck.drawCard());
                if (i % 5 == 0) handNum++;
            }
        }
    }


    /**
     * Prints all the hands to the console.
     */
    private void printAllHands() {
        for (Hand hand : hands) {
            System.out.println(hand.toString());
        }
    }


    /**
     * Main method for the FiveHand game.
     * Initiates the game based on command line arguments.
     * @param args - String array representing command line arguments.
     * @throws FileNotFoundException - exception thrown if the specified file is not found.
     */
    public static void main(String[] args) throws FileNotFoundException {
        String file = (args.length > 0) ? args[0] : null;
        FiveHand game = new FiveHand(file);
        game.play(file);
    }

}
