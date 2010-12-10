/* CSC 324 Fall 2010 - Assignment 6
 *
 * Zeeshan Qureshi <g0zee@cdf.toronto.edu>
 * Aditya Mishra <c9mishra@cdf.toronto.edu>
 */

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

/* Question 3c */
lastPrime([_ | T], P) :- lastPrime(T, P), !.
lastPrime([H | _], P) :- prime(H), P is H.

/* Question 3d */
sumOfPrimesSquared([H | T], SPS) :- prime(H), sumOfPrimesSquared(T, SSP),
                                    SPS is (SSP + (H * H)), !.
sumOfPrimesSquared([_ | T], SPS) :- sumOfPrimesSquared(T, SPS).
sumOfPrimesSquared([], 0).

/* Question 4a */
range(E, E, [E]) :- !.
range(S, E, L) :- N is (S + 1), range(N, E, R), L = [S | R].

/* Question 4b */
rangeA(S, S, [S | A], A) :- !.
rangeA(E, S, L, A) :- AN = [E | A], P is (E - 1), rangeA(P, S, L, AN).
rangeA(S, E, L) :- rangeA(E, S, L, []).

/* Question 5a */
primesSquared([H | T], LPS) :- prime(H), primesSquared(T, R),
                               S is (H * H), LPS = [S | R], !.
primesSquared([_ | T], LPS) :- primesSquared(T, LPS).
primesSquared([], []) :- !.

/* Question 5b */
rev([], RL, RL).
rev([H | T], RL, A) :- AN = [H | A], rev(T, RL, AN).
rev(L, RL) :- rev(L, RL, []).

/* Question 6a */
backwards([_ | T], E) :- backwards(T, E).
backwards([E | _], E).

/* Question 6b */
runningSum([H | _], S, A) :- S is (A + H).
runningSum([H | T], S, A) :- AN is (A + H), runningSum(T, S, AN).
runningSum([H | T], S) :- runningSum([H | T], S, 0).

/* Question 7 */
subsequences([_ | T], S) :- subsequences(T, S).
subsequences([H | T], S) :- subsequences(T, R), S = [H | R].
subsequences([], []).
