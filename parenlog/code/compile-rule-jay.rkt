(define-syntax (compile-rule stx)
  (syntax-case stx ()
    [(_ head body-query ...)
     (with-syntax ([(var ...) (extract-vars #'head (syntax->list #'(body-query ...)))]
                   [head-sans-vars (rewrite-se #'head)]
                   [(body-query-sans-vars ...)
                    (map rewrite-se
                         (syntax->list #'(body-query ...)))])
       (syntax/loc stx
         (lambda (model env query)
           (define var (gensym 'var))
           ...
           (define new-env (unify env head-sans-vars query))         
           (generator
            ()
            (when new-env
              (let ([body-sans-vars (list body-query-sans-vars ...)])
                (reyield yield (model-env-generator/queries model new-env body-sans-vars))))
            (yield generator-done)))))]))