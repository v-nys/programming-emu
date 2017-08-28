(define-syntax (compile-rule stx)
  (syntax-case stx ()
    [(_ H B ...)
     (with-syntax
         ([(VAR ...)
           (extract-stx-vars #'H (syntax->list #'(B ...)))]
          [RWH (rewrite-se #'H)]
          [(RWB ...)
           (map rewrite-se
                (syntax->list #'(B ...)))])
       (syntax/loc stx
         (λ (at th env)
           (define VAR (gensym (quote VAR)))
           ...
           (generator
            ()
            (let ([unified-env (unify at RWH env)])
              (when unified-env
                (reyield
                 (answer-query
                  (list RWB ...)
                  th
                  unified-env)))
              (yield 'done))))))]))