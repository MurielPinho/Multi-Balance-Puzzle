:- consult('board.pl').
:- consult('display.pl').
:- consult('utilities.pl').
:- use_module(library(random)).

play :-
    exampleBoard(B),
    printMatrix(B, 1).