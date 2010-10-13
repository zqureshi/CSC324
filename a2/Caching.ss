#lang racket

(provide caching fibonacci)

(define (fibonacci x)
  (if (x . <= . 1) x
      (+ (fibonacci (- x 1)) (fibonacci (- x 2)))))

(define (caching func)
  (define ht (make-hash))
  (λ args
    (if (hash-ref ht args #f) (hash-ref ht args)
        (let ([val (apply func args)])
          (hash-set! ht args val)
          val))))
