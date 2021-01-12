(define (answer-query conjunction theory env #:limit [limit #f])
  (let ([gen
         (generator
          ()
          (match conjunction
            [(list)
             (yield env)
             'done]
            [(list-rest h t)
             (cond
               [(procedure? (first h))
                (when (apply (first h) (deref (cdr h) env))
                  (for ([final-env
                         (in-producer (answer-query t theory env) 'done)])
                    (yield final-env)))]
               [(boolean? (first h))
                (when (first h)
                  (for ([final-env
                         (in-producer (answer-query t theory env) 'done)])
                    (yield final-env)))]
               [else
                (for ([rule theory])
                  (for ([new-env
                         (in-producer (rule h theory env) 'done)])
                    (for ([final-env
                           (in-producer
                            (answer-query t theory new-env) 'done)])
                      (yield final-env))))])
             'done]))]
        [answers 0])
    (generator
     ()
     (for ([v (in-producer gen 'done)]
           #:break (and limit (= answers limit)))
       (yield v)
       (set! answers (add1 answers)))
     'done)))
