cmmdc(A,0,A).
cmmdc(0,B,B).
cmmdc(A,B,R):-
	B>0,
	A1 is mod(A,B),
	cmmdc(B,A1,R).

lcmmdc([L],L).
lcmmdc([H|T],REZ):-
	lcmmdc(T,REZ2),
	cmmdc(H,REZ2,REZ).
