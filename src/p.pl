:- consult('board.pl').
:- consult('display.pl').
:- consult('utilities.pl').
:- use_module(library(lists)).
:- use_module(library(random)).

play :-
    generateRandomBoard(B1),
    printMatrix(B1).