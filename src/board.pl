exampleBoard(B) :-
    B = [[blank, blank, blank, blank, blank, blank, fulcrum, blank],
    [blank, blank, blank, fulcrum, blank, blank, blank, blank],
    [fulcrum, blank, blank, blank, blank, blank, blank, fulcrum],
    [blank, blank, blank, blank, blank, blank, blank, blank],
    [blank, blank, blank, blank, blank, blank, blank, blank],
    [blank, blank, blank, blank, blank, fulcrum, blank, blank]].

symbol('blank', S) :- S = ' . '.
symbol('fulcrum', S) :- S = ' F '.
