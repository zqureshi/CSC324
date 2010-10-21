#lang racket

#| Q2. [1.5 hrs]

   Practice accumulating tree recursion, while applying it to a programming
    languages topic: Lexical Scope (in Scheme: let vs letrec vs lambda variables)
    --- another doubly/meta-pedagogical question :)#!

   Also a bit of simple practice/review of local state, list recursion, HOFs.
   Take the time limits of (a)-(c) seriously, they should be basic by now,
    along with under 10 minutes for 'lookup' once you get to it.

   Use the hour for (d) to take some time to understand and plan: the code isn't long,
    and lambda/let/letrec have a lot of similarity in their handling.

   Of course review the meaning of let vs letrec first if that's at all an issue.

   Lambda's easiest to handle, then the second level of understanding is how
    let and letrec differ from it and each other. Then handling the remaining one
    is just a third variant, not an extension. |#


#| (a) [10 min]
   Write counter.
   Do not define any global variables (except counter of course). |#

(provide counter)

(define counter
  (let ([count 0])
    (λ ()
      (begin0
        count
        (set! count (+ count 1))))))

#| Older implementation by creating closure inside a lambda
(define counter
  ((λ (count)
     (λ ()
       (begin0 
         count
         (set! count (+ count 1))))) 0)) |#

#;
(list (counter) (counter) (counter) (counter)) ;=> (0 1 2 3]


#| (b) [10 min]
   Write mark, taking a symbol, returning the symbol with a number 'appended'.
   The number must be different each time mark is called.
   Use: string-append, symbol->string (and you can guess the rest). |#

(provide mark)

(define (mark sym)
  (string->symbol (string-append (symbol->string sym) (number->string (counter)))))


#| (c) [10 min]
   Write first-such-that, taking a unary predicate and list, returning the first
    element for which the predicate is true, or false if there's no such element. |#

(provide first-such-that)

(define (first-such-that pred l)
  (if (empty? l)
      #f
      ((λ (e) ; lulzy alternative to let
         (if (pred e)
             e
             (first-such-that pred (rest l)))) (first l))))

#| (d) [60 min]

   Write mark-scope taking:
 
     Scheme code containing only numbers, variables, function calls, unary lambda/λ with
      one body statement, and let/letrec with one binding and one body statement.

     An accumulating list of pairs of variable name and marked name, starting empty.
      This represents a "lexical environment".

   Return the code marked up: mark variables with the same name in the same scope with
    the same number, different from variables with the same name in other scopes.
 
   Write a helper lookup, taking a variable name and environment, returning the first
    marked name name for the variable --- assume there is one. |#
#;
(provide mark-scope lookup)

(define (lookup var env)
  (let ([looked (first-such-that (λ (e) (equal? (car e) var)) env)])
    (if looked
        (cdr looked)
        var))) ; return var if not found in env

(define (mark-scope code (env '()))
  (match code
    [`(,(and (or 'lambda 'λ) lambda/λ) (,x) ,body) 
     (let ([marked (mark x)])
       `(,lambda/λ (,marked) ,(mark-scope body (cons (cons x marked) env))))]
    [`(let ((,x ,init)) ,body) 
     (let ([marked (mark x)])
       `(let (,marked ,(mark-scope init env)) ,(mark-scope body (cons (cons x marked) env))))]
    [`(letrec ((,x ,init)) ,body) 
     (let* ([marked (mark x)]
            [env (cons (cons x marked) env)])
       `(letrec ((,marked ,(mark-scope init env)))
          ,(mark-scope body env)))]
    [`(,func ,args ...) (map (λ (e) (mark-scope e env)) code)]
    [(? number?) code]
    [sym (lookup sym env)]))
