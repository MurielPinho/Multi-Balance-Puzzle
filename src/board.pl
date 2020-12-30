exampleBoard(B) :-
    B = [[blank, blank, blank, blank, blank, blank, fulcrum, blank],
    [blank, blank, blank, fulcrum, blank, blank, blank, blank],
    [fulcrum, blank, blank, blank, blank, blank, blank, fulcrum],
    [blank, blank, blank, blank, blank, blank, blank, blank],
    [blank, blank, blank, blank, blank, blank, blank, blank],
    [blank, blank, blank, blank, blank, fulcrum, blank, blank]].

symbol('blank', S) :- S = ' . '.
symbol('fulcrum', S) :- S = ' F '.


generateRandomBoard(FinalBoard) :-
    random(4, 10, Rows),
    random(4, 10, Cols),
    random(6, 9, Digits),
    random(5, 8, Fulcrums),
    format('Rows: ~p  Cols: ~p\nDigits: ~p Fulcrums: ~p\n', [Rows, Cols, 1-Digits, Fulcrums]),
    createBaseBoard(0, Rows, Cols, [], Board),
    addFulcrums(0, Fulcrums, Rows, Cols, Board, FinalBoard).


/* creates the base for the board */
createBaseList(J, J, TmpList, FinalList):- FinalList = TmpList.
createBaseList(J, Cols, TmpList, FinalList) :-
    J < Cols,
    J1 is J + 1,
    append(TmpList, [blank], TmpList2),
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

    (\+getValueFromMatrix(CurrBoard, Row, Col, _) | getValueFromMatrix(CurrBoard, Row, Col, blank)),

    checkSides(Row, Col, CurrBoard),

    I = Row, J = Col.

/* check if coords are valid (not on edges) */
checkEdges(Row, Col, Rows, Cols) :-
    RowIndex is Rows - 1, ColIndex is Cols - 1,
    (Row \= 0 ; Col \= 0), (Row \= RowIndex | Col \= ColIndex),
    (Row \= 0 | Col \= ColIndex), (Col \= 0 | Row \= RowIndex).

/* check if cells around are blank */
checkSides(Row, Col, CurrBoard) :-
    PrevRow is Row - 1, PrevCol is Col - 1,
    NextRow is Row + 1, NextCol is Col + 1,
    (\+getValueFromMatrix(CurrBoard, PrevRow, Col,_) | getValueFromMatrix(CurrBoard, PrevRow, Col, blank)), % above
    (\+getValueFromMatrix(CurrBoard, NextRow, Col,_) | getValueFromMatrix(CurrBoard, NextRow, Col, blank)), % below
    (\+getValueFromMatrix(CurrBoard, Row, PrevCol,_) | getValueFromMatrix(CurrBoard, Row, PrevCol, blank)), % left
    (\+getValueFromMatrix(CurrBoard, Row, NextCol,_) | getValueFromMatrix(CurrBoard, Row, NextCol, blank)). % right

