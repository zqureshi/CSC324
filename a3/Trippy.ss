#lang racket


(provide such-that stopovers)

#| Q3. [1 hour]

   (a) [30 min]

   Write such-that taking a unary predicate and list, returning
    the sublist of elements in the list that satisfy the predicate.

   Do not write any first-rest recursion.
   Instead creatively use map, apply and append, but no other
    higher-order functions nor linear built-in list functions. |#

(define (such-that pred? l)
  (apply append (map (λ (e) (if (pred? e) (list e) '())) l)))


#| (b) [30 min]
   Suppose you work at an airport, and someone asks you for the
    fewest number of airport stopovers needed to get to destination
    airport D.

   You call up each airport serviced by your airport, and ask:
    "what's the fewest number of airport stopovers to get to D,
     from your airport?"

   They then have the same idea as you, and put you on hold.
     Your phone rings: why?

   You rephrase your question.

   The airports you called use the new information in your question,
    in their version of the rephrased question.

   Formalize the refined question form as a function declaration,
    unimplemented at the moment.

   Choose parameter name(s), and document what they mean.
   Document what the question returns, in terms of the parameters
   (e.g. "returns whether the square of 'side' is less than 'max-area'"
    --- which of course is not even close to what we're doing) |#

#| Function takes in a destination airport (dest) and a list of referrers who are on hold
 and returns the minimum number of stop to an airport, else #f. 

Calls up all the airports serviced by the current one except if they are a referrer |#

#;
(define question
  (λ (dest referrers)
    (minimum-of-list+1-else-false
     (map if-not-referrer-then-call-wth-dest list-of-serviced-airports))))

#| Model an airport as a list of airport name followed by names of airports
    immediately serviced from it. |#
;#;
(define airports ; silly example of format with various boundary cases.
  '((324 yyz scheme)
    (yyz ISS)
    (ISS yyz)
    (perl)
    (gfb 324)
    (scheme python C++ perl)
    (python perl)
    (C++ perl)))

#| Write stopovers that takes start and goal airports, returning the length
    of the shortest route from start to goal, or #f if there is none.
 
   Don't write any first-rest list recursion.
   The only efficiency required is termination. |#

(define (stopovers airports start goal (referrers '()))
  (let* ([serviced (assoc start airports)]
         [serviced (if serviced (rest serviced) '())]
         [non-referrers (such-that (λ (e) (if (member e referrers) #f #t)) serviced)])
    (cond [(equal? start goal) 0]
          [(empty? non-referrers) #f]
          [else 
           (let ([hops (such-that 
                        (λ (e) e)
                        (map 
                         (λ (e) (stopovers airports e goal (cons e referrers))) 
                         non-referrers))])
             (if (empty? hops) #f
                 (+ 1 (apply min hops))))])))
