exampleBoard(B) :-
    B = [[blank, blank, blank, blank, blank, blank, fulcrum, blank],
    [blank, blank, blank, fulcrum, blank, blank, blank, blank],
    [fulcrum, blank, blank, blank, blank, blank, blank, fulcrum],
    [blank, blank, blank, blank, blank, blank, blank, blank],
    [blank, blank, blank, blank, blank, blank, blank, blank],
    [blank, blank, blank, blank, blank, fulcrum, blank, blank]].

symbol('blank', S) :- S = ' . '.
symbol('fulcrum', S) :- S = ' F '.


generateRandomBoard(Board) :-
    random(4, 10, Rows),
    random(4, 10, Cols),
    random(6, 9, Digits),
    random(5, 8, Fulcrums),
    format('Rows: ~p  Cols: ~p\nDigits: ~p Fulcrums: ~p\n', [Rows, Cols, 1-Digits, Fulcrums]),
    createBaseBoard(0, Rows, Cols, [], Board).


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
