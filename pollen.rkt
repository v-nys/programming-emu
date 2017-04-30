#lang racket/base
(require pollen/decode pollen/misc/tutorial pollen/pagetree txexpr)
(define (root . elements)
  (txexpr 'root empty (decode-elements elements
                                       #:txexpr-elements-proc decode-paragraphs
                                       #:string-proc (compose1 smart-quotes smart-dashes))))
(provide root)
(define (toc) (txexpr 'toc empty (next* 'toc.html (get-pagetree "index.ptree"))))
(provide toc)