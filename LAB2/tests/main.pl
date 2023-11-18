:- consult('beviskoll.pl').

run_verification(File) :-
    verify(File),
    % Additional logic if needed.
    write('Verification completed.'), nl.