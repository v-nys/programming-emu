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
#lang racket
(require
  racket/generator
  pollen/decode
  (only-in pollen/unstable/pygments highlight)
  txexpr
  (only-in list-utils map-accumulatel)
  "logging.rkt")

;; assign numbers like in enumerate in Python - could be in more general library
(define (enumerate lst count)
  (match lst
    [(list) (list)]
    [(list-rest h t)
     (cons
      (cons count h)
      (enumerate t (add1 count)))]))


;; add surrounding tags to preserve whitespace if necessary
(define (preserve se)
  (if (string? se)
      (txexpr 'span '((class "ws")) (list se))
      se))

;; make sure a list of lines has the right length for comparison
(define (extend lines num)
  (append lines (build-list (- num (length lines)) (λ (_) empty))))

(define (codecmp
         #:f1 f1 ; the location of the source code
         #:lang1 [lang1 "racket"]
         #:fn1 [fn1 #f] ; the name that's displayed in the listing
         #:new/1 [new/1 empty] ; which lines are new
         #:f2 f2
         #:lang2 [lang2 "racket"]
         #:fn2 [fn2 #f]
         #:new/2 [new/2 empty])
  (txexpr 'dummy empty empty))


(define (includecode path #:lang [lang "racket"]  #:fn [fn #f])
  (let ([highlighted (highlight
                      lang
                      (file->string path #:mode 'text))])
    (if fn
        `(div () (span () ,fn) ,highlighted)
        highlighted)))

(provide (all-defined-out))
