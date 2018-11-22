s([X,1],[X1,1]) :-	X < 5 , X1 is  X + 1, outro(X1,1).
s([X,1],[X1,1]) :-  X > 1 , X1 is  X - 1, outro(X1,1).

s([X,10],[X1,10]) :-	X < 5 , X1 is  X + 1, outro(X1,10).
s([X,10],[X1,10]) :-  X > 1 , X1 is  X - 1, outro(X1,10).

s([X,5],[X1,5]) :-	X < 5 , X1 is  X + 1, outro(X1,5).
s([X,5],[X1,5]) :-  X > 1 , X1 is  X - 1, outro(X1,5).

%vai para a direita.
s([X,Y],[X,H]) :- X < 6,Y < 10, H is Y + 1, muda_(X,H). 
%como ir para a esquerda sem passar pela direita.
s([X,Y],[X,H]) :- X < 6 , Y > 1 , H is Y - 1, muda_(X,H).

%Aqui dizemos onde esta o obstaculo caso esteja em uma coluna onde tenha o elevador, 
temos que tirar a variavel anonima e por uma variavel, para depois fazer a diferença. 
EX: outro(X,1) :- X =\= 3. dessa forma ele nao vai passar em (3,1), logo não vai poder pegar esse elevador no 3 andar. 
outro(_,1).
outro(_,5).
outro(_,10).

%Aqui ja mudamos o valor do Y, ja temos o exemplo abaixo, ele tem a mesma funcionalidade do outro, 
contudo foi necessario fazer o "muda" pq se nao poderia dar bugg,
%podendo ter duas verdades, ou verdades no momento errado.
muda_(1,_).
muda_(2,_).
muda_(3,H) :- H =\= 8.
muda_(4,_).
muda_(5,_).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%pega as caixas objetivos que estao soltas por ae, fazendo com que a procura não passe por esse caminho 
nao(Objetos) :- caixas(Objetos).
caixas([[2,5],[3,3]]).

metas([[2,3],[1,1],[2,2],[1,1]]).

meta(M1,Estado) :-  verdade(M1,Estado).

%essa linha abaixo é necessaria para fazer a comparação entre as filas, 
pois do modo que o prof passou so comparava um item por vez, nao uma lista.
verdade([[X|Cauda]|_],[X|Rim]) :- Cauda == Rim.

pertence(Elem,[Elem|_]).
pertence(Elem,[ _| Cauda]) :- pertence(Elem,Cauda).

concatena([],L,L).
concatena([Cab|Cauda],L2,[Cab|Resultado]) :- concatena(Cauda,L2,Resultado).

%inverte a solução para um melhor entendimento.
inv([],[]).
inv([E|C], Linv):-
	inv(C,C_Inv),
	concatena(C_Inv,[E], Linv).

%Ele da o objetivo alcançado ao novo outro, para começar da onde a busca havia terminado.
tira_Cabeca([P|_],P). 


%tira o primeiro objetivo alcançado e retorna o resto da lista.
vem(M1,M2) :- tira(M1,Y), retirar(Y,M1,M2).
tira([X|_],Y) :-  Y = X. 
retirar(Elem,[Elem|Cauda],Cauda).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

solucao_bl(Inicial,M1,Solucao,Restri) :- bl([[Inicial]],M1,Solucao,Restri).
%a solução cons=te em estender o caminho até a meta

bl([[Estado|Caminho]|_],M1,[Estado|Caminho],_) :- meta(M1,Estado).
%se não encontrou a meta, então estende o caminho até os decendentes

bl([Caminho|Outros],M1,Solucao,Restri):- estende(Caminho,NovoCaminho,Restri),
concatena(Outros,NovoCaminho,CaminhoAnterior), bl(CaminhoAnterior,M1,Solucao,Restri). 

%metodo que faz a extensao do caminho até os nos filhos
estende([Estado|Caminho],NovoCaminho,Restri):-  bagof([Sucessor,Estado|Caminho],(s(Estado,Sucessor),
not(pertence(Sucessor,Restri)),
	not(pertence(Sucessor,[Estado|Caminho]))), NovoCaminho),!.
		estende(_,[],_).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Estavamos com o problema de poder ter so um objetivo por execução do programa, entao fiz essa função abaixo, 
onde botamos os objetivos no arquivo mesmo,ele chama
% e faz a pesquisa com o primeiro objetivo da lista, depois em "vem(M1,M2)" ele tira a cabeça e envia 
a cauda para a proxima chamada, "tira2(M1,Y)" ja faz o contrario, ela tira a cabeça e vai para o lugar 
do "Inicial" para a procura começar de onde tinha parado na chamada anterior, "concatena" concatena 
as soluções e é onde esta um dos problemas, e depois so faz a chamada de novo.  



outro(Inicial,M1,Solucao2,[]) :- solucao_bl(Inicial,M1,Solucao1,[[]]),inv(Solucao1,Solucao2).

outro2(Inicial,M1,Solucao2,Restri) :- solucao_bl(Inicial,M1,Solucao1,Restri),inv(Solucao1,Solucao2).


%faz a chamada no programa aqui. br
br1(_,[],_,_).
br1(Inicial,M1,Solucao1,Restri) :-
		 %outro(Inicial,M1,Solucao1,[]),
			vem(M1,M2),
				tira_Cabeca(M1,Cabeca),
					outro2(Cebeca,M2,Solucao2,Restri),
						tira_Cabeca(M2,Nova_Cabeca),
							vem(Restri,Retorno_Restri),
								vem(M2,M3).
									br1(Nova_Cabeca,M3,_,Retorno_Restri).

%br1(Novo2,M3,[],Nova_Restri,Y).%caso recursivo.											


br(Inicial,Solucao) :- metas(M1),nao(Restri), br1(Inicial,M1,Solucao,Restri).



