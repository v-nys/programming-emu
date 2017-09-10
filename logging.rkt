#lang racket
(require (only-in control while) racket/provide)

(define-logger emu)
(provide (matching-identifiers-out #rx"^log-emu-.*" (all-defined-out)))

(define err-receiver (make-log-receiver emu-logger 'debug))

(define (start-log-receiver)
  (void
   (thread
    (λ ()
      (while #t
             (match-let ([(vector lvl msg _val topic) (sync err-receiver)])
               (displayln
                (format "[~a](~a):~a" lvl topic msg)
                (current-error-port))))))))
(provide start-log-receiver)