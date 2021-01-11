#lang racket
(require "core.rkt")
(struct model (rules))
(provide model?)
(define-syntax (expand-rule-or-fact stx)
  (syntax-case stx (:-)
    [(_ (:- head-query body-query ...))
     (syntax/loc stx
       (compile-rule `(head-query body-query ...)))]
    [(_ fact)
     (syntax/loc stx
       (compile-rule `(fact)))]))
(define-syntax (define-model stx)
  (syntax-case stx ()
    [(_ id rule-or-fact ...)
     (syntax/loc stx
       (define id
         (model
          (list (expand-rule-or-fact rule-or-fact) ...))))]))
(provide define-model)
(define (query-model model #:limit [limit #f] query)
  (define gen
    (answer-query
     query
     (model-rules model)
     #hasheq()
     #:limit limit))
  (for/list ([subst (in-producer gen 'done)])
    (restrict-vars subst query)))
(provide query-model)