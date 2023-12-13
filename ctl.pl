% For SICStus, uncomment line below: (needed for member/2)
%:- use_module(library(lists)).
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
%
% Should evaluate to true iff the sequent below is valid.
%
% (T,L), S |- F
% U
% To execute: consult('your_file.pl'). verify('input.txt').
% Literals
check(_, L, S, [], X) :- ...
check(_, L, S, [], neg(X)) :- ...
% And
check(T, L, S, [], and(F,G)) :- ...
% Or
check(T, L, S, [], or(F,G)) :- ...
% AX
check(T, L, S, [], ax(F,G)) :- ...
% EX
check(T, L, S, [], ex(F,G)) :- ...
% AG
check(T, L, S, [], ag(F,G)) :- ...
% EG
check(T, L, S, [], eg(F,G)) :- ...
% EF
check(T, L, S, [], ef(F,G)) :- ...
% AF
check(T, L, S, [], af(F,G)) :- ...