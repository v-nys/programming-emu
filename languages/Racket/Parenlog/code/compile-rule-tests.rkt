(module+ test
  (define theory
    (list
     (compile-rule (friends X Y) (likes X Z) (likes Y Z))
     (compile-rule (likes ares battle))
     (compile-rule (likes athena battle))
     (compile-rule (feared X) (likes X battle))
     (compile-rule (part primes math))
     (compile-rule (part triangles math))
     (compile-rule (part logic math))
     (compile-rule (likes eratosthenes primes))
     (compile-rule (likes pythagoras triangles))
     (compile-rule (likes athena logic))
     (compile-rule (likes X Y) (part Z Y) (likes X Z))
     (compile-rule (likes (father athena) lightning))
     (compile-rule (greek X))))
  (let* ([query '((likes athena X))]
         [expected (list #hasheq((X . battle)) #hasheq((X . logic)) #hasheq((X . math)))]
         [answer-generator (answer-query query theory #hasheq())])
    (check-equal?
     (for/list ([a (in-producer answer-generator 'done)])
       (restrict-vars a query))
     expected)))