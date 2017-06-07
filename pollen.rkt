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
         (only-in pollen/template/html ->html)
         (only-in pollen/unstable/pygments highlight)
         (only-in racket/contract listof)
         racket/file
         racket/string
         txexpr
         (only-in uri-old uri-escape))

(provide highlight)

(define (root . elements)
  (let ([decoded
         (decode (txexpr 'root '() elements)
                 #:txexpr-elements-proc decode-paragraphs
                 #:inline-txexpr-proc link-to-docs
                 #:string-proc (compose1 smart-quotes smart-dashes)
                 #:exclude-tags '(style script headappendix)
                 #:txexpr-proc move-head-appendix)])
    (log-emu-debug (format "decoded root is: ~s~n" decoded))
    decoded))
(provide root)

(define (move-head-appendix tx)
  (cond [(eq? (get-tag tx) 'root)
         (let-values ([(pruned clippings)
                       (splitf-txexpr tx (λ (e) (if (txexpr? e) (eq? (get-tag e) 'headappendix) #f)))])
           (txexpr 'root '()
                   (if (not (null? clippings))
                       (append clippings (list (txexpr 'unmoved '() (get-elements pruned))))
                       (list (txexpr 'unmoved '() (get-elements pruned))))))]
        [else tx]))

(define (post-process tx)
  (if (eq? (get-tag tx) 'termlabel)
      (txexpr 'a (get-attrs tx) (cddr (get-elements tx)))
      tx))

(define (map-txexpr proc tx)
  (proc
   (txexpr (get-tag tx)
           (get-attrs tx)
           (map (λ (e) (if (txexpr? e) (map-txexpr proc e) e))
                (get-elements tx)))))

(define (my->html xexpr-or-xexprs)
  (define (my->html-aux x)
    (if ((listof txexpr?) x)
        (map my->html-aux x)
        (map-txexpr post-process x)))
  (->html (my->html-aux xexpr-or-xexprs)))
(provide my->html)

;                                          
;                                          
;                                          
;                                          
;     ;                                    
;     ;                                    
;   ;;;;;;      ;;;;;     ;;;; ;    ;;;;;  
;     ;        ;    ;;   ;    ;;  ;;     ; 
;     ;              ;  ;      ;  ;        
;     ;         ;;;;;;  ;      ;  ;;       
;     ;       ;;     ;  ;      ;   ;;;;;;  
;     ;       ;      ;  ;      ;        ;; 
;     ;       ;     ;;  ;      ;         ; 
;     ;       ;;   ;;;   ;    ;;  ;     ;; 
;      ;;;     ;;;;; ;    ;;;; ;   ;;;;;   
;                              ;           
;                        ;    ;            
;                         ;;;;             
;                                          

(define (aside . elements)
  (txexpr 'span '((class "aside")) elements))
(provide aside)

(define (capitalize str)
  (regexp-replace #rx"^." str string-upcase))
(provide capitalize)

(define (caveat . elements)
  (txexpr 'p '((class "warning")) elements))
(provide caveat)

(define (code . elements)
  (txexpr 'span '((class "code")) elements))
(provide code)

(define (explanation . elements)
  (txexpr 'span '((class "explanation")) elements))
(provide explanation)

(define (glossaryterm->paragraph tx)
  (txexpr 'p `((id ,(car (get-elements tx))))
          (list (txexpr 'span '((class "glossarytermlabel"))
                        (list (car (get-elements tx)) ": "))
                (cadr (get-elements tx)))))

;; TODO could sort alphabetically?
(define (pn->glossary-paragraphs pn)
  (let ([maybe-glossaryterms
         (findf*-txexpr (get-doc pn)
                        (λ (e) (and (txexpr? e) (eq? (get-tag e) 'termlabel))))])
    (if maybe-glossaryterms
        (map glossaryterm->paragraph
             maybe-glossaryterms) empty)))
(define (glossary)
  (txexpr 'div
          '()
          (sort
           (foldr (λ (pn acc) (append (pn->glossary-paragraphs pn) acc)) empty
                 ;; including these would lead to an infinite loop, because they have a dependency on the glossary
                 (pagetree->list (splice-out-nodes (get-pagetree "index.ptree") '(index.html glossary.html))))
           (λ (p1 p2) (string<?(string-downcase (attr-ref p1 'id)) (string-downcase (attr-ref p2 'id)))))))
(provide glossary)

(define (glossaryterm #:explanation [explanation "TODO: add an explanation"] #:canonical [canonical #f] . elements)
  (set! canonical (or canonical (string-append* elements)))
  (txexpr 'termlabel
          `((href ,(format "/glossary.html#~a" canonical))
            (class "glossaryterm"))
          (append (list canonical explanation) elements (list '(sup () "†")))))
(provide glossaryterm)

(define (glossaryref #:canonical [canonical #f] . elements)
  (txexpr 'a
          `((href ,(format "/glossary.html#~a" (or canonical (string-append* elements))))
            (class "glossaryref"))
          elements))
(provide glossaryref)

(define (output . elements)
  (txexpr 'div '((class "output")) elements))
(provide output)

(define (includecode path #:lang [lang "racket"] #:filename [fn ""])
  (highlight lang (file->string path #:mode 'text)))
(provide includecode)

(define (predicate . elements)
  (apply code elements))
(provide predicate)

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
  (txexpr 'span '((class "todonote")) (append (list "TODO: ") elements)))
(provide todo)

(define (work . elements)
  (txexpr 'span '((class "work")) elements))
(provide work)

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
