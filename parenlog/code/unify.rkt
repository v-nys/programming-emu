(define (variable? e)
  (and (symbol? e)
       (char-upper-case?
        (string-ref
         (symbol->string e)
         0))))

(define (unbound-variable? e env)
  (and (variable? e)
       (not (hash-has-key? env e))))





(define (unify se1 se2 env)
  (match* (se1 se2)
    [((? list?) (? list?))
     #:when (= (length se1) (length se2))
     (foldl (λ (e1 e2 acc) (and acc (unify e1 e2 acc))) env se1 se2)]
    [(x y)
     #:when (unbound-variable? x env)
     (hash-set env x y)]
    [((? variable?) x)
     (unify (hash-ref env se1) se2 env)]
    [(x (? variable?))
     (unify se2 se1 env)]
    [(x x) env]
    [(_ _) #f]))