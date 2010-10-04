#lang racket

(struct List (first rest))
(struct Empty ())

(define (map-such-that l f p)
  (cond [(Empty? l) (Empty)]
        [(p (List-first l))
         (List (f (List-first l)) (map-such-that (List-rest l) f p))]
        [else (map-such-that (List-rest l) f p)]))

;; Prints out a List
(define (List-print l)
  (display "(")
  (map-such-that l (lambda (x) (display " ") (display x)) (lambda (x) #t))
  (display " )")
  (newline))

