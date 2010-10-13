#lang scheme ; you may change to racket, shouldn't matter.

(provide pair-up-from-front
         pair-up-from-back
         combine
         combine-in-out
         running-sum)

#| Q3. [~30% of assignment]
 
   Purpose
   =======

   Functional Programming

   Linear Recursion
     Primitive, Accumulating.
 
   Estimated Times: (a) 1/2 hr (b) 1/2 hr (c) 1/2 hr.
   ===============
 
   Restrictions
   ============

   Do not use any mutation nor I/O.

   All functions must be at most linear time in l.

   Do not use any potentially (lower bound) linear functions,
    e.g. length, append, reverse, map, apply. |#



#| (a) Write pair-up-from-front and pair-up-from-back that
        take a list of elements (<e0> <e1> <e2> ...),
        returning the elements paired up:

         ((<e0> <e1>) (<e2> <e3>) ...),
          and
         (... (<e_(n-2)> <e_(n-1)>))
          respectively.

    For an odd number of elements, the last/first (respectively)
     'pairing' is just a singleton list.

    Write both of them with primitive recursion.
    For one of them (choose carefully), combine from lecture,
     and for the other do it 'manually'. |#

(define combine
  (lambda (combiner:elt&rest-result base l)
    (if (empty? l) base
        (combiner:elt&rest-result
         (first l)
         (combine combiner:elt&rest-result base
                  (rest l))))))

(define pair-up-from-front
  (lambda (l)
    (cond [(empty? l) empty]
          [(empty? (rest l)) (list (list (first l)))]
          [else (cons (list (first l) (first (rest l)))
                 (pair-up-from-front (rest (rest l))))])))

(define pair-up-from-back
  (lambda (l)
    (combine
     (λ (e res)
       (cond [(empty? res) (cons (list e) res)]
             [(empty? (rest (first res))) (cons (cons e (first res)) (rest res))]
             [else (cons (list e) res)]))
     '()
     l)))


#| (b) Write combine-in-out that takes:
     an initial accumulator,
     a binary function, let's name it elt&acc-combiner,
     a unary function, let's name it acc->return,
     a binary function, let's name it elt&return-combiner,
     and a list.

  It recurses on the list.
  
  On the way in (preorder/accumulating):
    updating the accumulator with elt&acc-combiner called on
     the current element and the accumulator.
  On the way out (postorder/primitive):
    starts by converting the accumulator to a result, with acc->return,
     then (recursively) combine the current element and returned result
     using elt&return-combiner, as we did in lecture.
 
  Also, uncomment it in the provide above. |#

(define (combine-in-out acc elt&acc-combiner acc->return elt&return-combiner l)
  (if (empty? l) (acc->return acc)
      (elt&return-combiner 
        (first l)
        (combine-in-out 
          (elt&acc-combiner (first l) acc)
          elt&acc-combiner
          acc->return
          elt&return-combiner
          (rest l)))))

#| (c) Use combine-in-out to redo A1-Q5(d), without boxes,
        just returning the result list. |#

(define running-sum
  (lambda (l)
    (rest 
     (combine-in-out 
      0 
      +
      list
      (λ (e res)
        (cons (- (first res) e) res))
      l))))
