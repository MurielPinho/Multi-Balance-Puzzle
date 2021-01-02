/*Prints a matrix using recursion*/
printMatrix([],_).
printMatrix([Head|Tail],Cols) :-
    write('|'),
    printLine(Head),
    nl,
    printDivider(Cols),
    nl,
    printMatrix(Tail,Cols).

/*Prints a line from a matrix*/
printLine([]).
printLine([Head|Tail]) :-
    symbol(Head, S),
    write(S),
    write('|'),
    printLine(Tail).

printDivider(0).
printDivider(N) :-
    write('----'),
    Temp is N - 1,
    printDivider(Temp).

/* Clear the screen to display less information */
clear :-
    write('\33\[2J').