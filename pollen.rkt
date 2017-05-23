;; MIT License
;; 
;; Copyright (c) 2017 Vincent Nys
;; 
;; Permission is hereby granted, free of charge, to any person obtaining a copy
;; of this software and associated documentation files (the "Software"), to deal
;; in the Software without restriction, including without limitation the rights
;; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;; copies of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:
;; 
;; The above copyright notice and this permission notice shall be included in all
;; copies or substantial portions of the Software.
;; 
;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;; SOFTWARE.
#lang racket/base
(require "doc-linking.rkt"
         "logging.rkt"
         "navigation.rkt"
         pollen/core
         pollen/decode
         pollen/misc/tutorial
         pollen/pagetree
         pollen/setup
         (only-in pollen/unstable/pygments highlight)
         racket/file
         racket/string
         txexpr)

(provide highlight)

(define (root . elements)
  (let ([decoded
         (txexpr 'root empty
                 (decode-elements elements
                                  #:txexpr-elements-proc decode-paragraphs
                                  #:inline-txexpr-proc link-to-docs
                                  #:string-proc (compose1 smart-quotes smart-dashes)
                                  #:exclude-tags '(style script)))])
    (log-emu-debug (format "undecoded root is: ~s\n" (txexpr 'root empty elements)))
    (log-emu-debug (format "decoded root is: ~s\n" decoded))
    decoded))
(provide root)

(define (toc #:depth [depth 1]
             #:exceptions [exceptions '(index.html)]
             #:ptree [ptree-fn "index.ptree"]
             #:ordered? [ol? #f])
  (let ([ptree (get-pagetree ptree-fn)]
        [prefix (string-replace (path->string (current-directory)) (path->string (current-project-root)) "")])
    (ptree->html-list
     (map-elements
      (λ (e) (if (symbol? e) (string->symbol (string-append prefix (symbol->string e))) e))
      (splice-out-nodes (prune-tree/depth ptree depth) exceptions))
     ol?)))
(provide toc)

(define (todo . elements)
  (txexpr 'span '((class "todonote")) elements))
(provide todo)

(define (aside . elements)
  (txexpr 'span '((class "aside")) elements))
(provide aside)

(define (work . elements)
  (txexpr 'span '((class "work")) elements))
(provide work)

(define (caveat . elements)
  (txexpr 'p '((class "warning")) elements))
(provide caveat)

(define (capitalize str)
  (regexp-replace #rx"^." str string-upcase))
(provide capitalize)

(define (includecode path #:lang [lang "racket"] #:filename [fn ""])
  (highlight lang (file->string path #:mode 'text)))
(provide includecode)

;; this should be fine, even if pollen.rkt is evaluated multiple times
;; as per section 11.1 of the reference:
;; "A thread that has not terminated can be garbage collected if it is unreachable and suspended or if it is unreachable and blocked on only unreachable events through functions such as [...] sync"
(start-log-receiver)
(module setup racket/base
  (provide (all-defined-out))
  (require pollen/setup)
  (define block-tags (cons 'toc default-block-tags))
  ;; cache is disabled to keep TOC up to date
  (define render-cache-active #f))
