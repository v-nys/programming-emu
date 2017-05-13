#lang racket/base
(require pollen/core
         pollen/decode
         pollen/misc/tutorial
         pollen/pagetree
         txexpr)
(define (root . elements)
  (txexpr 'root empty (decode-elements elements
                                       #:txexpr-elements-proc decode-paragraphs
                                       #:string-proc (compose1 smart-quotes smart-dashes))))
(provide root)

(define (toc)
  (txexpr
   'ul
   '((class "toc"))
   (map (λ (pn) `(li (a ((href ,(symbol->string pn))) ,(select 'h2 pn))))
        (remove 'index.html (siblings 'index.html (get-pagetree "index.ptree"))))))
(provide toc)

;(define (toc #:exceptions [exceptions '(index.html)] #:depth [depth 1] #:ptree [ptree-fn 'index.ptree])
;  (txexpr
;   'ul
;   '((class "toc"))
;   (map (λ (pn) `(li (a ((href ,(symbol->string pn))) ,(select 'h2 pn))))
;        (remove 'index.html (siblings 'index.html (get-pagetree "index.ptree"))))))
;(provide toc)

(define (todo . elements)
  (txexpr 'span '((class "todonote")) elements))
(provide todo)

(define (work . elements)
  (txexpr 'span '((class "work")) elements))
(provide work)

(define (caveat . elements)
  (txexpr 'p '((class "warning")) elements))
(provide caveat)

(define (capitalize str)
  (regexp-replace #rx"^." str string-upcase))
(provide capitalize)

(module setup racket/base
  (provide (all-defined-out))
  (require pollen/setup)
  (define block-tags (cons 'toc default-block-tags)))