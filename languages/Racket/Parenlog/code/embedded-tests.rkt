(module+ test
  (require rackunit)
  (define-model my-model
    (:- (friends X Y) (likes X Z) (likes Y Z))
    (likes ares battle)
    (likes athena battle)
    (:- (feared X) (likes X battle))
    (part primes math)
    (part triangles math)
    (part logic math)
    (likes eratosthenes primes)
    (likes pythagoras triangles)
    (likes athena logic)
    (:- (likes X Y) (part Z Y) (likes X Z))
    (likes (father athena) lightning)
    (greek X)
    (:- (realfriends X Y)
        (likes X Z)
        (likes Y Z)
        (,(compose not eq?) X Y)))
  (let* ([query '((realfriends athena X))]
         [expected
          (list
           #hasheq((X . ares))
           #hasheq((X . eratosthenes)))])
    (check-equal?
     (query-model my-model '((realfriends athena X)) #:limit 2)
     expected)))