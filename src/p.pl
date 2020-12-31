:- consult('board.pl').
:- consult('display.pl').
:- consult('solver.pl').
:- consult('utilities.pl').
:- use_module(library(clpb)).
:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(random)).

r :-
    reconsult('p.pl').

play :-
    generateRandomBoard(B, A),
    printMatrix(B).