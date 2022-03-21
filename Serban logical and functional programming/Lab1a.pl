adauga([],E,_,[E]).
adauga(L,E,0,[E|L]).
adauga([H|T],E,N,[H|REZ2]):-
	N>0,
	N1 is N-1,
	adauga(T,E,N1,REZ2).
