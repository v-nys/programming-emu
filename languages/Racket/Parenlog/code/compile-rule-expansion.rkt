(λ (at th env)
     (define X (gensym (quote X)))
     (define Y (gensym (quote Y)))
     (define Z (gensym (quote Z)))
     (generator
      ()
      (let ([unified-env
             (unify at (list (quote friends) X Y) env)])
        (when unified-env
          (reyield
           (answer-query
            (list
             (list (quote likes) X Z)
             (list (quote likes) Y Z))
            th
            unified-env)))
        'done)))
