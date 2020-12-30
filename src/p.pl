:- consult('board.pl').
:- consult('display.pl').
:- consult('utilities.pl').
?- use_module(library(clpb)).
?- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(random)).

r :-
    reconsult('p.pl').

play :-
    generateRandomBoard(B),
    printMatrix(B).