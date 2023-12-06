! Represents a hand of playing cards.
! This class defines a hand object that can hold a collection of card objects.
! author: Davis Guest
module class_Hand

    use class_Card

    implicit none
    private
    public :: Hand, init_hand, add_card, assess_hand, hand_to_string, compare_hand

    type Hand

        type(Card), dimension(:), allocatable :: cards, sorted
        integer :: hand_type

        contains

        procedure :: init_hand
        procedure :: hand_to_string
        procedure :: add_card
        procedure :: assess_hand
        procedure :: compare_hand
        procedure :: compare_hand_helper
        procedure :: is_royal_straight_flush
        procedure :: is_straight_flush
        procedure :: is_four_of_a_kind
        procedure :: is_full_house
        procedure :: is_flush
        procedure :: is_straight
        procedure :: is_three_of_a_kind
        procedure :: is_two_pair
        procedure :: is_pair
        procedure :: get_tie_breaker_card
        procedure :: get_rank_list
        procedure :: get_kicker
        procedure :: sort_hand
        procedure :: get_hand_type

    end type Hand

contains

    ! Initializes a new hand with an allocated array of 5 cards, its sorted variant of the same allocation,
    ! and a default hand type of 0.
    subroutine init_hand(this)
    class(Hand) :: this

    allocate(this%cards(5))
    allocate(this%sorted(5))
    this%hand_type = 0

    end subroutine init_hand


    ! Adds a card to the hand's list of cards.
    ! param: added_card - Card representing the input card
    subroutine add_card(this, added_card)
    class(Hand) :: this
    class(Card) :: added_card
    integer :: index, i

    index = 1

    do i=1, 5
        if (this%cards(i)%get_rank() == 0) then
            exit
        else
            index = index + 1
        end if
    end do

    this%cards(index) = added_card

    end subroutine add_card


    ! Analyzes the current collection of cards in the hand and determines its hand type.
    ! The sorted instance variable is updated to contain the cards sorted by rank.
    ! This method sets the hand_type instance variable to one of the predefined hand types:
    ! - 10 for Royal Straight Flush
    ! - 9 for Straight Flush
    ! - 8 for Four of a Kind
    ! - 7 for Full House
    ! - 6 for Flush
    ! - 5 for Straight
    ! - 4 for Three of a Kind
    ! - 3 for Two Pair
    ! - 2 for Pair
    ! - 1 for High Card
    subroutine assess_hand(this)
    class(Hand) :: this

    call this%sort_hand()

    if (this%is_royal_straight_flush()) then
        this%hand_type = 10
    else if (this%is_straight_flush()) then
        this%hand_type = 9
    else if (this%is_four_of_a_kind()) then
        this%hand_type = 8
    else if (this%is_full_house()) then
        this%hand_type = 7
    else if (this%is_flush()) then
        this%hand_type = 6
    else if (this%is_straight()) then
        this%hand_type = 5
    else if (this%is_three_of_a_kind()) then
        this%hand_type = 4
    else if (this%is_two_pair()) then
        this%hand_type = 3
    else if (this%is_pair()) then
        this%hand_type = 2
    else
        this%hand_type = 1
    end if

    end subroutine assess_hand


    ! Compares this hand with another hand based on their ranks.
    ! Used to sort each hand type and tiebreakers accordingly.
    ! param: other - Hand representing the hand to be compared.
    ! return: integer representing the which hand is greater or less than.
    function compare_hand(this, other) result(type_comparison)
    class(Hand) :: this, other
    integer :: type_comparison

    call this%assess_hand()
    call other%assess_hand()

    type_comparison = this%get_hand_type() - other%get_hand_type()

    type_comparison = compare_hand_helper(this, other, type_comparison, 0)

    end function compare_hand


    ! Recursive helper method for the compare_hand method.
    ! param: other - Hand representing the hands to compare to.
    ! param: diff - integer representing the difference of the hands in the current iteration.
    ! param: pass_num - integer representing the number for the current pass
    ! return: integer representing the difference between the two hands
    recursive function compare_hand_helper(this, other, diff, pass) result(output)
    class(Hand) :: this, other
    class(Card), allocatable :: this_breaker, other_breaker
    integer :: diff, pass, output
    integer :: rank_diff, suit_diff

    if (diff /= 0) then
        output = diff
        return
    end if

    this_breaker = this%get_tie_breaker_card(pass)
    other_breaker = other%get_tie_breaker_card(pass)

    rank_diff = this_breaker%get_rank() - other_breaker%get_rank()
    suit_diff = this_breaker%get_suit() - other_breaker%get_suit()

    if (pass < 2 .and. (this%get_hand_type() == 2 .or. this%get_hand_type() == 3)) then
        if (rank_diff == 0) then
            output = compare_hand_helper(this, other, rank_diff, pass + 1)
            return
        end if

        output = rank_diff
        return

    end if

    if (rank_diff == 0) then
        output = suit_diff
        return
    end if

    output = rank_diff

    end function compare_hand_helper


    ! Determines if the hand is a royal straight flush.
    ! return: logical representing if the hand is an RSF.
    function is_royal_straight_flush(this) result(output)
    class(Hand) :: this
    logical :: output
    integer, dimension(5) :: rank_list

    rank_list = this%get_rank_list()

    output = this%is_straight() .and. rank_list(1) == 10 .and. rank_list(5) == 14

    end function is_royal_straight_flush


    ! Determines if the hand is a straight flush.
    ! return: logical representing if the hand is an SF.
    function is_straight_flush(this) result(output)
    class(Hand) :: this
    logical :: output
    integer, dimension(5) :: rank_list

    rank_list = this%get_rank_list()

    output = this%is_straight() .and. this%is_flush()

    end function is_straight_flush


    ! Determines if the hand is a straight flush.
    ! return: logical representing if the hand is an SF.
    function is_four_of_a_kind(this) result(output)
    class(Hand) :: this
    logical :: output
    integer, dimension(5) :: rank_list

    rank_list = this%get_rank_list()

    output = (rank_list(1) == rank_list(4)) .or. (rank_list(2) == rank_list(5))

    end function is_four_of_a_kind


    ! Determines if the hand is a full house.
    ! return: logical representing if the hand is a FH.
    function is_full_house(this) result(output)
    class(Hand) :: this
    logical :: output
    integer, dimension(5) :: rank_list

    rank_list = this%get_rank_list()

    output = ((rank_list(1) == rank_list(2)) .and. (rank_list(3) == rank_list(5))) .or. &
            & ((rank_list(1) == rank_list(3)) .and. (rank_list(4) == rank_list(5)))

    end function is_full_house


    ! Determines if the hand is a flush.
    ! return: logical representing if the hand is a flush.
    function is_flush(this) result(output)
    class(Hand) :: this
    logical :: output
    integer, dimension(5) :: rank_list
    integer :: i, suit

    suit = this%sorted(1)%get_suit()
    rank_list = this%get_rank_list()

    do i = 1, 5
        if (this%sorted(i)%get_suit() /= suit) then
            output = .FALSE.
            return
        end if
    end do

    output = this%sorted(5)%get_suit() == suit

    end function is_flush


    ! Determines if the hand is a straight.
    ! return: logical representing if the hand is a straight.
    function is_straight(this) result(output)
    class(Hand) :: this
    logical :: output
    integer, dimension(5) :: rank_list
    integer :: i

    rank_list = this%get_rank_list()
    output = .TRUE.

    if (rank_list(5) == 14 .and. rank_list(1) == 2) then
        rank_list(5) = 1
        rank_list = sort_int_array(rank_list)
    end if

    do i = 1, 4
        if (rank_list(i + 1) /= rank_list(i) + 1) then
            output = .FALSE.
            return
        end if
    end do

    end function is_straight


    ! Determines if the hand is a three of a kind.
    ! return: logical representing if the hand is a TOAK.
    function is_three_of_a_kind(this) result(output)
    class(Hand) :: this
    logical :: output
    integer, dimension(5) :: rank_list

    rank_list = this%get_rank_list()

    output = (rank_list(1) == rank_list(3)) .or. &
            & (rank_list(2) == rank_list(4)) .or. &
            & (rank_list(3) == rank_list(5))

    end function is_three_of_a_kind


    ! Determines if the hand is a two pair.
    ! return: logical representing if the hand is a TP.
    function is_two_pair(this) result(output)
    class(Hand) :: this
    logical :: output
    integer, dimension(5) :: rank_list

    rank_list = this%get_rank_list()

    output = ((rank_list(1) == rank_list(2)) .and. (rank_list(3) == rank_list(4))) .or. &
            & ((rank_list(1) == rank_list(2)) .and. (rank_list(4) == rank_list(5))) .or. &
            & ((rank_list(2) == rank_list(3)) .and. (rank_list(4) == rank_list(5)))

    end function is_two_pair



    ! Determines if the hand is a pair.
    ! return: logical representing if the hand is a pair.
    function is_pair(this) result(output)
    class(Hand) :: this
    logical :: output
    integer, dimension(5) :: rank_list
    integer :: i

    rank_list = this%get_rank_list()
    output = .FALSE.

    do i= 1, 4
        if (rank_list(i) == rank_list(i + 1)) then
            output = .TRUE.
            return
        end if
    end do

    end function is_pair



    ! Determines the tie breaking card of the hand depending on its handType.
    ! param pass - integer representing the pass number.
    ! return: Card representing the tie-breaker card.
    function get_tie_breaker_card(this, pass) result (tie_breaker)
    class(Hand) :: this
    class(Card), allocatable :: tie_breaker, max, min, curr, prev
    type(Card), dimension(:), allocatable :: pair_list
    integer :: pass, i, index

    ! Royal Straight Flush
    if (this%get_hand_type() == 10) then
        tie_breaker = this%sorted(5)

    ! Straight Flush
    else if (this%get_hand_type() == 9) then
        if (this%sorted(5)%get_rank() == 14 .and. this%sorted(1)%get_rank() == 2) then
            tie_breaker = this%sorted(4)
            return
        end if

        tie_breaker = this%sorted(5)

    ! Four of a Kind
    else if (this%get_hand_type() == 8) then
        tie_breaker = this%sorted(3)

    ! Full House
    else if (this%get_hand_type() == 7) then
        tie_breaker = this%sorted(3)

    ! Flush 
    else if (this%get_hand_type() == 6) then
        tie_breaker = this%sorted(5)

    ! Straight
    else if (this%get_hand_type() == 5) then
        tie_breaker = this%sorted(5)

    ! Three of a Kind
    else if (this%get_hand_type() == 4) then
        tie_breaker = this%sorted(3)

    ! Two Pair
    else if (this%get_hand_type() == 3) then
        allocate(pair_list(4))

        index = 1

        do i=2, size(this%sorted)
            curr = this%sorted(i)
            prev = this%sorted(i - 1)

            if (curr%get_rank() - prev%get_rank() == 0) then
                pair_list(index) = curr
                index = index + 1
            end if

        end do

        max = pair_list(1)
        min = pair_list(1)

        do i = 1, size(pair_list)
            if (pair_list(i)%get_rank() > max%get_rank()) max = pair_list(i)
            if (pair_list(i)%get_rank() < min%get_rank()) min = pair_list(i)
        end do

        if (pass == 0) then
            tie_breaker = max
        else if (pass == 1) then
            tie_breaker = min
        else
            tie_breaker = this%get_kicker()
        end if

    !! Pair
    else if (this%get_hand_type() == 2) then

        do i=2, size(this%sorted)
            curr = this%sorted(i)
            prev = this%sorted(i - 1)

            if (curr%get_rank() - prev%get_rank() == 0) then
                tie_breaker = curr
                exit
            end if

        end do

        if (pass == 0) then
            return
        else if (pass == 1) then
            tie_breaker = this%get_kicker()
        end if

    ! High Card
    else
        tie_breaker = this%sorted(5)

    end if

    end function get_tie_breaker_card


    ! Helper method to get a sorted list of ranks in the hand.
    ! return: array representing the ranks in ascending order.
    function get_rank_list(this) result(rank_list)
    class(Hand) :: this
    integer, dimension(5) :: rank_list
    integer :: i

    do i = 1, size(this%cards)
        rank_list(i) = this%cards(i)%get_rank()
    end do

    rank_list = sort_int_array(rank_list)

    end function get_rank_list


    ! Gets the kicker card for pairs and two pairs.
    ! return: Card representing the kicker card.
    function get_kicker(this) result(kicker)
    class(Hand) :: this
    class(Card), allocatable :: kicker, curr, prev
    type(Card), dimension(:), allocatable :: non_pair_list
    integer :: i, index

    index = 1

    if (this%hand_type == 3) then
        allocate(non_pair_list(1))
    else
        allocate(non_pair_list(3))
    end if

    do i=2, size(this%sorted)
        curr = this%sorted(i)
        prev = this%sorted(i - 1)

        if (curr%get_rank() /= prev%get_rank()) then
            non_pair_list(index) = curr
            index = index + 1
        end if
    end do

    kicker = non_pair_list(1)

    do i=1, size(non_pair_list)
        if (non_pair_list(i)%get_rank() > kicker%get_rank()) then
            kicker = non_pair_list(i)
        end if
    end do

    end function get_kicker



    ! Sorts the hand of cards, and sets the "sorted" variable to this new version.
    subroutine sort_hand(this)
    class(Hand) :: this
    type(Card) :: temp
    integer :: i, j

    do i = 1, size(this%cards)
        call this%sorted(i)%init_card(this%cards(i)%get_rank(), this%cards(i)%get_suit())
    end do

    do j = 1, size(this%sorted) - 1
        do i = 1, size(this%sorted) - 1
            if (this%sorted(i)%compare_card(this%sorted(i + 1)) > 0) then
                call temp%init_card(this%sorted(i + 1)%get_rank(), this%sorted(i + 1)%get_suit())
                this%sorted(i + 1) = this%sorted(i)
                this%sorted(i) = temp
            end if
        end do
    end do

    end subroutine sort_hand


    ! Sorts a provided integer array in ascending order.
    ! param: arr - array representing the array to be sorted.
    ! return: array representing the sorted integer array.
    function sort_int_array(arr) result(sorted_arr)
    integer, dimension(5) :: arr, sorted_arr
    integer :: i, j, temp

    sorted_arr = arr

    do j = 1, size(sorted_arr) - 1
        do i = 1, size(sorted_arr) - 1
            if (sorted_arr(i) > sorted_arr(i + 1)) then
                temp = sorted_arr(i + 1)
                sorted_arr(i + 1) = sorted_arr(i)
                sorted_arr(i) = temp
            end if
        end do
    end do

    end function sort_int_array


    ! Returns a string representation of the hand.
    ! return: string representing the hand object.
    function hand_to_string(this) result(output)
    class(Hand) :: this
    character(len=:), allocatable :: output
    integer :: i

    do i = 1, size(this%cards)
        if (this%cards(i)%get_rank() /= 10) output = output // " "

        output = output // this%cards(i)%card_to_string()

        if (i == 1 .or. mod(i, 5) /= 0) output = output // " "
    end do

    if (this%hand_type == 0) return

    if (this%hand_type == 10) then
        output = output // " - Royal Straight Flush"
    else if (this%hand_type == 9) then
        output = output // " - Straight Flush"
    else if (this%hand_type == 8) then
        output = output // " - Four of a Kind"
    else if (this%hand_type == 7) then
        output = output // " - Full House"
    else if (this%hand_type == 6) then
        output = output // " - Flush"
    else if (this%hand_type == 5) then
        output = output // " - Straight"
    else if (this%hand_type == 4) then
        output = output // " - Three of a Kind"
    else if (this%hand_type == 3) then
        output = output // " - Two Pair"
    else if (this%hand_type == 2) then
        output = output // " - Pair"
    else
        output = output // " - High Card"
    end if

    end function hand_to_string


    ! Gets the hand type of the hand.
    ! return: integer representing the hand type of the hand.
    function get_hand_type(this) result(output)
    class(Hand) :: this
    integer :: output

    output = this%hand_type

    end function get_hand_type

end module class_Hand