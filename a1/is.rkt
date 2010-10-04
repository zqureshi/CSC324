#lang racket

(define (is b expr)
  (if (number? (unbox b))
      (let ([result (box (void))])
        (if (list? expr)  ; if expr is a list then evaluate it
            (is result expr)
            (set-box! result (unbox expr)))
        (equal? (unbox b) (unbox result)))
      (let ([l (box (if (list? (first expr))  ; set value of box according to
                        (void)                ; type of expression
                        (unbox (first expr))))]
            [r (box (if (list? (third expr))
                        (void)
                        (unbox (third expr))))])
        (is l (first expr))
        (is r (third expr))
        (set-box! b ((case (second expr) ; select operator and call it
                       ['+ +]
                       ['- -]
                       ['* *]
                       ['/ /]) (unbox l) (unbox r)))
        true)))