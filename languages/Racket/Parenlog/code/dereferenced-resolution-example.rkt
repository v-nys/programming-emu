(module+ test
  (define theory
    (map compile-rule
         '(((friends X Y) (likes X Z) (likes Y Z))
           ((likes ares battle))
           ((likes athena battle))
           ((feared X) (likes X battle))
           ((part primes math))
           ((part triangles math))
           ((part logic math))
           ((likes eratosthenes primes))
           ((likes pythagoras triangles))
           ((likes athena logic))
           ((likes X Y) (part Z Y) (likes X Z))
           ((likes (father athena) lightning))
           ((greek X)))))
  (let* ([query '((likes athena X))]
         [expected (list #hasheq((X . battle))
                         #hasheq((X . logic))
                         #hasheq((X . math)))]
         [answer-generator (answer-query query theory #hasheq())])
    (check-equal?
     (for/list ([a (in-producer answer-generator 'done)])
       (restrict a query))
     expected)))