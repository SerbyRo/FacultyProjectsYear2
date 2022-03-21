merge([], H,H):- !.
merge(H,[],H):- !.
merge([H1|T1],[H2|T2],[H1|REZ]):-
	H1<H2,
	merge(T1,[H2|T2],REZ), !.
merge([H1|T1],[H2|T2],[H2|REZ]):-
	H1>H2,
	merge([H1|T1],T2,REZ),!.
merge([H1|T1],[H2|T2],[H1|REZ]):-
	H1=:=H2,
	merge(T1,T2,REZ).

split([],[],[]):-!.
split([A],[A],[]):-!.
split([H1,H2|T],[H1|REZ1],[H2|REZ2]):-
	split(T,REZ1,REZ2).

mergesort([],[]):-!.
mergesort([H],[H]):-!.
mergesort(L,REZ):-
	split(L,P1,P2),
	merge(P1,REZ1),
	merge(P2,REZ2),
	mergesort(REZ1,REZ2,REZ).

