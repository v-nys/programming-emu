(define-for-syntax (rewrite-se stx)
  (cond
    [(syntax->list stx)
     => (compose
         (curry datum->syntax stx)
         (compose
          (curry cons #'list)
          (curry map rewrite-se)))]
    [(and (identifier? stx)
          (not (variable? (syntax->datum stx))))
     (with-syntax ([STX stx]) (syntax/loc stx (quote STX)))]
    [else stx]))