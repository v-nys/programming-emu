(define (variables-in q)
  (match q
    [(? variable? v) (list v)]
    [(? symbol?) empty]
    [(? list? l)
     (append-map variables-in l)]))