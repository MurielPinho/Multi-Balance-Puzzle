exampleBoard(B) :-
    B = [[0, 0, 0, 0, 0, 0, fulcrum, 0],
    [0, 0, 0, fulcrum, 0, 0, 0, 0],
    [fulcrum, 0, 0, 0, 0, 0, 0, fulcrum],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, fulcrum, 0, 0]].

emptyBoard(B) :-
    B = [[0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0]].

symbol('fulcrum', S) :- S = ' F '.
symbol(0, S) :- S = ' . '.
symbol(1, S) :- S = ' 1 '.
symbol(2, S) :- S = ' 2 '.
symbol(3, S) :- S = ' 3 '.
symbol(4, S) :- S = ' 4 '.
symbol(5, S) :- S = ' 5 '.
symbol(6, S) :- S = ' 6 '.
symbol(7, S) :- S = ' 7 '.
symbol(8, S) :- S = ' 8 '.
symbol(9, S) :- S = ' 9 '.

%%%%%%%%%%%%%
% FUNCTIONS %
%%%%%%%%%%%%%

/* Generates a random board and fills it with fulcrums and numbers */
generateRandomBoard(FinalBoard) :-
    clear,
    random(4, 10, Rows),
    random(4, 10, Cols),
    random(6, 9, Digits),
    random(5, 8, Fulcrums),
    format('Rows: ~p  Cols: ~p\nDigits: ~p Fulcrums: ~p\n', [Rows, Cols, 1-Digits, Fulcrums]),
    createBaseBoard(0, Rows, Cols, [], Board),
    addFulcrums(0, Fulcrums, Rows, Cols, Board, FinalBoard1),
    addNumbers(0, Digits, Rows, Cols, FinalBoard1, FinalBoard).


/* creates the base for the board */
createBaseList(J, J, TmpList, FinalList):- FinalList = TmpList.
createBaseList(J, Cols, TmpList, FinalList) :-
    J < Cols,
    J1 is J + 1,
    append(TmpList, [0], TmpList2),
    createBaseList(J1, Cols, TmpList2, FinalList).
createBaseBoard(Rows, Rows, Cols, TmpBoard, FinalBoard) :- TmpBoard = FinalBoard.
createBaseBoard(I, Rows, Cols, TmpBoard, FinalBoard) :-
    I < Rows,
    I1 is I + 1,
    createBaseList(0, Cols, [], FinalList),
    append(TmpBoard, [FinalList], TmpBoard2),
    createBaseBoard(I1, Rows, Cols, TmpBoard2, FinalBoard).


/* adds fulcrums on board */
addFulcrums(Fulcrums, Fulcrums, _, _, CurrBoard, FinalBoard) :- FinalBoard = CurrBoard.
addFulcrums(Current, Fulcrums, Rows, Cols, CurrBoard, FinalBoard) :-
    Current < Fulcrums,
    Next is Current + 1,
    addFulcrum(Rows, Cols, CurrBoard, I, J),
    replaceInMatrix(CurrBoard, I, J, fulcrum, CurrBoard2),
    addFulcrums(Next, Fulcrums, Rows, Cols, CurrBoard2, FinalBoard).
/*generates valid fulcrum to add*/
addFulcrum(Rows, Cols, CurrBoard, I, J):-
    repeat, % repeat until a valid fulcrum is found
    random(0, Rows, Row), random(0, Cols, Col),
    checkEdges(Row, Col, Rows, Cols),
    (\+getValueFromMatrix(CurrBoard, Row, Col, _) | getValueFromMatrix(CurrBoard, Row, Col, 0)),
    checkSides(Row, Col, CurrBoard),
    I = Row, J = Col.


/* check if coords are valid (not on edges) */
checkEdges(Row, Col, Rows, Cols) :-
    RowIndex is Rows - 1, ColIndex is Cols - 1,
    (Row \= 0 ; Col \= 0), (Row \= RowIndex | Col \= ColIndex),
    (Row \= 0 | Col \= ColIndex), (Col \= 0 | Row \= RowIndex).
/* check if cells around are 0 */
checkSides(Row, Col, CurrBoard) :-
    PrevRow is Row - 1, PrevCol is Col - 1,
    NextRow is Row + 1, NextCol is Col + 1,
    (\+getValueFromMatrix(CurrBoard, PrevRow, Col,_) | getValueFromMatrix(CurrBoard, PrevRow, Col, 0)), % above
    (\+getValueFromMatrix(CurrBoard, NextRow, Col,_) | getValueFromMatrix(CurrBoard, NextRow, Col, 0)), % below
    (\+getValueFromMatrix(CurrBoard, Row, PrevCol,_) | getValueFromMatrix(CurrBoard, Row, PrevCol, 0)), % left
    (\+getValueFromMatrix(CurrBoard, Row, NextCol,_) | getValueFromMatrix(CurrBoard, Row, NextCol, 0)). % right


/* adds numbers to board */
addNumbers(NMax, NMax, _,_,FinalBoard, FinalBoard).
addNumbers(N, NMax, Rows, Cols, Board, FinalBoard) :-
    N1 #= N + 1,
    placeNumber(Rows, Cols, Board, Board2, N1),
    addNumbers(N1, NMax, Rows, Cols, Board2, FinalBoard).
placeNumber(Rows, Cols, Board, Board2, N1) :-
    repeat,
    random(0, Rows, Row), random(0, Cols, Col),
    getValueFromMatrix(Board, Row, Col, 0),
    replaceInMatrix(Board, Row, Col, N1, Board2).
