#lang racket

#|
CSC 324 Fall 2010
Assignment 4

Group:
Zeeshan Qureshi <g0zee@cdf.toronto.edu>
Aditya Mishra <c9mishra@cdf.toronto.edu>

Late Day Usage:
1 from g0zee and 1 from c9mishra
|#

#| Question 2

   Scheme324 to Haskell Compiler.

   Pattern Matching.
   Main Haskell Syntax.
   Connecting Functional Programming Semantics between Scheme and Haskell.
     Curried Functions.
   A Taste of Compiling.
     Unparsing and Code Generation: becoming common in IDEs, Preprocessors, etc.
     (Significant Semantic Analysis and some Parsing left to 488/2107 for the interested).

   In many smaller steps.
     Each allows something working to be handed in even if the whole question isn't completed.
     Given the spread in the class, better to do less parts well than many/all poorly.
     Also, with the multiple parts you have something concrete for the TAs or me to comment
      on before you get to the next part or if you're stuck on the next part.
     Don't hesitate to work with a partner, which is allowed on A4.

   Everyone should aim to do (a-c) well with full understanding.

   Most should do (d-e).

   Then (f-g) aren't much more (though (g) might look scary to some),
    but don't do them until you understand (d-e) well.

   And skip (h) if it rushes you or takes a lot of time better spent doing (a-g) well,
    or working on other material or even other courses.

   Don't hesitate to work with a partner that you learn from: it's allowed on A4. |#

#| (a) String Building.

   Complete flat-string, for building a string from groups of strings.
 
   It takes:
     any number of values built from numbers, symbols, strings and lists,
     converting the numbers and symbols to strings,
     appending all the resulting string/leaves of the s-expression.

   Avoid mutation and manual recursion: use apply, string-append, map, flatten. |#


(define (flat-string . ss)
  (apply string-append 
         (map 
          (λ (x) 
            (cond 
              ((number? x) (number->string x))
              ((symbol? x) (symbol->string x))
              ((string? x) x)))
          (flatten ss))))
#|            
(equal? (flat-string '(a (324 "b" c) () "de f")) "a324bcde f")
(display (flat-string))
|#



#| (b) Haskell Global Variables; Number, Variable and Unary Lambda Expressions. |#

; S->H given below translates Scheme code of the form
#;(define <var> <exp>) ; to the Haskell string of code: <var> = <exp><newline>

; An expression <exp> is either a number, variable, or unary lambda with single expression.
;  Complete exp->H, translating each type shown to a grouped string representing the string after it.
#;<var> ; <var>
#;-<num> ; (-<num>)
#;<num> ; <num>
#;(λ (<var>) <exp>) ; \<par> -> <exp>

; Put together on a concrete example:
#;(S->H '(define x -207)) ;=> "x = (-207)\n"
; Calling display on S->H of the following code should produce the string shown.
#;(define f (λ (a) 324)) ; f = \a -> 324
#;(define g (λ (b) (λ (a) b))) ; g = \b -> \a -> b
#;
(provide S->H exp->H)
#;
(define exp->H (match-lambda 
                 [`(,(or 'lambda 'λ) (,a) ,b) `("\\" ,a " -> " ,(exp->H b))]
                 [(?  number? a) (cond
                                   [(< a 0) 
                                    `( "(" ,a ")")]
                                   [(>= a 0)  a])]
                 [a a]))

#;                                     
(define (S->H code)
  (flat-string (match code
                 (`(define ,var ,exp)
                  `(,var " = " ,(exp->H exp) "\n")))))

#|
(display (S->H '(define x -207)))
(display (S->H '(define f (λ (a) 324))))
(display (S->H '(define g (λ (b) (λ (a) b)))))
|#

#| (c) Make and Name Global Unary Functions. |#

; Comment out S->H above.
; Extend it below to also handle the following form:
#;(define (<var> <arg>) <exp>) ; <var> <arg> = <exp>

; Refactor some of the commonality in your implementation of the two forms.
#;
(define (S->H code)
  (flat-string (match code
                 (`(define ,var ,exp)
                  (if (list? var)
                      `(,(first var) " = \\" ,(second var) " -> " ,(exp->H exp) "\n")
                      `(,var " = " ,(exp->H exp) "\n"))))))

#|
(display (S->H '(define x -207)))
(display (S->H '(define (f  a) 324)))
(display (S->H '(define (g b) (λ (a) b))))
|#
#| (d) Make and Name Curried Functions. |#

; Comment out S->H above.
; Extend it below to also handle the following form:
#;(define (...((<var> <a_0>) <a_1>) ... <a_n>) <exp>) ; <var> <a_0> <a_1> ... <a_n> = <exp>
;
; Refactor some of the commonality in your implementation of the three forms.
;   You might consider combining two (or all three?) of them.
;
; Hint: while the inverse of nest2 should come to mind, remember how you handled flat-string
;  (and, also, that it gets called at the end).


(define get-var (lambda (var)
                  (if (not (list? (first var)))
                      (list (first var) " " (rest var))
                      (list (get-var (first var)) " " (rest var)))))

#;
(define (S->H code)
  (flat-string (match code
                 (`(define ,var ,exp)
                  (if (not (list? var))
                      `(,var " = " ,(exp->H exp) "\n")
                      (if (list? (first var))
                          `(,(flatten (get-var var)) " = " ,(exp->H exp) "\n")
                          `(,(first var) " = \\" ,(second var) " -> " ,(exp->H exp) "\n")))))))



#;
(display (S->H '(define ((((((g c) d) w) 2) r) s) (λ (b) (λ (a) b)))))

#| (e) More Expressions: 2-way Conditional, Function Call, and Library Functions. |#

; Comment out exp->H above.

; Extend it below to also handle 'if', built from three expressions:
#;(if <tst> <thn> <els>) ; if <tst> then <thn> else <els>
; I found binary mapping useful, e.g. (map cons '(a b c) '((324 488) (165 148) (207))),
;  but handling three pieces is no big deal without it.

; Extend it to also handle function call, built from expressions:
#;(<fun> <a_0> ... <a_n>) ; (<fun> <a_0> ... <a_n>)

; Extend it to also translate library names (leaving others alone) via the given table.

#;
(define exp->H
  (let ([library '#hash((empty? . null) (first . head) (rest . tail) (cons . "(:)")
                                        (true . True) (false . False)
                                        (else . otherwise)
                                        (+ . "(+)") (- . "(-)")
                                        (< . "(<)") (<= . "(<=)") (= . "(==)") (>= . "(>=)") (> . "(>)"))])
    (match-lambda [`(,(or 'lambda 'λ) (,a) ,b) `("\\" ,a " -> " ,(exp->H b))]
                  [`(if ,a ,b ,c) `("if " ,a "then " ,(exp->H b) "else " ,(exp->H c))]
                  [(?  number? a) (cond
                                    [(< a 0) 
                                     `( "(" ,a ")")]
                                    [(>= a 0)  a])]
                  [`(,a . ,b) `(,(hash-ref library a a) ,(append* b))]
                  [a a])))


#| (f) Make and Name Conditional Functions. |#

; Comment out S->H above.
; Extend it below to also handle the following form:
#;(define (...((<var> <a_0>) <a_1>) ... <a_n>) (cond [(<tst> <exp>)
                                                      ...
                                                      (else <exp>)]))
#|
<var> <a_0> <a_1> ... <a_n>
  | <tst> = <exp>
  ...
  | otherwise = <exp>
|#

; Hint: don't match the full details in S->H's main match, (cond . ,clauses) is fine as part of it.


(define conditional-vars 
  (λ (x) (if (equal? (first x) 'else)
             `("\n| " otherwise " = " ,(rest x))
             `("\n| " ,(first x) " = " ,(rest x)))))
#;
(define (S->H code)
  (flat-string (match code
                 (`(define ,var (cond ,c)) 
                  `(,(flatten (get-var var)) ,(map conditional-vars c)))
                 (`(define ,var ,exp)
                  (if (list? (first var))
                      `(,(flatten (get-var var)) " = " ,(exp->H exp) "\n")
                      (if (list? var)
                          `(,(first var) " = \\" ,(second var) " -> " ,(exp->H exp))
                          `(,var " = " ,(exp->H exp) "\n")))))))


#;
(display (S->H '(define ((((((g c) d) w) 2) r) s) (a))))


#| (g) List Builders.

   Function quasi? detects a quasiquoted list pattern/builder in Scheme code.

   Comment out exp->H above, and extend it below to detect quasi? expressions,
    converting them by calling (pat->H (second <quasi-exp>)).
   Your function call clause likely accidentally matches such expressions, so
    handle <quasi-exp> before (or during).

   The implementation of pat->H is not required reading. If you do read it,
    note that it uses non-quasiquoted patterns, to avoid confusing the levels. |#




; Return whether a value as code is quasiquoted.
(define quasi? (match-lambda ((list 'quasiquote _) #t) (_ #f)))

; Convert quasiquoted empty, list of elements, and first-rest pattern/build code to Haskell.
(define pat->H
  (let ([unun (match-lambda ((list 'unquote x) x) (x x))])
    (match-lambda ((list) "[]")
                  ((list x 'unquote xs) `("(" ,(exp->H (unun x)) ":" ,(exp->H xs) ")"))
                  ((list x xs ...) `("[" ,(exp->H (unun x)) ,(map (λ (x) `(", " ,(exp->H (unun x)))) xs) "]"))
                  ((cons x xs) `("(" ,(exp->H x) ":" ,(exp->H xs) ")")))))


(define exp->H
  (let ([library '#hash((empty? . null) (first . head) (rest . tail) (cons . "(:)")
                                        (true . True) (false . False)
                                        (else . otherwise)
                                        (+ . "(+)") (- . "(-)")
                                        (< . "(<)") (<= . "(<=)") (= . "(==)") (>= . "(>=)") (> . "(>)"))])
    (match-lambda
      [(? quasi? a) (pat->H (second a))]
      [`(,(or 'lambda 'λ) (,a) ,b) `("\\" ,a " -> " ,(exp->H b))]
      [`(if ,a ,b ,c) `("if " ,a "then " ,(exp->H b) "else " ,(exp->H c))]
      [(?  number? a) (cond
                        [(< a 0) 
                         `( "(" ,a ")")]
                        [(>= a 0)  a])]
      [`(,a . ,b) `(,(hash-ref library a a) ,(append* b))]
      [a a])))


#| (h) List Patterns. |#

; Comment out S->H above.
; Extend it below for functions named and defined by pattern matching:
#;(define (...((<var> <a_0>) <a_1>) ... <a_n>) (match `(,<a_0> ... ,<a_n>)
                                                 [`(,<p00> ... ,<pn0>) <e0>]
                                                 [`(,<p01> ... ,<pn1>) <e1>]
                                                 ...))
#|
<var> <p00> ... <pn0> = <e0>
<var> <p01> ... <pn1> = <e1>
...
|#
(define find-var 
  (λ (var)
    (if (not (list? (first var)))
        (first var)
        (find-var (first var)))))

(define rectify-out 
  (λ (var)
    (if (or (equal? var '\, ) (equal? var '\] ) (equal? var '\[))
        (list )
        var)))
            
 
(define (S->H code)
  (flat-string (match code
                 (`(define ,var (match ,c . ,d)) 
                  `(,(flatten (map (λ (x) (list (find-var var) " " x)) 
                                   (map (λ (y) (list (pat->H (second (first y))) " = " (second y) "\n")) 
                                        d))))) 
                 (`(define ,var (cond ,c)) 
                  `(,(flatten (get-var var)) ,(map conditional-vars c)))
                 (`(define ,var ,exp)
                  (if (list? (first var))
                      `(,(flatten (get-var var)) " = " ,(exp->H exp) "\n")
                      (if (list? var)
                          `(,(first var) " = \\" ,(second var) " -> " ,(exp->H exp))
                          `(,var " = " ,(exp->H exp) "\n")))))))
