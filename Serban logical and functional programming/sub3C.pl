findaux([],K,_,K,_,[]):-!.
findaux([H|T],K,V,NR,PR,[H|REZ]):-
       NR1 is NR+1,
       PR1 is PR*H,
       NR1=<K,
       PR1=<V,
       findaux(T,K,V,NR1,PR1,REZ).
findaux([_|T],K,V,NR,PR,REZ):-
	findaux(T,K,V,NR,PR,REZ).

find(L,K,V,REZ):-
	findall(REZ2,(findaux(L,K,V,0,1,REZ1),shuffle(REZ1,REZ2)),REZ).
allinsert(L,E,[E|L]).
allinsert([H|L],E,[H|LO]):-
	allinsert(L,E,LO).
shuffle([],[]).
shuffle([H|L],LO1):-
	shuffle(L,LO),
	allinsert(LO,H,LO1).
