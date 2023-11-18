verify(InputFileName) :- see(InputFileName),
    read(Prems), read(Goal), read(Proof),
    seen,
    valid_proof(Prems, Goal, Proof).    

% Check that the last element is the goal
check_goal(Goal, Proof):- last(Proof, Last), nth1(2, Last, Goal).

% Validate proof by first checking that the last row is the goal and then the rest of the proof
valid_proof(Prems, Goal, Proof):- check_goal(Goal, Proof), control_proof(Prems, Proof, []), !.

% Control the whole proof
control_proof(_, [],_). 
control_proof(Prems, [H | T], CheckedRows):- 
    control_row(Prems, H, CheckedRows), 
    append(CheckedRows,[H], AddedRows),  
    control_proof(Prems, T, AddedRows), !.

% Set assumption rows to false, will be looked at in the open_box predicate
control_row(_, [_, _, assumption], _):- !, false.

% Will open a box if the Row is a list/box
control_row(_, H, CheckedRows):- 
    nth1(1, H, Elem), 
    is_list(Elem), 
    nth1(3, Elem, assumption), 
    last(H, LastRowBox), 
    open_box(H, CheckedRows, LastRowBox), 
    findall(X, member([X, _, assumption], H), AssumptionList),
    length(AssumptionList, 1).

% Premises
control_row(Prems, [_, Form, premise], _):- member(Form, Prems), !.

% Copy
control_row(_, [_, Form, copy(X)], CheckedRows):- member([X, Form, _], CheckedRows), !.

% And introduction
control_row(_, [_, and(FormX, FormY), andint(X,Y)], CheckedRows):- 
    member([X, FormX, _], CheckedRows), 
    member([Y, FormY, _], CheckedRows), !.

% And elimination
control_row(_, [_, Form, andel1(X)], CheckedRows):- member([X, and(Form, _), _], CheckedRows), !.

control_row(_, [_, Form, andel2(X)], CheckedRows):- member([X, and(_, Form), _], CheckedRows), !.

% Or introduction
control_row(_, [_, or(Form, _), orint1(X)], CheckedRows):- member([X, Form, _], CheckedRows), !.

control_row(_, [_, or(_, Form), orint2(X)], CheckedRows):- member([X, Form, _], CheckedRows), !.

% Implication elimination
control_row(_, [_, Form, impel(X, Y)], CheckedRows):- 
    member([X, A, _], CheckedRows), 
    member([Y, imp(A, Form), _], CheckedRows), !.
    

% Negation elimination
control_row(_, [_, cont, negel(X, Y)], CheckedRows):- 
    member([X, Form, _], CheckedRows), 
    member([Y, neg(Form), _], CheckedRows), !.

% Contradiction elimination
control_row(_, [_, _, contel(X)], CheckedRows):- member([X, cont, _], CheckedRows), !.

% Negation-negation introduction
control_row(_, [_, neg(neg(Form)), negnegint(X)], CheckedRows):- member([X, Form, _], CheckedRows), !.

% Negation-negation elimination
control_row(_, [_, Form, negnegel(X)], CheckedRows):- member([X, neg(neg(Form)), _], CheckedRows), !.

% Modus Tollens
control_row(_, [_, neg(A), mt(X, Y)], CheckedRows):- 
    member([X, imp(A, B), _], CheckedRows), 
    member([Y, neg(B), _], CheckedRows), !.

% Lem
control_row(_, [_, or(A, neg(A)), lem], _).


% Or elimination
control_row(_, [_, Form, orel(X,Y,U,V,W)], CheckedRows):- 
    extract_lists(CheckedRows, ListOfLists),
    second_last(ListOfLists, BoxRows1),
    last(ListOfLists, BoxRows2),
    member([X, or(A, B), _], CheckedRows),
    member([Y, A, _], BoxRows1),
    member([U, Form, _], BoxRows1),
    member([V, B, _], BoxRows2),
    member([W, Form, _], BoxRows2), !.

% Implication introduction
control_row(_, [_, imp(A, B), impint(X,Y)], CheckedRows):- 
    extract_lists(CheckedRows, ListOfLists),
    last(ListOfLists, BoxRows),
    member([X, A, _], BoxRows), 
    member([Y, B, _], BoxRows), 
    last(BoxRows, LastRow),
    nth1(1, LastRow, LastRowNr),
    Y == LastRowNr,
    !.

% Negation introduction
control_row(_, [_, neg(A), negint(X,Y)], CheckedRows):- 
    last(CheckedRows, BoxRows),
    member([X, A, _], BoxRows), 
    member([Y, cont, _], BoxRows), !.

% PBC
control_row(_, [_, A, pbc(X,Y)], CheckedRows):- 
    last(CheckedRows, BoxRows),
    member([X, neg(A), _], BoxRows), 
    member([Y, cont, _], BoxRows), !.

% Open a box
open_box([H | _], CheckedRows, LastRowBox):- % Control last row, then close the box
    H == LastRowBox, 
    (nth1(3, H, assumption) ; control_row(_, H, CheckedRows)), !.

open_box([H | T], CheckedRows, LastRowBox):- 
    \+(H == LastRowBox),
    (nth1(3, H, assumption), append(CheckedRows, [H], TempList); 
    control_row(_, H, CheckedRows), append(CheckedRows, [H], TempList)),
    open_box(T, TempList, LastRowBox), !.

% Find second to last element in a list
second_last(L, X) :-
    append(_, [X, _], L),
    nth1(1, X, Elem), 
    is_list(Elem).

% Filter a list with mix of elements and return a list containing only lists
extract_lists([], []).
extract_lists([X|Rest], Lists) :-
    is_list(X),
    extract_lists(Rest, RestLists),
    Lists = [X|RestLists].
extract_lists([_|Rest], Lists) :-
    extract_lists(Rest, Lists).

