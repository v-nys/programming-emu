(define (reyield g)
  (for ([v (in-producer g 'done)])
    (yield v)))