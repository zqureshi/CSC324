#lang racket

(define (Toggle val)
  (define state val) ; Store original state
  (lambda ()
    (begin0 ; Return original state and then flip it
      state
      (set! state (not state))
      )))

