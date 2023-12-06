! Represents a playing card.
! This class defines a card object with a rank and suit.
! author: Davis Guest
module class_Card
    implicit none
    private
    public :: Card, init_card, card_to_string, compare_card, get_suit, get_rank

    type Card

        integer :: rank, suit

    contains

        procedure :: init_card
        procedure :: card_to_string
        procedure :: compare_card
        procedure :: get_suit
        procedure :: get_rank
        
    end type Card

contains

    ! Initializes a new card with the specified rank and suit.
    ! param: r - integer representing the card's rank.
    ! param: s - integer representing the card's suit.
    subroutine init_card (this, r, s)
        class(Card) :: this
        integer :: r, s

        this%rank = r
        this%suit = s

    end subroutine init_card

    ! Returns a string representation of the card.
    ! return: string representing the card object.
    function card_to_string (this) result(str)
        class(Card) :: this
        character(:), allocatable :: str, suit_label, face, rank_label

        suit_label = ""
        select case (this%suit)
        case (0)
            suit_label = 'D'
        case (1)
            suit_label = 'C'
        case (2)
            suit_label = 'H'
        case (3)
            suit_label = 'S'
        end select

        face = ""
        select case (this%rank)
        case (11)
            face = 'J'
        case (12)
            face = 'Q'
        case (13)
            face = 'K'
        case (14)
            face = 'A'
        case default
            if (this%rank == 10) then
                rank_label = "10"
            else
                rank_label = achar(iachar('0') + this%rank)
            end if
        end select
        

        if (len(face) == 0) then
            str = trim(rank_label // suit_label)
            return
        end if

        str = trim(face // suit_label)

    end function card_to_string

    ! Compares this card with another card based on their ranks.
    ! param: other - Card representing the card to be compared.
    ! return: integer representing the difference between the two card's ranks.
    function compare_card (this, other) result(comparison)
        class(Card) :: this, other
        integer :: comparison

        comparison = this%rank - other%rank

    end function compare_card

    ! Gets the rank of the card.
    ! return: integer representing the rank of the card.
    function get_rank (this) result(ret)
        class(Card) :: this
        integer :: ret

        ret = this%rank

    end function get_rank

    ! Gets the suit of the card.
    ! return: integer representing the suit of the card.
    function get_suit (this) result(ret)
        class(Card) :: this
        integer :: ret

        ret = this%suit
        
    end function get_suit

end module class_Card