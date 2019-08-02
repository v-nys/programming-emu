#lang racket
(require racket/generator)
(define g
  (generator ()
             (yield 1)
             (yield 2)
             (yield 3)
             (for ([v '(4 5 6)])
               (yield v))))
(displayln (format "The first value is ~a" (g)))
(displayln (format "The second value is ~a" (g)))
(for ([v (in-producer g (void))])
  (displayln (format "The next value is ~a" v)))