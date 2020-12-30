%                               reconsult('p.pl').

start:-
    Dimension is 10,
    Size is Dimension*2,
    length(Variables,Size),
    !,
    solver().


solver(Variables,) :-

.