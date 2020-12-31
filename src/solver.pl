
% test row
row([1,0,0,0,0,0,-1,6]).

/* testing function */
t :-
    % generateRandomBoard(B, [Digits, Rows, Cols]),
    exampleBoard2(B, [Digits, Rows, Cols]),
    write('Solving...'),nl,
    % Digits is 6, Rows is 6, Cols is 8,
    length(Solution, Digits),
    Dom is Rows * Cols - 1,
    domain(Solution, 0, Dom),
    all_different(Solution),

    % placing constraints
    constrainPlacing(Solution, Cols, Rows, B),
    addSolution(Solution, 1, Cols, B, FinalBoard),

    % torque constraints
    torqueConstraint(FinalBoard),

    labeling([], Solution),
    write(Solution),nl,

    % write('TORQUES FROM ROWS:\n'),
    % row_constraint(B),
    % printMatrix(B),nl,nl,
    % write('TORQUES FROM COLS:\n'),
    % transpose(B, B1),
    % row_constraint(B1),
    printMatrix(FinalBoard).

constrainPlacing([], _, _, _).
constrainPlacing([H|T], Cols, Rows, B) :-
    getNthElement(H, Cols, B, Value),
    Line #= H/Cols,
    % Row
    getLine(0, Line, B, CurrentLine),
    findall(N, nth0(N, CurrentLine, -1), FulcrumsR),
    length(FulcrumsR, NFulcrumsRow),
    % Col
    transpose(B, B1),
    Row #= mod(H, Cols),
    getLine(0, Row, B1, CurrentRow),
    findall(NR, nth0(NR, CurrentRow, -1), FulcrumsL),
    length(FulcrumsL, NFulcrumsCol),

    % Constraints
    Value #= 0, NFulcrumsRow #= 1,
    NFulcrumsCol #= 1,

    % Fulcrum position row
    nth0(0, FulcrumsR, FPosition1),
    length(CurrentLine, LineLength),
    FPosition1 #> 0, FPosition1 #< LineLength - 1,

    % Fulcrum position col
    nth0(0, FulcrumsL, FPosition2),
    length(CurrentRow, RowLength),
    FPosition2 #> 0, FPosition2 #< RowLength - 1,
    constrainPlacing(T, Cols, Rows, B).


getNthElement(N, Cols, Board, Value) :-
    I #= N/Cols, J #= mod(N, Cols),
    % format('[~p,~p]\n',[I,J]),
    getValueFromMatrix(Board, I, J, Value).

getLine(DesiredLine, DesiredLine, [H|_], H).
getLine(I, DesiredLine, [H | T], Line) :-
    I #< DesiredLine,
    NextI #= I + 1,
    getLine(NextI, DesiredLine, T, Line).

addSolution([], _Index, _Cols, FinalBoard, FinalBoard).
addSolution([N | T], Index, Cols, B, FinalBoard):-
    I #= N/Cols, J #= mod(N, Cols),

    replaceInMatrix(B,I,J,Index,B2),

    NextI #= Index + 1,
    addSolution(T, NextI, Cols, B2, FinalBoard).

torqueConstraint([]).
torqueConstraint([H | T]) :-
    % write(H),nl,
    findall(N, nth0(N, H, -1), Fulcrums),
    length(Fulcrums, NFulcrumsRow),
    ((NFulcrumsRow #\= 1) ; (NFulcrumsRow #= 1), nth0(N1, H, -1), checkTorque(H, N1)),

    torqueConstraint(T).


/* constraint for row to be valid */
row_constraint([]).
row_constraint([List|T]) :-
    ((nth0(N, List, -1, Remainder), \+nth0(_N1, Remainder, -1), checkTorque(List, N)) % check row weight if only has 1 fulcrum
    ; (write(''))),
    row_constraint(T).

/* check if torques at both sides are equal*/
checkTorque(List, N) :-
    leftTorque(List, 0, N, 0, LeftTorque),
    rightTorque(List, N, RightTorque),
    RightTorque #= LeftTorque.
    % format('Left TORQUE: ~p   Right TORQUE: ~p\n', [LeftTorque,RightTorque]).

/* calculate torque starting from the left */
leftTorque(_ ,N, N, FinalTorque, FinalTorque).
leftTorque([H|T], I, N, Torque, FinalTorque) :-
    NextI #= I + 1,
    % format('(~p - ~p) * ~p + ~p', [N,I,H,Torque]),nl, might need this later
    TorqueTmp #= (N-I) * H + Torque,
    leftTorque(T, NextI, N, TorqueTmp, FinalTorque).

/* reverse list to calculate torque from the left (easier) */
rightTorque(List, N, FinalTorque):-
    reverse(List, ReversedList),
    length(List, L),
    NReversed #= L - N - 1,
    leftTorque(ReversedList, 0, NReversed, 0, FinalTorque).
