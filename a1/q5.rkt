#lang racket

(define (length-primitive l len)
  (if (empty? l)
      (set-box! len 0)
      (let ([res (box (void))]) ; declare variable to store result of recursive call
        (length-primitive (rest l) res)
        (set-box! len (+ (unbox res) 1)))))

(define (length-tail l len)
  (unless (empty? l)
    (set-box! len (+ (unbox len) 1))
    (length-tail (rest l) len)))

(define (reverse-tail l r)
  (unless (empty? l)
    (set-box! r (cons (first l) (unbox r)))
    (reverse-tail (rest l) r)))

(define (running-sum-primitive l n)
  (if (empty? l)
      (set-box! n '())
      (let ([res (box '())])  ; declare variable to store result of recursive call
        (running-sum-primitive (rest l) res)
        (set-box! n (map (lambda (x) (+ x (first l))) (cons 0 (unbox res)))))))
