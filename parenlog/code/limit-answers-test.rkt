(let* ([query '((friends athena X))]
       [expected
        (list
         #hasheq((X . ares))
         #hasheq((X . athena)))]
       [answer-generator (answer-query query theory #hasheq() #:limit 2)])
  (check-equal?
   (for/list ([a (in-producer answer-generator 'done)])
     (restrict-vars a query))
   expected))