%(i,i,o)
%combinari(N,L,Rez)
%N-numarul de elemente continute intr-o combinare
%L-lista initiala
%Rez-lista rezultata
combinari(0,[],[]).
combinari(N,[H|T],[H|T1]):-
	N1 is N-1,
	combinari(N1,T,T1).

combinari(N,[_|T],Rez):-
	combinari(N,T,Rez).
%(i,o,o)
%extragere(L,N,Rez)
%N-numarul care va fi extras
%L-lista initiala
%Rez-lista rezultata
extragere([H|T],H,T).
extragere([H|T],N,[H|T1]):-
	extragere(T,N,T1).

%(i,o)
%extragere(L,Rez)
%L-lista initiala
%Rez-lista rezultata
shuffle([],[]).
shuffle(L,[H|T]):-
	extragere(L,H,L1),
	shuffle(L1,T).

%(i,i,o)
%combine (L,N,Rez)
%N-numarul care va fi extras
%L-lista initiala
%Rez-lista rezultata
combine(L,K,Rez):-
	combinari(K,L,Rez1),
	shuffle(Rez1,Rez).

%(i,i,o)
%afisarelistaaranjamente combine (L,N,Rez)
%N-numarul care va fi extras
%L-lista initiala
%Rez-lista rezultata
afisarelistaaranjamente(L,K,Rez):-
	findall(R,combine(L,K,R),Rez).


