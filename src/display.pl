/*Prints a matrix using recursion*/
printMatrix([], _N).
printMatrix([Head|Tail], N) :-
    % border('v',VerticalBorder),
    % border(N,HorizontalBorder),
    % indice(N, I),
    % write(I),
    N1 is N + 1,
    printLine(Head),
    % write(VerticalBorder),nl,
    % write(HorizontalBorder),
    nl,
    printMatrix(Tail, N1).

/*Prints a line from a matrix*/
printLine([]).
printLine([Head|Tail]) :-
    symbol(Head, S),
    write(S),
    write(' '),
    printLine(Tail).

/* Clear the screen to display less information */
clear :-
    write('\33\[2J').