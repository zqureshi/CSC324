/* Question 1 */
natFrom(S, N) :- N is (S + 1).
natFrom(S, N) :- S1 is (S + 1), natFrom(S1, N).

/* Question 2a */
square(S) :- natFrom(0, N), S is (N * N).

/* Question 2b */
squareFrom(N, S) :- square(S), S >= N.

/* Question 2c */
firstSquareFrom(N, S) :- squareFrom(N, S), S >= N, !.

/* Question 3a */
sorted([]) :- !.
sorted([_]) :- !.
sorted([F,S | T]) :- S > F, sorted([S | T]).

/* prime(P) */
prime(P) :- P >= 2, noDivisorFrom(P,2).
noDivisorFrom(P,P) :- !.
noDivisorFrom(P,D) :- M is P mod D, M > 0, D1 is D + 1, noDivisorFrom(P, D1).

/* Question 3b */
firstPrime([H | _], P) :- prime(H), P is H, !.
firstPrime([_ | T], P) :- firstPrime(T, P).
