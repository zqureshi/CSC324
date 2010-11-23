#lang racket

#| Predicate programming. 
   Logic variables. |#

(require (only-in "A5-backtrack.1.rkt"
                  ? ?- ?* No.)
         (only-in "Scheme-Prolog-I.rkt" 
                  define-predicate-match assert))


#| Coding Guidelines.

   Favour pattern matching and (quasi)quote for list destructuring and creation.
   Use the _ pattern for unused arguments or their parts.
   Avoid (explicit) conditionals and -< .

   Focus on meaning for this assignment: don't use cuts just for efficiency,
    i.e. when they don't change the results.

   To get closer to Prolog syntax:
     Avoid referring to arguments directly, instead match the same name
      (unless already matching more specifically).
     Use names starting with a capital for variables that (might) refer to
      logic variables (and use lowercase for others). |#

#;(provide coin coin-bounded make-change)
#| Write coin, producing a stream of 25, 10, 5 or 1.
   Write coin-bounded, producing a stream of the coins <= a bound.

   Write make-change, producing a stream of non-increasing lists of coins
    summing to the given positive number, with lists using more of larger
    coins produced earlier.
   Hint: make a helper (also via define-predicate-match). |#
(define-predicate-match (coin)
  (() :- 25)
  (() :- 10)
  (() :- 5)
  (() :- 1))

(define-predicate-match (coin-bounded b)
  (bound :- (let ([curr-coin (coin)])
              (assert (<= curr-coin bound))
              curr-coin)))
#;(define-predicate-match (make-change n) _)

#;(provide test1 range test2)
#| Write test1 to produce all change for 57 with at most 10 coins.
   Write range taking start and end numbers, producing a stream
    of the numbers start, start+1, start+2, ... <= end.
   Write test2 to produce the change that test1 produces,
    but in order from least to most number of coins. |#
#;(define (test1) _)

(define-predicate-match (range s e)
  ((s e) :- (assert (<= s e)) s)
  ((s e) :- (assert (<= s e)) (range (+ s 1) e)))

#;(define (test2) _)


(provide VAR)
#| Simple Logical Variables.

   Structure VAR will be used for "Logic Variables".
   All other values will just be called values.
   A logic variable containing void is called "uninstantiated".
|#
(define-struct VAR ([value #:auto])
  #:auto-value (void) ; initialize value to void.
  #:mutable ; allow value to change, with set-VAR-value!
  #:transparent ; display internals when displaying a VAR
  #:property prop:procedure ; make instances callable, via following getter/setter:
  (case-lambda [(self) (VAR-value self)]
               [(self value) (set-VAR-value! self value)]))
#;(let ([V (VAR)])
    (displayln V)
    (V 324)
    (displayln V)
    (displayln (V)))

#;(provide ?=)
#| Write '?=' taking a logic variable or value, and a(nother) value.
    If the logic variable is uninstantiated, instantiate it with the value.
    Otherwise succeed iff the logic variable's value and the other value,
     or the two values, are equal.
   Use the (VAR <value>) pattern in the implementation. |#
(define-predicate-match (?= A b)
  (((VAR val-a) val-b) :- (assert (void? val-a)) (set-VAR-value! A val-b))
  (((VAR val-a) val-b) :- (assert (not (void? val-a))) (eq? val-a val-b))
  ((val-a val-b) :- (eq? val-a val-b)))


#;(provide in)
#| Write 'in' taking a value or logic variable, and a list. |#
(define-predicate-match (in X l)
  ((x `(,h . ,r)) :- (assert (?= x h)))
  ((x `(,h . ,r)) :- (in x r)))
#| For a value or instantiated logic variable: succeed once for each time
     the value or variable's value occurs in the list.
   For uninstantiated logic variable, repeatedly instantiate it to elements
    so that it can be used as: |#
#;(?* (let ([X (VAR)])
        (in X '(3 2 4))
        (begin0
          (X) ; EXERCISE: would just 'X' show the answers?
          (X (void)) ; EXERCISE: would (set! X (VAR)) work?
          ; EXERCISE: what if X hadn't been reset here?
          )))
#| For full marks, don't do any explicit VAR handling in in.
   Hint: write it thinking of X as just a value and use ?=.
   EXERCISE: trace both usages carefully. |#


#;(provide sumList)
#| Write sumList taking a list of numbers and a logic variable or value.
   It succeeds iff the logic variable or value ?= the sum of the numbers,
    in which case the logic variable ends up instantiated to the sum.

   Implement it "tail" recursively: all work on the way in.
    I.e. any recursion must be last in the body's control flow. |#
(define-predicate-match (sumList l S)
    (((and (? list?) l) S) :- (begin
                                (define-predicate-match (sumList-w/acc l S acc)
                                  ((`() S acc) :- (?= S acc))
                                  ((`(,h . ,r) S acc) :- (sumList-w/acc r S (+ acc 1))))
                                (sumList-w/acc l S 0))))

#;(provide sumListA)
#| Implement sumList again, tail recursively again, but treating logic variables
    as immutable once instantiated.
   Assume sumListA will be called with a logic variable instantiated to 0. |#
(define-predicate-match (sumListA l A S)
  ((`() (VAR a) S) :- (?= S a))
  ((`(,h . ,r) (VAR a) S) :- (let ([V (VAR)])
                              (V (+ a 1))
                              (sumListA r V S))))
#;(let ([A (VAR)]
        [S (VAR)])
    (?= A 0)
    (sumListA '(3 2 4) A S)
    S)
