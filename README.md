# Project 1 - Five Card Stud

## Description

This card game immitates a special version of poker called Five Card Stud. However, this game does not allow for the splitting of the pot or ties. There is a clear winner each time depending on the hand's type, high card, and suit. There is no "draw phase" either, a randomized deck is looped through giving 1 card to one of six hands at a time (unless using a file input test deck).

## Game Types

There are two game types for this project, randomized (noraml) and file-input. When the program is ran with no command line arguements, the randomized game will be run as default. The file-input game uses a .txt listed in the command line arguements in order to test if a hand is accessed correctly. Hands will not be given cards one at a time, it will be line by line. Thus, this means the deck also is not randomized. The .txt file must have the following formatting:

* Space before all cards ranks/faces except for 10 (including the first card per line)
* Capital suit labels
* Comma after each suit except for the last card per line

Ex:  
 AH, 2H, 3H, 4H, 5H  
 2S, 3S, 4S, 5S, 6S  
 7S, 8S, 9S,10S, JS  
 QS, KS, 6H, 7H, 8H  
 9H,10H, JH, QH, KH  
 2C, 3C, 4C, 5C, 6C  

# Game Verions
In your terminal, navigate to where the game's files are located after downloading.

## Java
### Compile
To compile all the .java files, type the following and press enter: 

* javac FiveHand.java

### Run
In the same directory, type the following and press enter to run the game:

* Randomized verion: java FiveHand
* File-Input Version: java FiveHand {filename}.txt

## C#
### Compile
To compile all the .cs files, make sure FiveHand.cs is first and type the following and press enter: 

* mcs FiveHand.cs Card.cs Deck.cs Hand.cs

### Run
In the same directory, type the following and press enter to run the game:

* Randomized verion: mono FiveHand.exe
* File-Input Version: mono FiveHand.exe {filename}.txt

## C++
### Compile
To compile all the .cpp files make sure to have all the respective .h files as well in the directory. Then type the following and press enter: 

* g++ FiveHand.cpp Card.cpp Deck.cpp Hand.cpp

### Run
In the same directory, type the following and press enter to run the game:

* Randomized verion: ./.a.out
* File-Input Version: ./.a.out {filename}.txt

## Python
### Compile and Run
To compile and run all the .py files, type the following and press enter: 

* python3 FiveHand
* python3 FiveHand {filename}.txt

## Fortran
### Compile
To compile all the .f90 files, type the following (order does not matter) and press enter: 

* gfortran FiveHand.f90 Deck.f90 Card.f90 Hand.f90

### Run
In the same directory, type the following and press enter to run the game:

* Randomized verion: ./.a.out
* File-Input Version: ./.a.out {filename}.txt

## Author
Davis Guest  
CSC 330