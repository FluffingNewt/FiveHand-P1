! Representing a collection of a set of standard 52 playing cards, without a Joker.
! This class allows you to build a deck either randomly or from a file and provides
! methods to draw cards from the deck.
! author: Davis Guest
module class_Deck

    use class_Card

    implicit none
    private
    public :: Deck, init_deck, build_rand_deck, build_file_deck, deck_to_string, &
            & draw_card, get_duplicate

    type Deck

        type(Card), dimension(:), allocatable :: cards
        type(Card) :: duplicate
        integer :: deck_type

        contains

        procedure :: init_deck
        procedure :: deck_to_string
        procedure :: build_rand_deck
        procedure :: build_file_deck
        procedure :: draw_card
        procedure :: get_duplicate
        procedure :: shuffle_deck
        
    end type Deck

contains

    ! Initializes a new Deck with an empty list of cards and a default:
    ! - deck type of -1
    ! - duplicate of a "dummy" card
    subroutine init_deck (this)
        class(Deck) :: this

        this%deck_type = -1
        call this%duplicate%init_card(0, -1)

    end subroutine init_deck


    ! Returns a string representation of the deck.
    ! return: string representing the deck object.
    function deck_to_string (this) result(str)
        class(Deck) :: this
        character(len=:), allocatable :: str
        integer :: i, num

        str = ""
        num = 0

        do i = 1, size(this%cards)
            if (this%cards(i)%get_rank() == 0) cycle

            if (this%cards(i)%get_rank() /= 10) then
                str = str // " "
            end if

            str = str // this%cards(i)%card_to_string()
            num = num + 1

            if (i == size(this%cards)) then
                return
            else if (mod(num, 13) /= 0 .and. this%deck_type == 0) then
                str = str // ","
            else if (mod(num, 5) /= 0 .and. this%deck_type == 1) then
                str = str // ","
            else
                str = str // char(10)
            end if
        end do
        
    end function deck_to_string


    ! Builds a random deck based on a standard deck of 52 playing cards without jokers.
    ! Shuffles the deck to randomize the card order.
    subroutine build_rand_deck (this)
        class(Deck) :: this
        integer :: rank, suit, i

        this%deck_type = 0
        allocate(this%cards(52))
        i = 1

        do suit = 0, 3
            do rank = 2, 14
                this%cards(i) = Card(rank, suit)
                i = i + 1
            end do
        end do

        call this%shuffle_deck()
        
    end subroutine build_rand_deck

    
    ! Builds a deck based on an input file.
    ! Stops code if an invalid file name is provided.
    ! param: file_name - string representing the file to build the deck from.
    subroutine build_file_deck (this, file_name)
        class(Deck) :: this
        character(len=256) :: file_name, line, card_str
        character(len=3), dimension(5) :: line_list
        integer :: unit_num, iostatus, i, j, arr_index, line_index, rank, suit

        this%deck_type = 1
        arr_index = 1
        allocate(this%cards(30))

        open(newunit=unit_num, file=file_name, status='old', iostat=iostatus)

        if (iostatus /= 0) then
            write(*,*) char(10) // "*** Invalid File Name ***" // char(10)
            stop
        end if

        do while (.true.)
            read(unit_num, '(A)', iostat=iostatus) line

            if (iostatus /= 0) exit
    
            line_list = line_split(line)
    
            do line_index = 1, size(line_list)
                card_str = line_list(line_index)
    
                if (card_str(1:1) == ' ') then
                    i = 2
                else
                    i = 1
                end if
    
                select case (card_str(i:i))
                    case ('1')
                        rank = 10
                    case ('2')
                        rank = 2
                    case ('3')
                        rank = 3
                    case ('4')
                        rank = 4
                    case ('5')
                        rank = 5
                    case ('6')
                        rank = 6
                    case ('7')
                        rank = 7
                    case ('8')
                        rank = 8
                    case ('9')
                        rank = 9
                    case ('J')
                        rank = 11
                    case ('Q')
                        rank = 12
                    case ('K')
                        rank = 13
                    case default
                        rank = 14
                end select
    
                select case (card_str(3:3))
                    case ('D')
                        suit = 0
                    case ('C')
                        suit = 1
                    case ('H')
                        suit = 2
                    case default
                        suit = 3
                end select
    
                do j = 1, size(this%cards)
                    if (this%cards(j)%get_rank() == rank .and. this%cards(j)%get_suit() == suit) then
                        this%duplicate = this%cards(j)
                        exit
                    end if
                end do
    
                call this%cards(arr_index)%init_card(rank, suit)
                arr_index = arr_index + 1
            end do
        end do
    
        close(unit_num)

    end subroutine build_file_deck


    ! Returns an array of a string that has been split by a comma.
    ! param: input - string representing the line to be split.
    ! return: array representing the split line.
    function line_split(input) result(output)
        character(len=*), intent(in) :: input
        character(len=3), dimension(5) :: output
        integer :: i, arr_index

        arr_index = 1

        do i=1, len(input), 4
            output(arr_index) = input(i : i + 2)
            arr_index = arr_index + 1
        end do
        
    end function line_split


    ! Draws a card from the deck, removing the first card.
    ! return: Card representing the removed card.
    function draw_card (this) result(output)
        class(Deck) :: this
        type(Card) :: temp, output
        integer :: i, index

        index = 1

        do i=1, size(this%cards)
            if (this%cards(i)%get_rank() == 0) then
                index = index + 1
            else
                exit
            end if
        end do

        call output%init_card(this%cards(index)%get_rank(), this%cards(index)%get_suit())
        call temp%init_card(0, 0)
        this%cards(index) = temp

    end function draw_card

    
    ! Gets the duplicate of the deck.
    ! return: Card representing a duplicate in the deck.
    function get_duplicate (this) result(ret)
        class(Deck) :: this
        type(Card) :: ret

        ret = this%duplicate

    end function get_duplicate


    ! Shuffles the deck instance variable.
    subroutine shuffle_deck (this)
        class(Deck) :: this
        type(Card) :: temp
        integer :: i, k
        real :: rand_real

        do i = size(this%cards), 2, -1
            call random_number(rand_real)
            k = floor(rand_real * i) + 1

            temp = this%cards(i)
            this%cards(i) = this%cards(k)
            this%cards(k) = temp
        end do 

    end subroutine shuffle_deck
    
end module class_Deck