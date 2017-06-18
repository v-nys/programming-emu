(module+ test
  (require syntax/macro-testing)
  (check-equal?
   (phase1-eval
    (extract-stx-vars #'(human X) (list #'(mortal X))))
   '(X))
  (check-equal?
   (phase1-eval
    (extract-stx-vars #'(likes X Y) (list #'(part Z Y) #'(likes X Z))))
   '(X Y Z)))