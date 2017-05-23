#lang racket
(require (only-in control while))

(define-logger emu)
(provide log-emu-debug log-emu-info log-emu-warning log-emu-error log-emu-fatal)

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