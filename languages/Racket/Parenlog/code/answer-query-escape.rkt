;; TODO take into account possibility of h just being a boolean literal
(define (answer-query q th env)
  (match q
    [(list) (generator () (yield env) 'done)]
    [(list-rest h t)
     (generator ()
                (if (procedure? (car h))
                    (let ([derefs (map (curry deref env) (cdr h))])
                      (when (apply (car h) derefs) (yield env)))
                    (for ([r th])
                      (let ([ans-gen (r h th env)])
                        (for ([h-ans (in-producer ans-gen 'done)])
                          (reyield (answer-query t th h-ans))))))
                'done)]))
