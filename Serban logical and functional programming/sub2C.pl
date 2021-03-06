take([E],E,[]).
take([H|L],E,[H|LO]):-
     take(L,E,LO).

perms([],_,[]).
perms(L,EL,[H|LO]):-
      take(L,H,LO1),
      abs(EL-H)>=2,
      perms(LO1,H,LO).
listN(0,[]):-!.
listN(N,[N|LO]):-
     N1 is N-1,
     listN(N1,LO).

findPerms(N,L):-
     listN(N,LN),
     findall(LO,perms(LN,-5,LO),LN).



