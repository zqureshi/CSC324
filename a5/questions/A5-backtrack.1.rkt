#lang racket
(provide -< ? No.
         cutable-with
         -<! define-cutable
         ?- ?*)

#| A minimal implementation of McCarthy's amb operator,
    called "-<" here to suggest branching computation,
    also worth pronouncing "either".
 
   (-< <e> ...) => one of <e> ...
   (?) => (abort and) run computation again, using the next <e>

   Branching can be nested, and the "next" expression is
    next in a depth-first left-right traversal of the tree.
 
   E.g. "let x be either 10 or 20, add x to either 3 or 4":

     > (let ([x (-< 10 20)])
         (+ x (-< 3 4)))
     13
     > (?)
     14
     > (?)
     23
     > (?)
     24
     > (?)
     No. |#

#| What to do when fail/next/continue/skip is kept here.

   The "what to do" is a function to call that jumps to a
    certain expression as if it had an alternate value.
   This is called a "continuation".

   Causing a fail will be provided to user as a function '?'.
   Wrapped in a setter-getter function. |#
(define get/set-?
  (let ([? (void)])
    (case-lambda [() ?]
                 [(new-?) (set! ? new-?)])))

#| Ends all waiting branches, asking for more displays "No." |#
(define (No.) (get/set-? (λ () (displayln "No."))))
#| Start with no waiting branches. |#
(No.)
#| For testing in REPL. |#
(define-syntax-rule (?- <e>) (let/cc end (No.) (-< <e> (begin (No.) (?)) (end))))
(define-syntax-rule (?* <e>) (?- (let ([e <e>])
                                   (display "> ") (print e) (newline)
                                   (?))))


#| Public API to ask for next branch. |#
(define (?) ((get/set-?)))

#| Branching. |#
(define-syntax -<
  (syntax-rules ()
    [(-< <e0>) <e0>] ; mainly as base case for this macro
    [(-< <e0> <e> ...)
     (let/cc resatisfy ; capture where this expression *was*
       ; first time through, but <e> ... will execute later via ?
       (let ([old-? (get/set-?)])
         (get/set-? (λ () (get/set-? old-?)
                      (resatisfy (-< <e> ...)))))
       ; execute <e0> the first time
       <e0>)]))

#| Cutting. |#
(define-syntax-rule (cutable-with <!> <es> ...)
  (let* ([old-? (get/set-?)]
         [<!> (λ () (get/set-? old-?) '!)])
    <es> ...))

#| 'Unhygienic' Syntactic Forms for Cutting.
   CSC324 students: read implementation at your own risk. |#
(define-syntax (-<! s)
  (syntax-case s ()
    [(-<! . <es>)
     (with-syntax ([! (datum->syntax #'<es> '!)])
       ; Not sure why cutable-with didn't work here, yet did in define-cutable.
       #'(let* ([old-? (get/set-?)]
                [! (λ () (get/set-? old-?) '!)])
           (-< . <es>)))]))
(define-syntax (define-cutable <whole-form>)
  (syntax-case <whole-form> ()
    [(define-cutable (<name> . <args>) . <stmts>)
     ; Having <name> from original context was crucial.
     (with-syntax ([! (datum->syntax #'<name> '!)])
       #'(define (<name> . <args>)
           (cutable-with ! . <stmts>)))]))