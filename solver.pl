:- use_module(library(lists)).
:- use_module(library(clpfd)).

:- include('display.pl').

row_constraints([], _).
row_constraints([[Row,Gap]|T], Variables):- %iterates through the Row Restrictions list
    % nth1(1,H,Row), %from a restriction H, gets the Row it is refering to
    % nth1(2,H,Gap), %from a restriction H, gets the Gap
    Position2 is Row*2, %Position 1 and 2 refer to the indexes where the variables that define the black cells of the current Row 
    Position1 is Position2 - 1,
    element(Position1, Variables, Value1), %indicates Value1 as the element Position1 of list Variables
    element(Position2, Variables, Value2), %indicates Value2 as the element Position2 of list Variables
    Value2 - Value1 #= Gap + 1, %The distance between these two values must be Gap + 1 (since gap is the number of cells between these two), also implying Value2 > Value1
    row_constraints(T, Variables).

column_constraints([], _).
column_constraints([[Col,Gap]|T], Variables):- %iterates through the Column Restrictions list
    element(Position1, Variables, Col), %resolves the first position of the Variables list where the value is Col (as it matches the current restriction)
    element(Position2, Variables, Col), %resolves the second position where the same verifies
    Position2 #> Position1, %avoids symmetries and the absolute predicate by dictating Positio2 > Position1
    div(Position2, 2) + mod(Position2, 2) - (div(Position1, 2) + mod(Position1, 2)) #= Gap + 1, %in order to understand what the gap between the two rows is we must do: ceilling(Position1/2) - ceilling(Position2/2) = Gap + 1, each member of the subtraction results in the row where each Position belongs to
    column_constraints(T, Variables).

constrain([V1, V2]) :- %last row
    V2 #> 1 + V1.

constrain([V1, V2, V3, V4|T]) :- %constrain predicate is based on restricting the position of cells V1 and V2 (that refer to the black cells of each row), also making sure they keep a gap of at least 1 unit amongst themselves and the black cells on the row directly below, V3 and V4 
    V2 #> 1 + V1, %V2 must be greater than V1, and its distance must be greater than 1 unit (minimum gap of 1 unit)
    (V3 #> 1 + V1 #\/ V1 #> 1 + V3), %knowing V3 can be either greater of less than V1, we must define it for both cases, assuring a minimum gap of 1 unit
    (V4 #> 1 + V1 #\/ V1 #> 1 + V4), %knowing V4 can be either greater of less than V1, the same must be done
    (V3 #> 1 + V2 #\/ V2 #> 1 + V3), %knowing V3 can be either greater of less than V2, the same must be done
    (V4 #> 1 + V2 #\/ V2 #> 1 + V4), %knowing V4 can be either greater of less than V2, the same must be done
    constrain([V3, V4|T]).

solver(Variables, Size, [RowRestrictions,ColumnRestrictions|_], Cardinality):- %solver predicate receives Variables, Restrictions and Cardinality that where defined previously in the generator
    domain(Variables, 1, Size), %the variables must finish with a value between 1 and the Size (number of rows and columns)
    global_cardinality(Variables, Cardinality), %defining that each number from 1 to Size must appear exactly twice

    row_constraints(RowRestrictions, Variables), %apply restrictions relative to row gaps

    column_constraints(ColumnRestrictions, Variables), %apply restrictions relative to column gaps

    constrain(Variables), %apply restrictions relative to the space amongst every black cell

    labeling([], Variables), 
    print_board(Size, Variables, [RowRestrictions,ColumnRestrictions|_]). %final print