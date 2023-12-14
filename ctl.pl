% Load model, initial state and formula from file.
verify(Input) :-
see(Input), read(T), read(L), read(S), read(F), seen,
check(T, L, S, [], F).
% check(T, L, S, U, F)
% T - The transitions in form of adjacency lists
% L - The labeling
% S - Current state
% U - Currently recorded states
% F - CTL Formula to check.

% Check all future states
check_all_future(_, _, [], _, _).
check_all_future(T, L, [S1|FUTURE], U, F) :- check(T, L, S1, U, F), check_all_future(T, L, FUTURE, U, F).

% Check if theres one true exisiting stat
exists_future(T, L, S, U, F):- member([S, TRANS], T), member(SPRIM, TRANS), check(T, L, SPRIM, [U|S], F).

% Literals
check(_, L, S, [], X) :- member([S, VARIABLES], L), member(X, VARIABLES).

check(_, L, S, [], neg(X)) :- member([S, VARIABLES], L), \+ member(X, VARIABLES), write('used NEG\n').

% And
check(_, L, S, [], and(F,G)) :- check(_, L, S, [], F), check(_, L, S, [], G), write('used AND\n').

% Or
check(_, L, S, [], or(F,G)) :- check(_, L, S, [], F) ; check(_, L, S, [], G), write('used OR\n').

% AX - i alla nästa tillstånd gäller formeln.
check(T, L, S, [], ax(F)) :- member([S, TRANS], T), check_all_future(T, L, TRANS, [], F), write('used AX\n').

% EX - i något nästa tillstånd gäller formeln. 
check(T, L, S, [], ex(F)) :- exists_future(T, L, S, [], F), write('used EX\n').

% AG
check(_, _, S, U, ag(_)):- member(S, U), write('used AG1\n').

check(T, L, S, U, ag(F)):- \+ member(S, U), check(T, L, S, [], F), member([S, TRANS], T), check_all_future(T, L, TRANS, [U|S], ag(F)), write('used EG2\n').

% EG
check(_, _, S, U, eg(_)):- member(S, U), write('used EG1\n').

check(T, L, S, U, eg(F)):- \+ member(S, U), check(T, L, S, [], F), exists_future(T, L, S, U, F), write('used EG2\n').

% EF
check(T, L, S, U, ef(F)) :- \+ member(S, U), check(T, L, S, [], F), write('used EF1\n').

check(T, L, S, U, ef(F)):- \+ member(S, U), exists_future(T, L, S, U, ef(F)), write('used EF2\n').

% AF
check(T, L, S, U, af(F)):- \+ member(S, U), check(T, L, S, [], F), write('used AF1\n').

check(T, L, S, U, af(F)):- \+ member(S, U), member([S, TRANS], T), check_all_future(T, L, TRANS, [U|S], af(F)), write('used AF2\n').