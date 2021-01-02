:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(between)).
:- use_module(library(random)).

:- consult('board.pl').
:- consult('display.pl').
:- consult('solver.pl').
:- consult('utilities.pl').

r :-
    reconsult('p.pl').

process_input(Value, Min, Max) :-
    repeat, %Will repeat until the input is accepted
    read(Input),
    valid_input(Min, Max, Input),
    Value = Input.

process_input(Value, Min) :-
    repeat, %Will repeat until the input is accepted
    read(Input),
    valid_input(Min, Input),
    Value = Input.

%----valid inputs: evaluates if the input is in range
%Min =< Input =< Max
valid_input(Min, Max, Input):-
    number(Input),%verifies if the input is a number
    between(Min, Max, Input), !.

%it isn't a valid input
valid_input(_,_,_):-
    write('Insert valid puzzle option'), nl,
    false.

%Min =< Input
valid_input(Min, Input):-
    number(Input),%verifies if the input is a number
    Input >= Min, !.

%it isn't a valid input
valid_input(_,_):-
    write('Insert valid puzzle option'), nl,
    false.

menu(Option):-
    write('                                     '), nl,
    write('                                     '), nl,
    write('          __  __       _ _   _         '), nl,
    write('         |  \\/  |     | | | (_)        '), nl,
    write('         | \\  / |_   _| | |_ _         '), nl,
    write('         | |\\/| | | | | | __| |        '), nl,
    write('         | |  | | |_| | | |_| |        '), nl,
    write('    ____ |_|  |_|\\__,_|_|\\__|_|        '), nl,
    write('   |  _ \\      | |                     '), nl,
    write('   | |_) | __ _| | __ _ _ __   ___ ___ '), nl,
    write('   |  _ < / _` | |/ _` | \\_ \\ / __/ _ \\'), nl,
    write('   | |_) | (_| | | (_| | | | | (_|  __/'), nl,
    write('   |____/ \\__,_|_|\\__,_|_| |_|\\___\\___|'), nl,
    write('                                       '), nl,
    write('                                     '), nl,
    write('                                     '), nl,
    write('Insert the puzzle number to be solved (1-4).'), nl,   
    process_input(Option, 1, 4). 

play :-
    menu(Option),
    solve(Option).