(module+ test
  (require rackunit)
  (check-equal?
   (unify '() '() #hasheq())
   #hasheq())
  (check-equal?
   (unify '(ancestor A a) '(ancestor b B) #hasheq())
   #hasheq((A . b) (B . a)))
  (check-equal?
   (unify '(A b) '(b b) #hasheq())
   #hasheq((A . b)))
  (check-equal?
   (unify '(A c) '(b b) #hasheq())
   #f)
  (check-equal?
   (unify '(A b) '(b A) #hasheq())
   #hasheq((A . b)))
  (check-equal?
   (unify '(pred A b C D E G) '(pred b A f f G h) #hasheq())
   #hasheq((A . b) (C . f) (D . f) (E . G) (G . h))))