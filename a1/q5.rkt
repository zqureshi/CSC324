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
