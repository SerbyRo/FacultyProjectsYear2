findaux(B,B,1,[]):-!.
findaux(A,B,SF,[A|LO]):-
	SF1 is mod(SF+A,2),
	A1 is A+1,
	A1=<B,
	findaux(A1,B,SF1,LO).

findaux(A,B,SF,LO):-
	A1 is A+1,
	A1=<B,
	findaux(A1,B,SF,LO).


find(A,B,REZ):-
	findall(REZ2,findaux(A,B,0,REZ2),REZ).


allinsert(L,E,[E|L]).
allinsert([H|L],E,[H|LO]):-
	allinsert(L,E,LO).
shuffle([],[]).
shuffle([H|L],LO1):-
	shuffle(L,LO),
	allinsert(LO,H,LO1).
