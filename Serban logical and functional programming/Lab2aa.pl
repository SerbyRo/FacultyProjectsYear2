%(i,i,i),(i,i,o)
%stergere(X,L,LR)
%X numarul pe care il cautam
%LR lista rezultata
stergere(_,[],[]).
stergere(E,[H|T],LR):-
	H = E,
	stergere(E,T,LR).
stergere(E,[H|T],LR):-
	H \= E,
	stergere(E,T,LR1),
	LR = [H|LR1].

%(i,o)
%minim(E,L)
%E este elementul pe care il vom adauga
minim([E],E).
minim([H|T],E):-
	minim(T,E2),
	E is min(H,E2).
%(i,o)
%insertsort(L,LR)
selectionsort([],[]).
selectionsort(L,LR):-
	minim(L,A),
	stergere(A,L,L2),
	selectionsort(L2,LR2),
	LR = [A|LR2].
