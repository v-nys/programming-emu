(define-for-syntax (rewrite-se stx)
  (cond
    [(syntax->list stx) =>
     (λ (stxs)
       (syntax-case stx (unquote)
         [(unquote func)
        #'func]
         [_ (datum->syntax stx (cons #'list (map rewrite-se stxs)))]))]
    [(and (identifier? stx)
          (not (var? (syntax->datum stx))))
     (with-syntax ([non-prolog-id stx])
          #`(quote non-prolog-id))]
    [else stx]))

;; clause in answer-query
[(list-rest h t)
 (cond
   [(procedure? (first h))
    (when (apply (first h) (deref (cdr h) env))
      (for ([final-env (in-producer (answer-query t theory env) 'done)])
        (yield final-env)))]
   [(boolean? (first h))
    (when (first h)
      (for ([final-env (in-producer (answer-query t theory env) 'done)])
        (yield final-env)))]
   [else
    (for ([rule theory])
      (for ([new-env (in-producer (rule h theory env) 'done)])
        (for ([final-env (in-producer (answer-query t theory new-env) 'done)])
          (yield final-env))))])
 'done]

(define (deref v env)
  (if (symbol? v)
      (if (hash-has-key? env v)
          (deref (hash-ref env v) env)
          v)
      (map (λ (e) (deref e env)) v)))
