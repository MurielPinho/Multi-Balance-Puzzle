:- use_module(library(random)).
:- use_module(library(between)).
:- use_module(library(lists)).

:- include('solver.pl').


%--------process input---------
%processes until a valid input is inserted, depending on the range the input must belong in (it calls different valid-inputs predicates)
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
    write('Insert valid option'), nl,
    false.

%Min =< Input
valid_input(Min, Input):-
    number(Input),%verifies if the input is a number
    Input >= Min, !.

%it isn't a valid input
valid_input(_,_):-
    write('Insert valid option'), nl,
    false.


%---------ask board restrictions-----------
%in this case, restrictions must be given by the user
ask_restrictions(Dimension, [RowRestrictions,ColRestrictions|_]):-
    valid_line_restrictions(row, Dimension, RowRestrictions), %collect row restrictions
    valid_line_restrictions(column, Dimension, ColRestrictions). %collect column restrictions

valid_line_restrictions(Line, Dimension, LineRestrictions):-
    repeat, %Will repeat until the input is accepted
    write_message(Line), %write message with input format
    read(Input),
    is_list(Input), %verifies if the input is a list
    valid_restrictions(Dimension, Input), %validates restrictions
    LineRestrictions = Input. %finishes by accepting the input and unifying it with LineRestrictions

valid_restrictions(_, []).
valid_restrictions(Dimension, [H|T]):- %All restrictions contained on the list received in the second parameter must obey
    nth1(1,H,Line),
    between(1, Dimension, Line), %Verifies if line is 1=<Line=<Dimension
    nth1(2,H,Gap),
    MaxGap is Dimension - 2, %the maximum value Gap is defined by board size - 2
    between(1, MaxGap, Gap), %1=<Gap=<MaxGap
    valid_restrictions(Dimension, T).

%---restriction input format message
write_message(row):- %restriction input format message
    write('Insert row restrictions in the format: [[Row,Gap],[Row2,Gap2], ...]'), nl.
write_message(column):-
    write('Insert column restrictions in the format: [[Column,Gap],[Column2,Gap2], ...]'), nl.


%---------generate board restrictions-----------
%in this case, restrictions must be generated randomly
generate_restrictions(Dimension, [RowRestrictions, ColRestrictions|_]) :-
    number_of_restrictions(OnRow, OnColumn, Dimension), %decide the number of restrictions depending on the dimension of the board
    generate(OnRow, Dimension, [], [], RowRestrictions), %generate row restrictions
    generate(OnColumn, Dimension, [], [], ColRestrictions). %generate Column restrictions

%get number of restrictions
number_of_restrictions(OnRow, OnColumn, Dimension):-
    Rest is Dimension mod 2, %resolves if dimension is even or odd
    get_restrictions_number(Rest, OnRow, OnColumn, Dimension).

get_restrictions_number(0, OnRow, OnColumn, Dimension):- %if dimension is even
    OnRow is 2 + ((Dimension - 10)/2), % defines the number of restrictions knowing that when Dimension = 10 there are 2 row restrictions, and it only increments on even dimensions
    OnColumn is OnRow - 1. %in this case, the restriction number in columns is always 1 less than in rows

get_restrictions_number(1, OnRow, OnColumn, Dimension):- %if dimension is odd
    OnRow is 1 + ((Dimension - 9)/2), %defines the number of restrictions knowing that when Dimension = 9 there is 1 row restriction, and it only increments on odd dimensions
    OnColumn is OnRow. %in this case, the restriction numbers in column and rows are the same

%-----generate restrictions
generate(0.0, _, _, AuxRestrictions, AuxRestrictions). %0.0 is due to OnRow and OnColumn value being floats
generate(N, Dimension, AuxList, AuxRestrictions, Restrictions):- 
    valid_line(AuxList, Dimension, Line), %in AuxList we store the lines that have already been restricted
    append(AuxList, [Line], AuxList2), %adds new restricted line to AuxList
    MaxGap is Dimension - 2, %the maximum value Gap is defined by board size - 2
    random(1, MaxGap, Gap), %Generates a random number for the Gap knowing 1=<Gap=<MaxGap
    append(AuxRestrictions, [[Line, Gap]], AuxRestrictions2), %Adds new restriction to list
    N2 is N - 1, %only N2  more restrictions to define
    generate(N2, Dimension, AuxList2, AuxRestrictions2, Restrictions).

%get a valid line    
valid_line(AuxList, Dimension, Line):-
    repeat, %Repeats until a valid line is generated
    random(1, Dimension, AuxLine), %generates a number 1=<AuxLine=<Dimension
    \+member(AuxLine, AuxList),%checks if AuxLine is already in AuxList
    Line = AuxLine.%in case of success, unifies Line accepts the value of AuxLine


%----CARDINALITY
%cardinality is meant to be used on predicate global_cardinality call on solver predicate, this is meant to define how many times each number shall appear in the solution
%it is defined by a list in the format: [1-2,2-2,3-2,...,Dimension-2]
define_cardinality(Dimension, Dimension, Aux, Aux). 
define_cardinality(Col, Dimension, Aux, Cardinality):-
    append(Aux, [Col-2], Aux2), %each element is defined as Col-2 because each Column must appear twice in the solution
    Col2 is Col + 1,
    define_cardinality(Col2, Dimension, Aux2, Cardinality).

%---------MENU----------
menu(Value, Dimension):-
    write('----------------GAP PUZZLE----------------'), nl,
    write('Insert 1 to solve an original puzzle'), nl,
    write('Insert 2 to generate a puzzle'), nl,
    process_input(Value, 1, 2), %garantees value inputed by user is between 1 and 2
    write('Insert dimension'), nl,    
    process_input(Dimension, 9). %garantees that the minimum board dimension is 9

%---------OPTIONS----------
option(1, Variables, Cardinality, Dimension, Restrictions):- %in this case, the user will create the game in a manual way
    Size is Dimension*2, %the Variables list, used for labelling, is defined by Dimension*2 variables that each represent a black cell 
    length(Variables, Size), %declares variables within the list
    End is Dimension + 1, %End is used to define where the cardinality list stops when created recursively
    define_cardinality(1, End, [], Cardinality), %defines cardinality as explained before
    ask_restrictions(Dimension, Restrictions). %asks restrictions to user

option(2, Variables, Cardinality, Dimension, Restrictions):- %in this case, the game will be randomly generated
    Size is Dimension*2, %the Variables list, used for labelling, is defined by Dimension*2 variables that each represent a black cell 
    length(Variables, Size), %declares variables within the list
    End is Dimension + 1, %End is used to define where the cardinality list stops when created recursively
    define_cardinality(1, End, [], Cardinality), %defines cardinality as explained before
    generate_restrictions(Dimension, Restrictions). %generates restrictions

print_details(Dimension, [RowRest, ColRest|_]):- %simply prints game details for the user to be aware
    write('Dimension: '), write(Dimension), nl,
    write('Row Restrictions: '), write(RowRest), nl,
    write('Column Restrictions: '), write(ColRest), nl.


%---------START-----------
start:-
    menu(Value, Dimension),
    option(Value, Variables, Cardinality, Dimension, Restrictions), %calls procedure depending on the option selected in menu
    print_details(Dimension, Restrictions),
    !,%in case solver fails, we shall not go back, but finish
    solver(Variables, Dimension, Restrictions, Cardinality). %calls the solver predicate