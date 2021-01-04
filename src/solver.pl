
/* Solves puzzle Number from the database */
solve(Number) :-
    reset_timer,
    exampleBoard(Number, B, [Digits, Rows, Cols]),
    nl,nl,nl,
    printDivider(Cols),nl,
    printMatrix(B,Cols),
    nl,write('             Info'),nl,
    nl,write('Columns:  '),write(Cols),nl,
    write('Rows:     '),write(Rows),nl,
    write('Digits:   '),write(Digits),nl,
    nl,write('  Wait while puzzle is solved...'),nl,nl,nl,nl,nl,
    length(Solution, Digits),

    % Calc domain
    calcRowDomain(B, 0, Cols, [], RowListDomain),
    transpose(B, TB),
    calcColDomain(TB, 0, Cols,Rows, [], ColListDomain),

    list_to_fdset(RowListDomain, RowDomainSet),
    list_to_fdset(ColListDomain, ColDomainSet),
    fdset_intersection(RowDomainSet, ColDomainSet, DomainSet),
    applyDomain(Solution, DomainSet),
    all_distinct(Solution),

    % placing constraints
    constrainPlacing(Solution, Cols, Rows, B),
    insertSolution(Solution, 1, Cols, B, FinalBoard),
    % torque constraints
    torqueConstraint(FinalBoard),

    % write('Transposing...\n'),
    transpose(FinalBoard, TFBoard),
    torqueConstraint(TFBoard),
    labeling([], Solution),
    nl,write('           Solution '),nl,nl,
    printDivider(Cols),nl,
    printMatrix(FinalBoard,Cols),
    nl,write('         Statistics'),nl,
    print_time,
    fd_statistics,nl,nl.

/* Calculates Domain for Row */
calcRowDomain([], _, _, FinalList, FinalList).
calcRowDomain([H|T], Row, Cols, List, FinalList) :-
    NextRow is Row + 1,
    Edge is Cols - 1,
    findall(N, nth0(N, H, -1), Fulcrums),
    length(Fulcrums, NFulcrums),
    (
        (NFulcrums == 1, nth0(0, Fulcrums, Index), Index > 0, Index < Edge) -> Value is Row*Cols, addRowDomain(H,Value,List,List2)
        ; List2 = List
    ),
    calcRowDomain(T, NextRow, Cols, List2, FinalList).

/* Adds values from Row to Domain*/
addRowDomain([], _, FinalList, FinalList).
addRowDomain([H|T], Value, List, FinalList) :-
    NextValue is Value + 1,
    (
        H == 0 -> append(List, [Value], List2) ; List2 = List
    ),
    addRowDomain(T, NextValue, List2, FinalList).

/* Calculates Domain for Column */
calcColDomain([], _, _, _, FinalList, FinalList).
calcColDomain([H|T], Col, Cols,Rows, List, FinalList) :-
    NextCol is Col + 1,
    Edge is Rows - 1,
    findall(N, nth0(N, H, -1), Fulcrums),
    length(Fulcrums, NFulcrums),
    (
        (NFulcrums == 1, nth0(0, Fulcrums, Index), Index > 0, Index < Edge) -> addColDomain(H,0,Col,Cols, List, List2)
        ; List2 = List
    ),
    calcColDomain(T, NextCol, Cols, Rows, List2, FinalList).

/* Adds values from Column to Domain*/
addColDomain([],_,_,_,FinalList,FinalList).
addColDomain([H|T], Index, Col, Cols, List, FinalList) :-
    NextI is Index + 1,
    Value is Col + (Index * Cols),
    (
        H == 0 -> append(List, [Value], List2) ; List2 = List
    ),
    addColDomain(T, NextI, Col, Cols, List2, FinalList).

/* Applies domain the decision variables*/
applyDomain([],_).
applyDomain([H|T],DomainSet) :-
    H in_set DomainSet,
    applyDomain(T, DomainSet).

/* Places contrains to the decision variables*/
constrainPlacing([], _, _, _).
constrainPlacing([H|T], Cols, Rows, B) :-
    getNthElement(H, Cols, B, Value),
    Value #= 0,
    Line #= H/Cols,
    % Row
    getLine(0, Line, B, CurrentLine),
    findall(N, nth0(N, CurrentLine, -1), FulcrumsR),
    length(FulcrumsR, NFulcrumsRow),
    NFulcrumsRow #= 1,

    % Col
    transpose(B, B1),
    Row #= mod(H, Cols),
    getLine(0, Row, B1, CurrentRow),
    findall(NR, nth0(NR, CurrentRow, -1), FulcrumsL),
    length(FulcrumsL, NFulcrumsCol),
    NFulcrumsCol #= 1,

    % Constraints

    % Fulcrum position row
    nth0(0, FulcrumsR, FPosition1),
    length(CurrentLine, LineLength),
    FPosition1 #> 0, FPosition1 #< LineLength - 1,

    % Fulcrum position col
    nth0(0, FulcrumsL, FPosition2),
    length(CurrentRow, RowLength),
    FPosition2 #> 0, FPosition2 #< RowLength - 1,
    constrainPlacing(T, Cols, Rows, B).

/* Returns Nth element from board*/
getNthElement(N, Cols, Board, Value) :-
    I #= N/Cols, J #= mod(N, Cols),
    getValueFromMatrix(Board, I, J, Value).


/* Returns line from board*/
getLine(DesiredLine, DesiredLine, [H|_], H).
getLine(I, DesiredLine, [_H | T], Line) :-
    I #< DesiredLine,
    NextI #= I + 1,
    getLine(NextI, DesiredLine, T, Line).

/* Inserts the solution values to the board */
insertSolution([], _Index, _Cols, FinalBoard, FinalBoard).
insertSolution([N | T], Index, Cols, B, FinalBoard):-
    I #= N/Cols, J #= mod(N, Cols),

    replaceInMatrix(B,I,J,Index,B2),

    NextI #= Index + 1,
    insertSolution(T, NextI, Cols, B2, FinalBoard).

/* Places contrains to the decision variables*/
torqueConstraint([]).
torqueConstraint([H | T]) :-
    % write(H),nl,
    findall(N, nth0(N, H, -1), Fulcrums),
    length(Fulcrums, NFulcrumsRow),
    ((NFulcrumsRow #\= 1) ; (NFulcrumsRow #= 1), nth0(N1, H, -1), checkTorque(H, N1)),
    torqueConstraint(T).


/* check if torques at both sides are equal*/
checkTorque(List, N) :-
    leftTorque(List, 0, N, 0, LeftTorque),
    rightTorque(List, N, RightTorque),
    RightTorque #= LeftTorque.

/* calculate torque starting from the left */
leftTorque(_ ,N, N, FinalTorque, FinalTorque).
leftTorque([H|T], I, N, Torque, FinalTorque) :-
    NextI #= I + 1,
    TorqueTmp #= (N-I) * H + Torque,
    leftTorque(T, NextI, N, TorqueTmp, FinalTorque).

/* reverse list to calculate torque from the left (easier) */
rightTorque(List, N, FinalTorque):-
    reverse(List, ReversedList),
    length(List, L),
    NReversed #= L - N - 1,
    leftTorque(ReversedList, 0, NReversed, 0, FinalTorque).

/* Resets timer*/
reset_timer :- statistics(walltime,_).

/* Prints time*/
print_time :-
	statistics(walltime,[_,T]),
	TS is ((T//10)*10)/1000,
	nl, write('Time Spent: '), write(TS), write('s'), nl.