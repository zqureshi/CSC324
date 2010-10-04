#lang racket

(define (subsequences l)
  (if (empty? l)
      '(())
      (append (subsequences (rest l))
              (map
               (lambda (x) (cons (first l) x))
               (subsequences (rest l))))))

; append element e at all positions in suffix
(define (insert-at-all e pref suff)
  (if (empty? suff)
      (list (append (append pref (list e))))
      (append (list (append pref (list e) suff))
              (insert-at-all e (append pref (list (first suff))) (rest suff)))))

(define (rearrangements l)
  (if (empty? l)
      '(())
      (apply append 
             (map (lambda (x) (insert-at-all (first l) '() x))
                  (rearrangements (rest l))))))