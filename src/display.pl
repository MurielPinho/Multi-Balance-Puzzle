/*Prints a matrix using recursion*/
printMatrix([]).
printMatrix([Head|Tail]) :-
    printLine(Head),
    nl,
    printMatrix(Tail).

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