#lang racket

(define (subsequences l)
  (if (empty? l)
      '(())
      (append (subsequences (rest l))
              (map
               (lambda (x) (cons (first l) x))
               (subsequences (rest l))))))