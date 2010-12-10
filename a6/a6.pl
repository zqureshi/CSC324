natFrom(S, N) :- N is (S + 1).
natFrom(S, N) :- S1 is (S + 1), natFrom(S1, N).
