:- consult('board.pl').
:- consult('display.pl').
:- consult('utilities.pl').
?- use_module(library(clpb)).
:- use_module(library(lists)).
:- use_module(library(random)).

% reconsult file
r :-
    reconsult('p.pl').

play :-
    generateRandomBoard(B1),
    printMatrix(B1).