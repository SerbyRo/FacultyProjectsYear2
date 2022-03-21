findaux([],S,S,0,[]).
findaux([_|T],S,SP,PF,LO):-
	findaux(T,S,SP,PF,LO).
findaux([H|T],S,SP,PF,[H|LO]):-
	SP1 is SP+H,
	PF1 is mod(PF+(1-mod(H,2)),2),
	SP1=<S,
	findaux(T,S,SP1,PF1,LO).

find(L,S,REZ):-
	findall(REZ2,findaux(L,S,0,0,REZ2),REZ).


allinsert(L,E,[E|L]).
allinsert([H|L],E,[H|LO]):-
	allinsert(L,E,LO).
shuffle([],[]).
shuffle([H|L],LO1):-
	shuffle(L,LO),
	allinsert(LO,H,LO1).
