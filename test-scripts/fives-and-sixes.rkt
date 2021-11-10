#lang racket

(define (fas n)
 (define (fas n acc )
  (if (zero? n)
      acc
      (fas (sub1 n) (if (eqv? acc 5) 6 5))))
 (fas n 5))


(fas 10)
(fas 101)
(fas 1000)
(fas 10001)