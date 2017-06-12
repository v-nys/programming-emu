#lang racket
(require "logging.rkt" 
         scribble/xref
         setup/xref
         sugar/coerce
         txexpr)
(define docs-class "docs")
(define (docs module-path export . xs-in)
  (log-emu-debug (format "export is: ~s\n" export))
  (define xref (load-collections-xref))
  (define linkname (if (null? xs-in) (list export) xs-in))
  (define tag (xref-binding->definition-tag xref (list module-path (->symbol export)) #f))
  (define-values (path url-tag)
    (xref-tag->path+anchor xref tag #:external-root-url "http://pkg-build.racket-lang.org/doc/"))
  `(a ((href ,(format "~a#~a" path url-tag)) (class ,docs-class)) ,@linkname))
(define (link-to-docs tx)
  (cond [(and (eq? (get-tag tx) 'span)
              (attrs-have-key? (get-attrs tx) 'class)
              (member (attr-ref tx 'class) '("k" "nb")))
         (docs 'racket (string-join (get-elements tx) ""))]
        [else tx]))
(provide link-to-docs)