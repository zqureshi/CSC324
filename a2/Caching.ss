#lang racket

(provide caching fibonacci)

(define (fibonacci x)
  (cond [(x . <= . 1) x]
        [else (+ (fibonacci (- x 1)) (fibonacci (- x 2)))]))

(define caching 
  (λ (func . args)
    func))