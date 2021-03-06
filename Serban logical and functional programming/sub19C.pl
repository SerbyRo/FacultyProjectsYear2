del(X,[X|L],L):-!.
del(X,[K|L],[K|LO]):-del(X,L,LO).

minList([MX],MX).
minList([LH|LT],MX):-
	minList(LT,MXS),
	MX is min(MXS,LH).

%sortare O(N^2)
isort([],[]).
isort(L,[MX|LO]):-
	minList(L,MX),
	del(MX,L,L2),
	isort(L2,LO).

pick([H|L],H,L).
pick([_|L],H,LO):-
	pick(L,H,LO).

findaux(_,0,_,_,[]):-!.

findaux([H|L],K,EL,RA,[H|LO]):-
	H-EL=:=RA,!,
	K1 is K-1,
	findaux(L,K1,H,RA,LO).

findaux([H|L],K,EL,RA,LO):-

	findaux(L,K,EL,RA,LO).


main(L,K,[H1,H2|LO]):-
	isort(L,LS),
	pick(LS,H1,LS1),
	pick(LS1,H2,LS2),
	DIF is H2-H1,
	K1 is K-2,
	findaux(LS2,K1,H2,DIF,LO).

find(L,K,LO):-
	findall(O,main(L,K,O),LO).



