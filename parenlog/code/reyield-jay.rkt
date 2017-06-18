(define-syntax-rule (reyield yield g)
  (for ([ans (in-producer g generator-done)])
    (yield ans)))