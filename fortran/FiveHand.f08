! Represents the game of Five Hand, a poker game with 6 hands.
! The game can be played with a randomized deck or a deck loaded from a file.
! author: Davis Guest
module class_FiveHand

    use class_Deck
    use class_Hand
    use class_Card
    implicit none

    type FiveHand

        type(Deck) :: game_deck
        type(Hand), dimension(:), allocatable :: hands
        character(len=:), allocatable :: file_name
        integer :: game_type

        contains

        procedure :: init_FiveHand
        procedure :: play
        procedure :: draw_cards
        procedure :: print_all_hands
        procedure :: sort_hands

    end type FiveHand

contains

    ! Initializes a new Five Hand game with a list of 6 empty hands, a deck of cards, and a file name if input.
    ! If command line arguments are provided, it builds a file deck; otherwise, it builds a randomized deck.
    subroutine init_FiveHand(this)
        class(FiveHand) :: this
        integer :: i
        character(len=256) :: input_file

        call getarg(1, input_file)
        this%file_name = trim(input_file)

        call this%game_deck%init_deck()

        allocate(this%hands(6))

        do i = 1, 6
            call this%hands(i)%init_hand()
        end do

        if (this%file_name == "") then
            this%game_type = 0
            call this%game_deck%build_rand_deck()
        else
            this%game_type = 1
            call this%game_deck%build_file_deck(this%file_name)
        end if

    end subroutine init_FiveHand


    ! Starts a Five Hand game.
    ! Type of game is determined if there is an input file.
    ! Then determines the winning hands in descending order.
    subroutine play(this)
        class(FiveHand) :: this
        integer :: i

        print *, char(10) // "*** P O K E R   H A N D   A N A L Y Z E R ***" // char(10)

        if (this%game_type == 0) then
            print *, char(10) // "*** USING RANDOMIZED DECK OF CARDS ***" // char(10) // &
                   & char(10) //"*** Shuffled 52 card deck" // char(10) // &
                   & this%game_deck%deck_to_string()
        else
            print *, char(10) // "*** USING TEST DECK ***" // char(10) // &
                   & char(10) // "*** File: " // this%file_name // char(10) // &
                   & this%game_deck%deck_to_string()
        end if


        if (this%game_deck%duplicate%get_rank() /= 0) then
            print *, char(10) // "*** ERROR - DUPLICATED CARD FOUND IN DECK ***" // char(10)
            print *, char(10) // "*** DUPLICATE: " // this%game_deck%duplicate%card_to_string() // " ***" // char(10)
            return
        end if

        call this%draw_cards()

        print *, char(10) // "*** Here are the six hands..."

        call this%print_all_hands()

        if (this%game_type == 0) then
            print *, char(10) // "*** Here is what remains in the deck..." // char(10) // this%game_deck%deck_to_string()
        end if

        print *, char(10) // "--- WINNING HAND ORDER ---"


        do i=1, 6
            call this%hands(i)%assess_hand()
        end do

        call this%sort_hands()

        call this%print_all_hands()

    end subroutine play


    ! Draws 30 cards to set up 6 hands of 5 cards.
    ! Alternates drawing cards among the hands.
    subroutine draw_cards(this)
        class(FiveHand) :: this
        type(Card) :: temp
        integer :: i, hand_num

        hand_num = 1

        if (this%game_type == 0) then
            do i=1, 30
                if (hand_num == 7) hand_num = 1

                temp = this%game_deck%draw_card()
                call this%hands(hand_num)%add_card(temp)

                hand_num = hand_num + 1
            end do
        else
            do i=1, 30
                temp = this%game_deck%draw_card()
                call this%hands(hand_num)%add_card(temp)
                if (mod(i, 5) == 0) hand_num = hand_num + 1
            end do
        end if

    end subroutine draw_cards


    ! Prints all the hands to the console.
    subroutine print_all_hands(this)
        class(FiveHand) :: this
        integer :: i

        do i=1, 6
            print *, this%hands(i)%hand_to_string()
        end do

    end subroutine print_all_hands


    ! Sorts the hands to the winning order.
    subroutine sort_hands(this)
        class(FiveHand) :: this
        class(Hand), allocatable :: temp
        integer i, j

        do j=1, size(this%hands) - 1
            do i=1, size(this%hands) - 1
                if (this%hands(i)%compare_hand(this%hands(i + 1)) < 0) then
                    temp = this%hands(i + 1)
                    this%hands(i + 1) = this%hands(i)
                    this%hands(i) = temp
                end if
            end do
        end do

    end subroutine sort_hands

end module class_FiveHand



! Main Method Program
! Initializes a new game then starts the appropriate game type depending on command line arguements.
program MainProgram
    use class_FiveHand
    use class_Card
    use class_Hand
    use class_Deck
    implicit none
    type(FiveHand) :: game

    call game%init_FiveHand()
    call game%play()

end program MainProgram