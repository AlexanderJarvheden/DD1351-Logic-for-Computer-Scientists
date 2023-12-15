% Written by Alexander Järvheden & Joachim Olsson
% 14 December 2023
% DD1351 Logic for Computer Scientists - LAB 3
% COPYRIGHT

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
exists_future(T, L, S, U, F):- member([S, TRANS], T), member(SPRIM, TRANS), check(T, L, SPRIM, [S|U], F).

% Used for EX
exists_future_ex(T, L, S, _, F):- member([S, TRANS], T), member(SPRIM, TRANS), check(T, L, SPRIM, [], F).

% Literals
check(_, L, S, [], X) :- member([S, VARIABLES], L), member(X, VARIABLES).
check(_, L, S, [], neg(X)) :- member([S, VARIABLES], L), \+ member(X, VARIABLES).

% And
check(T, L, S, [], and(F,G)) :- check(T, L, S, [], F), check(T, L, S, [], G).

% Or
check(T, L, S, [], or(F,G)) :- (check(T, L, S, [], F) ; check(T, L, S, [], G)).

% AX - i alla nästa tillstånd gäller formeln.
check(T, L, S, [], ax(F)) :- member([S, TRANS], T), check_all_future(T, L, TRANS, [], F).

% EX - i något nästa tillstånd gäller formeln. 
check(T, L, S, [], ex(F)) :- exists_future_ex(T, L, S, [], F).

% AG
check(_, _, S, U, ag(_)) :- member(S, U).
check(T, L, S, U, ag(F)) :- \+ member(S, U), check(T, L, S, [], F), member([S, TRANS], T), check_all_future(T, L, TRANS, [S|U], ag(F)).

% EG
check(_, _, S, U, eg(_)):- member(S, U).
check(T, L, S, U, eg(F)) :- \+ member(S, U), check(T, L, S, [], F), exists_future(T, L, S, [S|U], eg(F)).

% EF
check(T, L, S, U, ef(F)) :- \+ member(S, U), (check(T, L, S, [], F); exists_future(T, L, S, U, ef(F))).

% AF
check(T, L, S, U, af(F)) :- \+ member(S, U), (check(T, L, S, [], F); member([S, TRANS], T), check_all_future(T, L, TRANS, [S|U], af(F))).