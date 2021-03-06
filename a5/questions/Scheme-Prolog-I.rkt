#lang racket

#| Modified version of backtrack.rkt. |#
(require "A5-backtrack.rkt")
#| Just displays "No." instead of aborting.
   Can call thunk 'No.', i.e. say (No.), to skip all waiting branches.
   And explained below:
     cuts are now thunks
     new operations -<! and define-cutable |#


#;(provide assert)
#| Recall from lecture the 'guarded -<' idiom for if-else: |#
(define (len-< l)
  (-< (cond [(empty? l) 0]
            [(?)]) ; Skips this branch --- like 'continue' in looping.
      (cond [(not (empty? l)) ; '-<' isn't exclusive-or / if-else / cond.
             (add1 (len-< (rest l)))]
            [(?)])))

(len-< '(3 2 4 8 8))
(?)
#| Write a syntactic-form 'assert', taking an expression,
    then skipping the current branch if the expression is false.
   Make the body as nice as possible, much nicer than:
     "if expression is false then skip else void". |#

#;(provide len-assert)
#| Write 'len-assert', returning the length of a list.
   Mimic the meaning of len-<, but refactor with begins and asserts, instead of cond. |#


#;(provide len-cut)
#| Write 'len-cut', similarly to len-assert, but using '-<!' which is like:
     (cutable-with ! (-< _ ...))
    i.e. it always using the name '!' for cut.
   But unlike lecture's cutable-with, the cut is just a thunk.
   Use these to remove at least one guard. |#
(-<! 3 2 (!) 4 8 8) ; cut is a thunk now, returns '! so you notice use
(?) (?) (?)
(-<! 3 2 (begin (!) 236) 4 8 8) ; intended use if producing a value
(?) (?) (?)


#;(provide define-predicate)
#| Next you make a syntactic form automatically inserting the -<!, begins and asserts.
   For subtle reasons (may be a bug in Racket, which ate up some hours), use
    define-cutable with just -<, instead of using -<!. |#
#;(define-cutable (<name> <arg> ...) <stmt> ...)
;  becomes
#;(define (<name> <arg> ...) (cutable-with ! <stmt> ...))
#| Write 'define-predicate' that captures the idiom of len-cut:
    a set of clauses with expressions to assert, followed by a result.
   Hint: use the given pattern, and for the expansion just take the pattern and
    just put the extra stuff where it belongs: '...' just magically understands. |#
#;(define-predicate (<name> <arg> ...)
    (<assertion> ... <result>)
    ...)
; The first example len-<, using this:
#;(define-predicate (len-< l)
    ((empty? l) 0)
    ((not (empty? l)) (add1 (len (rest l)))))


#;(provide len-predicate)
#| Write 'len-predicate', refactoring your len-cut to use define-predicate. |#


#;(provide match-assert)
#| Write 'match-assert' handling the following form: |#
#;(match-assert <exp>
                [<pattern> <assertion> ... <result>]
                ...)
#| If none of the <pattern>s match <exp>, it skips the current branch.
   Otherwise, for the first matching <pattern> it treats the match result like a
    define-predicate clause. |#


#;(provide len-match)
#| Write 'len-match', refactoring len-cut to use one match-assert per clause,
    one pattern per match-assert, but no cut. |#


#;(provide define-predicate-match)
#| Write 'define-predicate-match' that captures the previous idiom in the form: |#
#;(define-predicate-match (<name> <arg>)
    (<arg-pattern> :- <assertion> ... <result>)
    ...)
#| Notice that a keyword ':-' follows the pattern.
   Also allow more than one argument, in the following form: |#
#;(define-predicate-match (<name> <arg> ...)
    ((<arg-pattern> ...) :- <assertion> ... <result>)
    ...)
#| Notice that the unary case is *not* just a special case of this: study the pattern format.
    Recall that syntax-rules can have more than one rule.
   Here, in each clause, the user supplies one pattern per argument, *in parentheses*.
    This is for simplicity of implementation in the n-ary case.
   Note that the whole (<arg-pattern> ...) itself is not a valid (single) pattern.
    Not having to make the patterns into a list-of pattern is simpler for the *user*.
   The unary special case is also for simpler use. |#


#;(provide len-predicate-match
         P-map
         a-subsequence)
#| Write 'len-predicate-match' using define-predicate-match to refactor len-match.
   Also use define-predicate-match to write a P-map doing map (of unary),
    and a-subsequence (see lecture). |#


#;(provide len-box)
#| Write 'len-box' taking a list and a box, setting the box's value to the length of the list.
   Use define-predicate-match, primitive recursion, no helpers nor len-predicate-match. |#


#;(provide len-box-acc)
#| Now do it accumulating, taking a list, an accumulator box and a result box.
   Assume the accumulator box starts off containing 0.
   Record the accumulated length in the result box only when the accumulation is done. |#
