(module+ test
  (let ([renamee '((likes X Y) (part Y Z))])
    (check-equal?
     (set-intersect (extract-vars renamee) (extract-vars (rename renamee)))
     (set))))