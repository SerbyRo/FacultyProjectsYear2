candidat(Element,[Element|_]).
candidat(Element,[_|Tail]):-
    candidat(Element,Tail).

suma_lista([],0).
suma_lista([H|T], Sum) :-
    suma_lista(T, Rest),
    Sum is H + Rest.

genereazaSolutii(_,Colector,_,Colector).
genereazaSolutii(Multime,Colector,Suma,[Head|Tail]):-
    candidat(NouElement,Multime),
    NouElement < Head,
    NouaSuma is Suma + NouElement,
    genereazaSolutii(Multime,Colector,NouaSuma,[NouElement|[Head|Tail]]).

submultimiSumaDivizibilaCu3(Multime, Colector):-
    candidat(Element, Multime),
    genereazaSolutii(Multime,Colector,Element,[Element]),
    suma_lista(Colector,Sum),
    Sum mod 3 =:= 0.

solutii(Multime,Sol):-
    findall(Colector, submultimiSumaDivizibilaCu3(Multime,Colector), Sol).
