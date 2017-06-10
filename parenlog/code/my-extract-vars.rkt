(define (extract-vars se)
  (match se
    [(? list?) (apply set-union (map extract-vars se))]
    [_ #:when (variable? se) (set se)]
    [_ (set)]))