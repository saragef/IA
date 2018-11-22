
%Limite de Cenário
limiteAltura(Y) :- Y > 0, Y =< 5, !.
limiteLargura(X) :- X > 0, X =< 5, !.
limiteCenario(X,Y) :- limiteLargura(X), limiteAltura(Y).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% [Fatos do Programa] %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

agente(Ashe).
pokemonAgente(pokAGT). %Pokebola.
