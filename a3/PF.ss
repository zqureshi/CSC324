#lang scheme

#| Q1 [2.5 hours] Tree Recursion, Higher Order Functions.
   (The algorithms are all at 148 level, but the HOFs let you see/make
    the recursive patterns explicit). |#

#| A Propositional Formula (PF) will be defined by the following recursive datatype:

     a Propositional *Variable*, as a symbol, OR

     a Negated formula, as a list with two elements:
       a symbol: not
       a Propositional Formula

     a Conjunction of two formulas, as a list with three elements:
       a Propositional Formula
       symbol: and
       a Propositional Formula

     a Disjunction of two formulas, as a list with three elements:
       a Propositional Formula
       symbol: or
       a Propositional Formula

   (Recall 165, 236, 258 for such formulas, 148 and 236 of course for
    recursive data definitions, aka structural definitions in 236). |#

#| (a) [30 min]

   Remind yourself of DeMorgan's laws for negation of conjunction and disjunction.
    Write them down. Also write down the law for double negation.

   Write normalize taking a PF, returning a *logically equivalent* PF where negation
    is only allowed on Propositional *Variables*.

   Start by teaching a(n imaginary) 165 student how to do it (called "moving negation
    all the way in), top down.

   Next, imagine two students who are good at it.
    Make an example where you could use the two students by giving them each a PF
    (smaller than the example) to normalize *and no other information*.
    In particular, they should have no idea why you made their PFs.

   Notice that the laws are consulted on the way into the recursion.
    But there's no extra parameter: after the smaller PFs are chosen/constructed
    no other information needs to be passed recursively to normalize.
   
   There is also reconstruction work on the way back. |#
#;
(provide normalize)

#| (b) [30 min]

   Review 4.3, 4.3.1, 4.3.3, 4.4, learn 4.4.1 of:

     http://docs.racket-lang.org/guide/application.html
     http://docs.racket-lang.org/guide/lambda.html

   Note especially: "Functions with a rest-id often use apply
    to call another function that accepts any number of arguments."


   Write only-if taking a unary predicate and a unary function,
    returning a unary function that:
 
     Takes a value and just returns it,
      unless the predicate is true for the value, in which case
      it returns the result of calling the given unary function on it.


   Write fix-1st taking a function of arity at least one, and a value,
    returning a function with one less arity, that behaves like the original
    function but with its first argument always the given value.
   
   Be sure to note the Note above. Start by making a function that
    takes any function and returns a newly created function behaving
    like the original (like caching, but no caching :)#, and not
    restricted to unary functions). |#
#;
(provide only-if fix-1st)

#| (c) [30 min]

   From now on, "sexp" means a (scheme) value, treated as a 'leafy tree',
    where the lists are thought of as non-data nodes with elements as children,
    and non-lists are thought of as leaves (recall A2-Q2).

   Write sexp-prepare-reconstruct taking a unary function and an sexp,
    recursing on the sexp. The recursive step is:
 
     Calls the unary function, and
      if that produces a leaf just returns it,
      otherwise recurses on the children.

   Then write normalizeA, doing normalize by calling sexp-prepare-combine.
    Do no pre nor post processing: the body of normalizeA is just a call to
    sexp-prepare-reconstruct.
 
   Use only-if and fix-1st *sensibly* (at least) once in (c). |#
#;
(provide sexp-prepare-reconstruct normalizeA)

#| (d) [15 min]

  Write sexp-combine taking a combiner and an sexp, primitively recursing,
   using the combiner on the leaves, and on the lists of results. |#

(provide sexp-combine)

#| (e) [45 min]

  Write substitute taking a list of 'true' Propositional Variables, and a PF,
   returning a PF where the 'true' variables have been replaced with symbol true,
   the rest with false.
 
  Write fix taking a PF, returning an sexp representing Scheme code for the formula,
   i.e. changing infix and/or to prefix and/or.

  For each function, use one of the higher order functions from (c) and (d).

  You may make a reasonable assumption about certain names not being used as
   Propositional Variables.
 
  Write scheme-bind, taking a list of 'true' Propositional Variables,
   a list of the rest ('false' ones), and a fix'd PF, returning Scheme code
   that binds the variables to true/false, and evaluates the PF. |#
#;
(provide substitute fix scheme-bind)