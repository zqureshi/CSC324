#lang scheme ; you may change to racket, shouldn't matter.

(provide caching
         fibonacci)

#| Q1. [~20 of assignment]

   Purpose
   =======

   Efficiency: Memoization, Dynamic Programming, Caching.

   Higher-Order Functions: Function taking a function, returning a function.
     Specifically: function decoration/wrapping.

   Side-effects vs return values.

   Estimated Times: (a) 3/4 hr (b) 1/4 hr.
   =============== |#



#| (a) Write caching that takes a unary function,
    let's name the *given* function f for reference here,
    and returns a function,
    let's name the returned function f',
    that is similar to f:

    1. Given the same argument, f' returns the same value as f would.
    2. Called once with an argument, f' also records the result.
       Later, if called with the same argument as earlier, f' returns
        the recorded result, rather than using f to calculate it.

   Use [mutable equal?-based --- the default] hash tables to record results:
     Guide: http://docs.racket-lang.org/guide/hash-tables.html
     Reference: http://docs.racket-lang.org/reference/hashtables.html |#



#| (b) Write a naive primitive recursive fibonacci; use your caching function
      to make it efficient.
    Hint: don't use the short syntax for defining and naming functions --- why? |#

; The nth fibonacci number.
;   Starts with the 0th and 1th as 1.



#| Now we can reflect more precisely on side-effects.

   A function call (after the first call with a particular argument) has a side-effect
    iff it behaves differently from its cached version (possibly noticed only later,
    e.g. if it mutated a box).

   Whether time/space usage is considered a side-effect depends on context and extent.
    Strictly speaking, the cached version will (almost) always be different in
    time and space, often even in Big-O terms, though perhaps still not noticeably.
 
   Ponder: can you give a function that has noticeable time side-effects regardless
    of how fast the computer is? |#
