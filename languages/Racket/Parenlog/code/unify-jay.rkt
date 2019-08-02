(define (variable? q)
  (and (symbol? q)
       (char-upper-case?
        (string-ref 
         (symbol->string q)
         0))))

(define (unbound-variable? env q1)
  (and (variable? q1)
       (not (hash-has-key? env q1))))

(define (bound-variable? env q1)
  (and (variable? q1)
       (hash-has-key? env q1)))

(define (unify env q1 q2)
  (cond
    [(equal? q1 q2)
     env]
    [(unbound-variable? env q1)
     (hash-set env q1 q2)]
    [(unbound-variable? env q2)
     (hash-set env q2 q1)]
    [(bound-variable? env q1)
     (unify env (hash-ref env q1) q2)]
    [(bound-variable? env q2)
     (unify env q1 (hash-ref env q2))]
    [(and (pair? q1) (pair? q2))
     (let ([new-env (unify env (car q1) (car q2))])
       (and new-env
            (unify new-env (cdr q1) (cdr q2))))]
[else #f]))
