(define (apply-variable-substitution subst e)
  (match e
    [(? list?)
     (map
      (curry apply-variable-substitution subst)
      e)]
    [_ (hash-ref subst e e)]))

(define (rename se)
  (define se-subst
    (for/hasheq ([var (extract-vars se)])
      (values var (gensym var))))
  (foldr
   (λ (e acc)
     (cons
      (apply-variable-substitution se-subst e)
      acc))
   empty
   se))

(define (compile-rule se)
  (λ (at th env)
    (generator ()
               (let* ([renamed-se
                       (rename se)]
                      [unified-env
                       (unify at (car renamed-se) env)]
                      [subquery (cdr renamed-se)])
                 (when unified-env
                   (reyield
                    (answer-query
                     subquery
                     th
                     unified-env)))
                 (yield 'done)))))