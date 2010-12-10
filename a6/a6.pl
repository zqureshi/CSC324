/* Question 1 */
natFrom(S, N) :- N is (S + 1).
natFrom(S, N) :- S1 is (S + 1), natFrom(S1, N).

/* Question 2a */
square(S) :- natFrom(0, N), S is (N * N).

/* Question 2b */
squareFrom(N, S) :- square(S), S >= N.

/* Question 2c */
firstSquareFrom(N, S) :- squareFrom(N, S), S >= N, !.
