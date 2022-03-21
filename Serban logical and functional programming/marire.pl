sumpar(_,0,0,[]):-!.
sumpar([H|T],k,F,LO):-
	F1 is (F+H) mod 2,
	k1 is k-1,
	sumpar(T,k1,F1,LO).
sumpar([_|T],k,F,LO):-
	sumpar(T,k,F,LO).

sumpar_wrapper(L,k,LO):-
	findall(LO1,sumpar(L,k,0,LO1),LO).
