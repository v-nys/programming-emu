(let* ([realfriends-theory (cons (compile-rule `((realfriends X Y) (likes X Z) (likes Y Z) (,(compose not eq?) X Y))) theory)]
       [query '((realfriends athena X))]
       [expected
        (list
         #hasheq((X . ares))
         #hasheq((X . eratosthenes))
         #hasheq((X . pythagoras)))]
       [answer-generator (answer-query query realfriends-theory #hasheq())])
  (check-equal?
   (for/list ([a (in-producer answer-generator 'done)])
     (restrict-vars a query))
   expected))
(let* ([fact-theory (list (compile-rule `((fact) (,#t))))]
       [query '((fact))]
       [expected (list #hasheq())]
       [answer-generator (answer-query query fact-theory #hasheq())])
  (check-equal?
   (for/list ([a (in-producer answer-generator 'done)])
     (restrict-vars a query))
   expected))
(let* ([failure-theory (list (compile-rule `((failure) (,#f))))]
       [query '((failure))]
       [expected (list)]
       [answer-generator (answer-query query failure-theory #hasheq())])
  (check-equal?
   (for/list ([a (in-producer answer-generator 'done)])
     (restrict-vars a query))
   expected))