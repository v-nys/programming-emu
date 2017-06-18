(define-for-syntax (extract-stx-vars stx1 stxs)
  (define (extract-aux stx)
    (cond [(and
            (identifier? stx)
            (variable? (syntax->datum stx)))
           (list stx)]
          [(syntax->list stx)
           => (curry append-map extract-aux)]
          [else empty]))
  (remove-duplicates
   (append (extract-aux stx1) (append-map extract-aux stxs))
   eq?
   #:key syntax->datum))