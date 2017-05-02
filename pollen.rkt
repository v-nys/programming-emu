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
  (txexpr 'toc empty
          (map (λ (fn) (txexpr 'tocentry empty (list fn (select 'h1 fn))))
               (next* 'toc.html (get-pagetree "index.ptree")))))
(provide toc)

(define (todo . elements)
  (txexpr 'span '((class "todonote")) elements))
(provide todo)

(module setup racket/base
  (provide (all-defined-out))
  (require pollen/setup)
  (define block-tags (cons 'toc default-block-tags)))