/**
 * Represents a playing card.
 * This class defines a card object with a rank and suit.
 * It implements the Comparable interface for comparing cards based on their rank.
 * @author Davis Guest
 */
public class Card implements Comparable<Card> {

    private int rank;
    private int suit;

    /**
     * Constructs a new card with the specified rank and suit.
     * @param r - int representing the card's rank.
     * @param s - int representing the card's suit.
     */
    public Card(int r, int s) {
        rank = r;
        suit = s;
    }


    /**
     * Returns a String representation of the card.
     * Overrides the toString method of the Object class.
     * @return String representing the card object.
     */
    @Override
    public String toString() {
        String suitLabel = "";
        if (suit == 0) suitLabel = "D";
        else if (suit == 1) suitLabel = "C";
        else if (suit == 2) suitLabel = "H";
        else if (suit == 3) suitLabel = "S";

        String face = "";
        if (rank == 11) face = "J";
        else if (rank == 12) face = "Q";
        else if (rank == 13) face = "K";
        else if (rank == 14) face = "A";

        return (face.isEmpty()) ? rank + suitLabel : face + suitLabel;
    }


    /**
     * Compares this card with another card based on their ranks.
     * Overrides the compareTo method of the Comparable interface.
     * @param other - Card representing the card to be compared.
     * @return int representing the difference between the two card's ranks.
     */
    @Override
    public int compareTo(Card other) {
        return Integer.compare(rank, other.rank);
    }


    /**
     * Gets the rank of the card.
     * @return int representing the rank of the card.
     */
    public int getRank() {return rank;}


    /**
     * Gets the suit of the card.
     * @return int representing the suit of the card.
     */
    public int getSuit() {return suit;}

}