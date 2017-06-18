(define-for-syntax (rewrite-se stx)
  (cond
    [(identifier? stx)
     (if (variable? (syntax->datum stx))
         stx
         (quasisyntax/loc stx (quote #,stx)))]
    [(syntax->list stx)
     => (lambda (stxs)
          (quasisyntax/loc stx
            (list #,@(map rewrite-se stxs))))]))