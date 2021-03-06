nraparitii(_,[],0).
nraparitii(E,[E|L],S):-!,
	nraparitii(E,L,S1),
	S is S1+1.


nraparitii(E,[_|L],S):-
	nraparitii(E,L,S).

eliminaaux([],_,[]).
eliminaaux([H|L],LI,[H|LO]):-
	nraparitii(H,LI,AP),
	AP=\=1,!,
	eliminaaux(L,LI,LO).

eliminaaux([_|L],LI,LO):-
	eliminaaux(L,LI,LO).

elimina(L,LI):-
	eliminaaux(L,L,LI).

stergecresc([],[]).
stergecresc([H],[H]).
stergecresc([H1,H2],[]):-H1<H2.


stergecresc([H1,H2,H3|T],R):-
	H1<H2,
	H2<H3,
	stergecresc([H2,H3|T],R).
stergecresc([H1,H2,H3]|T,R):-
	H1<H2,
	H2>=H3,
	stergecresc([H3|T],R).

stergecresc([H1,H2|T], [H1|R]):-
	H1 >= H2,
	stergecresc([H2|T], R).

