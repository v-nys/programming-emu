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
(require "annotated-code.rkt"
         "doc-linking.rkt"
         "logging.rkt"
         "navigation.rkt"
         anaphoric
         pollen/core
         pollen/decode
         pollen/misc/tutorial
         pollen/pagetree
         pollen/setup
         (only-in pollen/template/html ->html)
         (only-in pollen/unstable/pygments highlight)
         (only-in racket/contract listof)
         (only-in racket/list add-between append* drop drop-right first flatten group-by last)
         (only-in racket/match match match-lambda)
         racket/string
         txexpr)

(define (root . elements)
  (let ([decoded
         (decode (txexpr 'root '() elements)
                 #:txexpr-elements-proc decode-paragraphs
                 #:inline-txexpr-proc link-to-docs
                 #:string-proc (compose1 smart-quotes smart-dashes)
                 #:exclude-tags '(style script headappendix pre code)
                 #:exclude-attrs '((class "ws"))
                 #:txexpr-proc txexpr-proc)])
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

(define (txexpr-proc tx)
  (define result
    ((compose move-head-appendix postprocess-notes)
     tx))
  result)

(define (post-process tx)
  (if (eq? (get-tag tx) 'termlabel)
      (txexpr 'a (get-attrs tx) (cddr (get-elements tx)))
      tx))

(define (map-txexpr proc tx)
  (proc
   (txexpr (get-tag tx)
           (get-attrs tx)
           (map (λ (e)
                  (if (txexpr? e)
                      (map-txexpr proc e)
                      e))
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

(define (answer . elements)
  (txexpr 'span '((class "answer")) (append '("Answer: ") elements)))
(provide answer)

(define (capitalize str)
  (regexp-replace #rx"^." str string-upcase))
(provide capitalize)

(define (exercise . elements)
  (txexpr 'exercise '() (cons "Exercise: " elements)))
(provide exercise)

(provide codenote)

(provide cmpnote/1) ; TODO: should just use an optional argument to indicate which listing this belongs with

(provide cmpnote/2)

(provide codecmp)

(provide newincludecode)

(define (explanation . elements)
  (txexpr 'span '((class "explanation")) elements))
(provide explanation)

(define (glossaryterm->paragraph tx)
  (txexpr 'p `((id ,(car (get-elements tx))))
          (list (txexpr 'span '((class "glossarytermlabel"))
                        (list (car (get-elements tx)) ": "))
                (cadr (get-elements tx)))))

(define (pn->glossary-paragraphs pn)
  (let ([maybe-glossaryterms
         (findf*-txexpr (get-doc pn)
                        (λ (e) (and (txexpr? e) (eq? (get-tag e) 'termlabel))))])
    (if maybe-glossaryterms
        (map glossaryterm->paragraph
             maybe-glossaryterms) empty)))

(define (popquiz . elements)
  (txexpr 'span '((class "popquiz")) (append '("Pop quiz: ") elements)))
(provide popquiz)

(define (glossary)
  (txexpr 'div
          '()
          (sort
           (foldr (λ (pn acc) (append (pn->glossary-paragraphs pn) acc)) empty
                  ;; including these would lead to an infinite loop, because they have a dependency on the glossary
                  (pagetree->list (splice-out-nodes (get-pagetree (build-path (current-project-root) "index.ptree")) '(index.html coda/glossary.html))))
           (λ (p1 p2) (string<?(string-downcase (attr-ref p1 'id)) (string-downcase (attr-ref p2 'id)))))))
(provide glossary)

(define (glossaryterm #:explanation [explanation "TODO: add an explanation"] #:canonical [canonical #f] . elements)
  (set! canonical (or canonical (string-append* elements)))
  (txexpr 'termlabel
          `((href ,(format "/coda/glossary.html#~a" canonical))
            (class "glossaryterm"))
          (append (list canonical explanation) elements (list '(sup () "†")))))
(provide glossaryterm)

(define (glossaryref #:canonical [canonical #f] . elements)
  (txexpr 'a
          `((href ,(format "/coda/glossary.html#~a" (or canonical (string-append* elements))))
            (class "glossaryref"))
          elements))
(provide glossaryref)

(provide highlight)

(provide includecode)

(define (predicate . elements)
  (txexpr 'code '() elements))
(provide predicate)

(define (toc #:depth [depth 1]
             #:exceptions [exceptions '(index.html)]
             #:ptree [ptree-fn "index.ptree"]
             #:ordered? [ol? #f])
  (log-emu-info "generating TOC")
  (let ([ptree (get-pagetree ptree-fn)]
        [prefix
         (string-replace
          (path->string (current-directory))
          (path->string (current-project-root))
          "")])
    (ptree->html-list
     (map-elements
      (λ (e)
        (if
         (symbol? e)
         (string->symbol
          (string-append
           prefix
           (symbol->string e)))
         e))
      (splice-out-nodes
       (prune-tree/depth ptree depth)
       exceptions))
     ol?)))
(provide toc)

;; getting the top-level pagetree is straightforward, but how can I get the current page's pagenode from a function?

(define (todo . elements)
  (txexpr 'todonote '() (append (list "TODO: ") elements)))
(provide todo)

(define (navbar loc)
  (define (trail lst)
    (aif (parent (first lst))
         (trail (cons it lst))
         lst))
  (define pairs
    (map
     (λ (e)
       (cons e (select 'h2 e)))
     (trail (list loc))))
  (if (> (length pairs) 1)
      (txexpr
       'nav
       '((id "header6"))
       (add-between
        (cons
         (txexpr 'a `((class "fa fa-home") (href ,(format "/~a" (caar pairs)))))
         (map
          (match-lambda
            [(cons node-sym title-str)
             (txexpr 'a `((href ,(format "/~a" node-sym))) (list title-str))])
          (drop-right (cdr pairs) 1)))
        " » "))
      ""))

(provide navbar)

;; this should be fine, even if pollen.rkt is evaluated multiple times
;; as per section 11.1 of the reference:
;; "A thread that has not terminated can be garbage collected if it is unreachable and suspended or if it is unreachable and blocked on only unreachable events through functions such as [...] sync"
(start-log-receiver)
(module setup racket/base
  (provide (all-defined-out))
  (require pollen/setup)
  (define block-tags (append '(img exercise note-nb toc) default-block-tags))
  ;; cache is disabled to keep TOC up to date
  (define render-cache-active #f))
