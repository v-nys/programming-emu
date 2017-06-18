(define (env-deref env v)
  (cond
    [(bound-variable? env v)
     (env-deref env (hash-ref env v))]
    [else
     v]))

(define (env-restrict env l)
  (for/hasheq ([(k v) (in-hash env)]
               #:when (member k l))
    (values k (env-deref env v))))