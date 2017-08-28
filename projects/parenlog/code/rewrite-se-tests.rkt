(module+ test
  (check-equal?
   (phase1-eval (rewrite-se #'(emus like Something)))
   '(list 'emus 'like Something))
  (check-equal?
   (phase1-eval (rewrite-se #'(emus like programming)))
   '(list 'emus 'like 'programming)))