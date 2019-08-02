(define (deref v env)
  (if (hash-has-key? env v)
      (deref (hash-ref env v) env)
      v))

(define (restrict-vars env q)
  (define vars (extract-vars q))
  (for/hasheq ([v vars]
               #:when (not (eq? v (deref v env))))
    (values v (deref v env))))