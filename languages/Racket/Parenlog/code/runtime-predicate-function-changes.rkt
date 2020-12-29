(define (rename t)
  (define (replace-subterms t mapping)
    (match t
      [(? list?)
       (map (λ (st) (replace-subterms st mapping)) t)]
      [(? var?) (hash-ref mapping t t)]
      [_ t]))
  (define initial-vars (extract-vars t))
  (define mapping
    (for/hasheq ([v initial-vars]) (values v (gensym 'Var))))
  (replace-subterms t mapping))

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
 (yield 'done)]

(define (deref v env)
  (if (symbol? v)
      (if (hash-has-key? env v)
          (deref (hash-ref env v) env)
          v)
      (map (λ (e) (deref e env)) v)))