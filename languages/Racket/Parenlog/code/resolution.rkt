(define (reyield g)
  (for ([v (in-producer g 'done)])
    (yield v)))

(define (answer-query q th env)
  (match q
    [(list) (generator () (yield env) (yield 'done))]
    [(list-rest h t)
     (generator ()
                (for ([r th])
                  (let ([ans-gen (r h th env)])
                    (for ([h-ans (in-producer ans-gen 'done)])
                      (reyield (answer-query t th h-ans)))))
                (yield 'done))]))

(define (compile-rule se)
  (λ (at th env)
    (generator ()
               (let* ([renamed-se (rename se)]
                      [unified-env (unify at (car renamed-se) env)]
                      [subquery (cdr renamed-se)])
                 (when unified-env
                   (reyield (answer-query subquery th unified-env)))
                 (yield 'done)))))