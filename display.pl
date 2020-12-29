:- use_module(library(lists)).

print_board(Dimension, Solutions, Restrictions):- 
    End is Dimension + 1, %End defines index where the printing ends
    start_print(1, End, Dimension, Restrictions, Solutions).

start_print(End, End, _, [_,ColumnRestrictions|_],_):- %In this case, the board has been printed but we need to print the column restricitons
    print_restrictioned_columns(1, End, ColumnRestrictions),
    !.

start_print(Row, End, Dimension, Restrictions, [C1, C2|NextLines]):- %in each row we must print 2 black cells corresponding to C1 and C2
    print_row(1, End, C1, C2), %prints row
    is_restrictioned_row(Restrictions, Row), %checks if it is a restrictioned row
    nl,
    NextRow is Row + 1, %we iterate to the next row
    start_print(NextRow, End, Dimension, Restrictions, NextLines).

%-----------print restrictions-------------
%Row
is_restrictioned_row([RowRestrictions|_], Row):-
    search(RowRestrictions, Row). %check if the row exists in RowRestrictions (is restrictioned)

%column
print_restrictioned_columns(End, End, _):- !. %reached the limit of the board
print_restrictioned_columns(Column, End, ColumnRestrictions):- %will print a line composed of column restrictions and blank spaces after the board is printed
    search(ColumnRestrictions, Column), %searches if Column is restrictioned
    NextColumn is Column + 1, %iterates to next column
    print_restrictioned_columns(NextColumn, End, ColumnRestrictions).
    
%search restrictions for a specific row or column
search([], _):- write('  '). %if no restriction for a particular line is found, then a mock blank space (' ') is printed instead

search([[Line|T]|_], Line):- %if line Line can be unified with a line in a restriction tuple element
    write(' '), 
    nth1(1,T,Gap), %get the gap for the line constraint
    write(Gap), %print the value
    !.

search([_|T], Line):- %in this case, its not a match, so we keep looking
    search(T, Line).
    

print_row(End, End, _, _). %Reached end of the board
print_row(Col, End, C1, C2):- %prints row, column by column, knowing C1 and C2 are the two black cells in this refered line
    write(' '), 
    getCell(Col, C1, C2, Cell), %defines which cell (0 or 1) is supposed to be printed
    write(Cell), 
    NextCol is Col + 1, %iterates to next column
    print_row(NextCol, End, C1, C2).

%Defines if the selected Col can be unified with parameters C1 and C2 (resolving the print of a black cell: value 1) or none of them (resolving the print of a white cell: value 0)
getCell(Col, Col,_, 1):-!.
getCell(Col, _, Col, 1):-!.
getCell(_, _, _, 0):-!.

