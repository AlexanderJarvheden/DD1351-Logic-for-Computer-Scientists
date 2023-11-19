% Labb i logikprogrammering, 


% Här är några generellt användbara definitioner av 
% predikat som du kan använda:
% Andra predikat som definierats i bibliotek i ert 
% prologsystem får inte användas. Skriv definitionen
% explicit, kanske med ett annat namn,
% så att den inte krockar.

append([],L,L).
append([H|T],L,[H|R]) :- append(T,L,R).

appendEl(X, [], [X]).
appendEl(X, [H | T], [H | Y]) :-
           appendEl(X, T, Y).

length([],0).
length([_|T],N) :- length(T,N1), N is N1+1.

nth(N,L,E) :- nth(1,N,L,E).
nth(N,N,[H|_],H).
nth(K,N,[_|T],H) :- K1 is K+1, nth(K1,N,T,H).

subset([], []).
subset([H|T], [H|R]) :- subset(T, R).
subset([_|T], R) :- subset(T, R).

select(X,[X|T],T).
select(X,[Y|T],[Y|R]) :- select(X,T,R).

member(X,L) :- select(X,L,_).

memberchk(X,L) :- select(X,L,_), !.


% Uppgifterna 1, 2, 3, 4 skall läsas för godkänt betyg! 
% Den sista uppgiften ger inga extra poäng.
% De angivna poängtalen visar ungefärliga svårighetsgraden.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% uppgift 1	(4p)
% unifiering
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Betrakta denna fråga till ett Prologsystem:
%
% ?- T=f(a,Y,Z), T=f(X,X,b).
%
% Vilka bindningar presenteras som resultat?
%
% Ge en kortfattad förklaring till ditt svar!

%%%%%%%%%%%%%%%%%%%%%%%% SVAR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% a och b är konstanter pga små bokstäver, X,Y,Z är logiska variabler pga stora bokstäver.

% Två termer kan unifieras om det finns en substitution (med termer) för variablerna i termerna, så att båda termerna blir syntaktiskt identiska

% Jag tror bindningarna som presenteras som svar är följande:

% 1. T = f(a, a, b)
% detta då dessa termer unifieras med varandra a = X, Z = b, X = Y och då a = X följer att a = Y
%%%%%%%%%%%%%%%%%%%%%%%% SVAR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% uppgift 2 	(6p)
% representation 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% En lista är en representation av sekvenser där 
% den tomma sekvensen representeras av symbolen []
% och en sekvens bestående av tre heltal 1 2 3 
% representeras av listan [1,2,3] eller i kanonisk syntax 
% '.'(1,'.'(2,'.'(3,[]))) eller [1|[2|[3|[]]]]

% Den exakta definitionen av en lista är:

list([]).
list([H|T]) :- list(T).


% Vi vill definiera ett predikat som givet en lista som 
% representerar en sekvens skapar en annan lista som 
% innehåller alla element som förekommer i inlistan i 
% samma ordning, men 
% om ett element har förekommit tidigare i listan skall det 
% inte vara med i den resulterande listan.

% Till exempel: 

% ?- remove_duplicates([1,2,3,2,4,1,3,4], E).
%
% skall generera E=[1,2,3,4]

% Definiera alltså predikatet remove_duplicates/2!
% Förklara varför man kan kalla detta predikat för en
% funktion!


%%%%%%%%%%%%%%%%%%%%%%%% SVAR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
remove_duplicates([],[]).
remove_duplicates([H|T],E) :-
  select(H, T, E1_TEMP), !,
  remove_duplicates([H|E1_TEMP],E).

remove_duplicates([H|T],[H|E]) :-
  remove_duplicates(T,E).

% Det är en funktion eftersom det uppfyller de två kriterierna:
% 1. Den tar in möjlig indata som har unik utdata
% 2. Den påverkar inte något utanför programmet, ex listan som input ändras inte.
% 3. Om frågan antyder symbolsfunktion, är det en sådan för att det är en "functor" eftersom
% remove_duplicates är en atom, och den har flera argument (arity).
%%%%%%%%%%%%%%%%%%%%%%%% SVAR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% uppgift 3	(6p)
% rekursion och backtracking  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Definiera predikatet partstring/3 som givet en lista som 
% första argument genererar en lista F med längden L som 
% man finner konsekutivt i den första listan!
% Alla möjliga svar skall kunna presenteras med hjälp av 
% backtracking om man begär fram dem.

% Till exempel:

% ?- partstring( [ 1, 2 , 3 , 4 ], L, F).

% genererar t.ex.F=[4] och L=1
% eller F=[1,2] och L=2
% eller också F=[1,2,3] och L=3
% eller F=[2,3] och L=2 
% osv.

%%%%%%%%%%%%%%%%%%%%%%%% SVAR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
partstring(List, L, F) :-
    append(_, L1, List), 
    append(F, _, L1),
    length(F, L),
    \+ L = 0.
%%%%%%%%%%%%%%%%%%%%%%%% SVAR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% uppgift 4       (8p)
% representation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Du skall definiera ett program som arbetar med grafer.

% Föreslå en representation av grafer sådan att varje nod
% har ett unikt namn (en konstant) och grannarna finns
% indikerade. 

% Definiera ett predikat som med denna representation och
% utan att fastna i en loop tar fram en väg som en lista av 
% namnen på noderna i den ordning de passeras när man utan 
% att passera en nod mer än en gång går från nod A till nod B!
% Finns det flera möjliga vägar skall de presenteras 
% en efter en, om man begär det.

%%%%%%%%%%%%%%%%%%%%%%%% SVAR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
edge(1, 6).
edge(1, 17).
edge(3, 6).
edge(17, 3).
edge(8, 6).
edge(6, 4).

path(Start, Goal, Path) :- path(Start, Goal, [], Path).

path(Start, Start, _, [Start]).
path(Start, Goal, Visited, [Start|Way]) :-
    edge(Start, Node),
    \+ member(Start, Visited),
    path(Node, Goal, [Start|Visited], Way).

%%%%%%%%%%%%%%%%%%%%%%%% SVAR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

