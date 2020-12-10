(define (extract-vars se)
  (match se
    [(? list?) (apply set-union (map extract-vars se))]
    [_ #:when (variable? se) (set se)]
    [_ (set)]))

(define (apply-variable-substitution subst e)
  (match e
    [(? list?) (map (curry apply-variable-substitution subst) e)]
    [_ (hash-ref subst e e)]))

(define (rename se)
  (define se-subst
    (for/hasheq ([var (extract-vars se)])
      (values var (gensym var))))
  (foldr
   (λ (e acc)
     (cons (apply-variable-substitution se-subst e) acc))
   empty
   se))