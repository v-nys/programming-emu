(define-for-syntax (extract-se stx)
  (cond
    [(identifier? stx)
     (if (variable? (syntax->datum stx))
         (list stx)
         empty)]
    [(syntax->list stx)
     => (curry map extract-se)]
    [else
     empty]))

(define-for-syntax (extract-vars head-stx body-stxs)
  (remove-duplicates
   (flatten
    (cons (extract-se head-stx)
          (map extract-se body-stxs)))
   #:key syntax-e))