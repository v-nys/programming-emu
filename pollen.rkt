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
; TODO: find out why get-pagetree only works when this thing is a function
; TODO: don't just use the source file name, also include the title
; select 'h1 p should work
; so: map over next -> tocentry filename-as-string title-as-string
;(define (toc) (txexpr 'toc empty (next* 'toc.html (get-pagetree "index.ptree"))))
(define (toc)
  (txexpr 'toc empty
          (map (λ (fn) (txexpr 'tocentry empty (list fn (select 'h1 fn))))
               (next* 'toc.html (get-pagetree "index.ptree")))))
(provide toc)

(module setup racket/base
  (provide (all-defined-out))
  (require pollen/setup)
  (define block-tags (cons 'toc default-block-tags)))