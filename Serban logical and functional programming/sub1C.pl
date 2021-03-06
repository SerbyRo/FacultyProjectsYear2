%(i,i,i,o)
%
findaux([],0,1,[]).
findaux([H|T],PN,PS,[H|Rez]):-
       PN1 is 1-PN,
       PS1 is mod(H+PS,2),
       findaux(T,PN1,PS1,Rez).
findaux([_|T],PN,PS,REZ):-
	findaux(T,PN,PS,REZ).

find(L,REZ):-
	findall(REZ2,(findaux(L,0,0,REZ1),shuffle(REZ1,REZ2)),REZ).
allinsert(L,E,[E|L]).
allinsert([H|L],E,[H|LO]):-
	allinsert(L,E,LO).
shuffle([],[]).
shuffle([H|L],LO1):-
	shuffle(L,LO),
	allinsert(LO,H,LO1).

