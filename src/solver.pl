
% test row
row([1,0,0,0,0,0,fulcrum,6]).

/* testing function */
t :-
    generateRandomBoard(B),
    write('TORQUES FROM ROWS:\n'),
    row_constraint(B),
    printMatrix(B),nl,nl,
    write('TORQUES FROM COLS:\n'),
    transpose(B, B1),
    row_constraint(B1),
    printMatrix(B1).

/* constraint for row to be valid */
row_constraint([]).
row_constraint([List|T]) :-
    ((nth0(N, List, fulcrum, Remainder), \+nth0(_N1, Remainder, fulcrum), checkTorque(List, N)) % check row weight if only has 1 fulcrum
    ; (write(''))),
    row_constraint(T).

/* check if torques at both sides are equal*/
checkTorque(List, N) :-
    leftTorque(List, 0, N, 0, LeftTorque),
    rightTorque(List, N, RightTorque),
    format('Left TORQUE: ~p   Right TORQUE: ~p\n', [LeftTorque,RightTorque]).

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
