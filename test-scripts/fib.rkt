#lang racket

(define fibacc
 (lambda (n f f-1)
  (if (eqv? 1 n)
   f
   (fibacc (sub1 n) (+ f f-1) f))))

(define (fib n) (fibacc n 1 1))

(fib 1)
(fib 2)
(fib 3)
(fib 4)
(fib 5)
(fib 10)
(fib 100)
(fib 1000)
(fib 10000)