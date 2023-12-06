import java.util.ArrayList;
import java.util.List;
import java.util.Collections;
import java.util.Objects;

/**
 * Represents a hand of playing cards.
 * This class defines a hand object that can hold a collection of card objects.
 * It implements the Comparable interface for comparing different hands.
 * @author Davis Guest
 */
public class Hand implements Comparable<Hand> {

    private List<Card> cards;
    private List<Card> sorted;
    private int handType;

    /**
     * Constructs a new hand with an empty list of cards and a default hand type of 0.
     */
    public Hand() {
        cards = new ArrayList<>();
        handType = 0;
    }


    /**
     * Adds a card to the hand's list of cards.
     * @param card - Card representing the input card
     */
    public void addCard(Card card) {cards.add(card);}


    /**
     * Returns a string representation of the hand.
     * Overrides the toString method of the Object class.
     * @return String representing the hand object
     */
    @Override
    public String toString() {
        String list = "";

        for (int i = 1; i <= cards.size(); i++) {
            if (cards.get(i - 1).getRank() != 10) list += " ";

            list += cards.get(i - 1);

            if (i == 0 || i % 5 != 0) list += " ";
        }

        if (handType == 0) return list;

        if (handType == 10) list += " - Royal Straight Flush";
        else if (handType == 9) list += " - Straight Flush";
        else if (handType == 8) list += " - Four of a Kind";
        else if (handType == 7) list += " - Full House";
        else if (handType == 6) list += " - Flush";
        else if (handType == 5) list += " - Straight";
        else if (handType == 4) list += " - Three of a Kind";
        else if (handType == 3) list += " - Two Pair";
        else if (handType == 2) list += " - Pair";
        else list += " - High Card";

        return list;
    }


    /**
     * Compares this hand with another hand based on their ranks.
     * Used to sort each hand type and tiebreakers accordingly.
     * Overrides the compareTo method of the Comparable interface.
     * @param other - Hand representing the hand to be compared.
     * @return int representing the which hand is greater or less than.
     */
    @Override
    public int compareTo(Hand other) {
        assessHand();
        other.assessHand();

        int typeComparison = -1 * Integer.compare(handType, other.handType);

        return compareToHelper(other, typeComparison, 0);
    }


    /**
     * Recursive helper method for the compareTo method
     * @param other - Hand representing the hands to compare to
     * @param diff - int representing the difference of the hands in the current iteration
     * @param pass - int representing the number for the current pass
     * @return int representing the difference between the two hands
     */
    private int compareToHelper(Hand other, int diff, int pass) {
        if (diff != 0) return diff;

        Card thisBreaker = getTieBreakerCard(pass);
        Card otherBreaker = other.getTieBreakerCard(pass);

        int rankDiff = -1 * Integer.compare(thisBreaker.getRank(), otherBreaker.getRank());
        int suitDiff = -1 * Integer.compare(thisBreaker.getSuit(), otherBreaker.getSuit());

        if (pass < 2 && (handType == 2 || handType == 3)) {
            if (rankDiff == 0) {
                return compareToHelper(other, rankDiff, pass + 1);
            }
            return rankDiff;
        }

        if (rankDiff == 0) return suitDiff;
        return rankDiff;
    }


    /**
     * Analyzes the current collection of cards in the hand and determines its hand type.
     * The sorted instance variable is updated to contain the cards sorted by rank.
     * This method sets the handType instance variable to one of the predefined hand types:
     * - 10 for Royal Straight Flush
     * - 9 for Straight Flush
     * - 8 for Four of a Kind
     * - 7 for Full House
     * - 6 for Flush
     * - 5 for Straight
     * - 4 for Three of a Kind
     * - 3 for Two Pair
     * - 2 for Pair
     * - 1 for High Card
     */
    private void assessHand() {
        sorted = new ArrayList<>(cards);
        Collections.sort(sorted);

        if (isRoyalStraightFlush()) handType = 10;
        else if (isStraightFlush()) handType = 9;
        else if (isFourOfAKind()) handType = 8;
        else if (isFullHouse()) handType = 7;
        else if (isFlush()) handType = 6;
        else if (isStraight()) handType = 5;
        else if (isThreeOfAKind()) handType = 4;
        else if (isTwoPair()) handType = 3;
        else if (isPair()) handType = 2;
        else handType = 1;
    }


    /**
     * Determines if the hand is a royal straight flush.
     * @return Boolean representing if the hand is an RSF.
     */
    private Boolean isRoyalStraightFlush() {
        ArrayList<Integer> rankList = getRankList();

        return isStraightFlush() &&
               rankList.get(0) == 10 &&
               rankList.get(4) == 14;
    }


    /**
     * Determines if the hand is a straight flush.
     * @return Boolean representing if the hand is an SF.
     */
    private Boolean isStraightFlush() {
        return isStraight() && isFlush();
    }


    /**
     * Determines if the hand is a four of a kind.
     * @return Boolean representing if the hand is a FOAK.
     */
    private Boolean isFourOfAKind() {
        ArrayList<Integer> rankList = getRankList();

        return (rankList.get(0).equals(rankList.get(3))) ||
               (rankList.get(1).equals(rankList.get(4)));
    }


    /**
     * Determines if the hand is a full house.
     * @return Boolean representing if the hand is a FH.
     */
    private Boolean isFullHouse() {
        ArrayList<Integer> rankList = getRankList();

        return (Objects.equals(rankList.get(0), rankList.get(1)) && Objects.equals(rankList.get(2), rankList.get(4))) ||
               (Objects.equals(rankList.get(0), rankList.get(2)) && Objects.equals(rankList.get(3), rankList.get(4)));
    }


    /**
     * Determines if the hand is a flush.
     * @return Boolean representing if the hand is a flush.
     */
    private Boolean isFlush() {
        int suit = sorted.get(0).getSuit();

        for (int i = 0; i < 4; i++) {
            if (sorted.get(i).getSuit() != suit) return false;
        }

        return sorted.get(4).getSuit() == suit;
    }


    /**
     * Determines if the hand is a straight.
     * @return Boolean representing if the hand is a straight.
     */
    private Boolean isStraight() {
        ArrayList<Integer> rankList = getRankList();

        if (rankList.contains(14) && rankList.contains(2)) {
            rankList.set(rankList.indexOf(14), 1);
            Collections.sort(rankList);
        }

        for (int i = 0; i < 4; i++) {
            if (rankList.get(i + 1) != rankList.get(i) + 1) {
                return false;
            }
        }

        return true;
    }


    /**
     * Determines if the hand is a three of a kind.
     * @return Boolean representing if the hand is a TOAK.
     */
    private Boolean isThreeOfAKind() {
        ArrayList<Integer> rankList = getRankList();

        return (rankList.get(0).equals(rankList.get(2))) ||
               (rankList.get(1).equals(rankList.get(3))) ||
               (rankList.get(2).equals(rankList.get(4)));
    }


    /**
     * Determines if the hand is a two pair.
     * @return Boolean representing if the hand is a TP.
     */
    private Boolean isTwoPair() {
        ArrayList<Integer> rankList = getRankList();

        return (Objects.equals(rankList.get(0), rankList.get(1)) && Objects.equals(rankList.get(2), rankList.get(3))) ||
                (Objects.equals(rankList.get(0), rankList.get(1)) && Objects.equals(rankList.get(3), rankList.get(4))) ||
                (Objects.equals(rankList.get(1), rankList.get(2)) && Objects.equals(rankList.get(3), rankList.get(4)));
    }


    /**
     * Determines if the hand is a pair.
     * @return Boolean representing if the hand is a pair.
     */
    private Boolean isPair() {
        ArrayList<Integer> rankList = getRankList();

        for (int i = 0; i < 4; i++) {
            if (Objects.equals(rankList.get(i), rankList.get(i + 1))) {
                return true;
            }
        }

        return false;
    }


    /**
     * Determines the tie breaking card of the hand depending on its handType.
     * @param pass - int representing the pass number
     * @return Card representing the tie-breaker card.
     */
    private Card getTieBreakerCard(int pass) {

        // Royal Straight Flush
        if (handType == 10) return sorted.get(4);

        // Straight Flush
        else if (handType == 9)
            return (sorted.get(4).getRank() == 14 && sorted.get(0).getRank() == 2) ?
                    sorted.get(3) : sorted.get(4);

        // Four of a Kind
        else if (handType == 8) return sorted.get(2);

        // Full House
        else if (handType == 7) return sorted.get(2);

        // Flush 
        else if (handType == 6) return sorted.get(4);

        // Straight
        else if (handType == 5) return sorted.get(4);

        // Three of a Kind
        else if (handType == 4) return sorted.get(2);

        // Two Pair
        else if (handType == 3) {
            ArrayList<Card> pairList = new ArrayList<>();

            for (int i = 1; i < sorted.size(); i++) {
                Card currentCard = sorted.get(i);
                Card previousCard = sorted.get(i - 1);

                if (Integer.compare(currentCard.getRank(), previousCard.getRank()) == 0) {
                    pairList.add(currentCard);
                }
            }

            Card max = pairList.get(0);
            Card min = pairList.get(0);

            for (Card card : pairList) {
                if (card.getRank() > max.getRank()) max = card;
                if (card.getRank() < min.getRank()) min = card;
            }

            if (pass == 0) return max;
            else if (pass == 1) return min;
            else return getKicker();
        }

        // Pair
        else if (handType == 2) {
            Card ret = null;

            for (int i = 1; i < sorted.size(); i++) {
                Card currentCard = sorted.get(i);
                Card previousCard = sorted.get(i - 1);

                if (Integer.compare(currentCard.getRank(), previousCard.getRank()) == 0) {
                    ret = currentCard;
                    break;
                }
            }

            if (pass == 0) return ret;
            else if (pass == 1) return getKicker();
        }

        // High Card
        return sorted.get(4);
    }


    /**
     * Helper method to get a sorted list of ranks in the hand.
     * @return ArrayList representing the ranks in ascending order.
     */
    private ArrayList<Integer> getRankList() {
        ArrayList<Integer> rankList = new ArrayList<>();

        for (Card card : cards) {
            rankList.add(card.getRank());
        }

        Collections.sort(rankList);

        return rankList;
    }


    /**
     * Gets the kicker card for pairs and two pairs.
     * @return Card representing the kicker card.
     */
    private Card getKicker() {
        ArrayList<Card> nonPairList = new ArrayList<>();

        for (int i = 1; i < sorted.size(); i++) {
            Card currentCard = sorted.get(i);
            Card previousCard = sorted.get(i - 1);

            if (Integer.compare(currentCard.getRank(), previousCard.getRank()) != 0) {
                nonPairList.add(currentCard);
            }
        }

        Card max = nonPairList.get(0);

        for (Card card : nonPairList) {
            if (card.getRank() > max.getRank()) {
                max = card;
            }
        }

        return max;
    }

}
