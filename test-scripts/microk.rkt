#lang racket

;; racket interface
(define empty-state '( () . 0) )

(define (call/empty-state g) (g empty-state))

(define (next-stream goal)
 (let ((state (goal empty-state)))
  (thunk (define result (car state))
         (set! state ((cdr state)))
         result)))

;; micro-kanren implementation
(define (var c) (vector c))
(define (var? x) (vector? x))
(define (var=? x1 x2)
 (= (vector-ref x1 0) (vector-ref x2 0)))
(define (ext-s x v s) (cons `(,x . ,v) s))

(define (walk u s)
 (let ((pr (and (var? u) (assf (lambda (v) (var=? u v)) s))))
  (if pr (walk (cdr pr) s) u)))

(define mzero '())

(define (unit s/c) (cons s/c mzero))

(define (=== u v)
 (lambda (s/c)
  (let ((s (unify u v (car s/c))))
   (if s (unit (cons s (cdr s/c))) mzero))))

(define (unify u v s)
 (let ((u (walk u s)) (v (walk v s)))
  (cond
   ((and (var? u) (var? v) (var=? u v)) s)
   ((var? u) (ext-s u v s))
   ((var? v) (ext-s v u s))
   ((and (pair? u) (pair? v))
    (let ((s (unify (car u) (car v) s)))
     (and s (unify (cdr u) (cdr v) s))))
   (else (and (eqv? u v) s)))))


(define (call/fresh f)
 (lambda (s/c)
  (let ((c (cdr s/c)))
   ((f (var c)) (cons (car s/c) (+ c 1))))))

(define (disj g1 g2)
 (lambda (s/c) (mplus (g1 s/c) (g2 s/c))))

(define (conj g1 g2)
 (lambda (s/c) (bind (g1 s/c) g2)))

(define (mplus $1 $2)
 (cond
  ((null? $1) $2)
  ((procedure? $1) (lambda () (mplus $2 ($1))))
  (else (cons (car $1) (mplus (cdr $1) $2)))))

(define (bind $ g)
 (cond
  ((null? $) mzero)
  ((procedure? $) (lambda () (bind ($) g)))
  (else (mplus (g (car $)) (bind (cdr $) g)))))

;; test programs
(define (sixes x)
 (disj (=== x 6) (lambda (s/c) (thunk ((sixes x) s/c)))))

(define (fives x)
 (disj (=== x 5) (lambda (s/c) (thunk ((fives x) s/c)))))

(define fives-and-sixes
 (call/fresh (lambda (x) (disj (fives x) (sixes x)))))


(define stream (next-stream fives-and-sixes))