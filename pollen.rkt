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
         db
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
         (decode
          (decode (txexpr 'root '() elements)
                  #:txexpr-elements-proc decode-paragraphs
                  #:inline-txexpr-proc link-to-docs
                  #:string-proc (compose1 smart-quotes smart-dashes)
                  #:exclude-tags '(style script headappendix pre code)
                  #:exclude-attrs '((class "ws"))
                  #:txexpr-proc txexpr-proc)
          #:txexpr-proc postprocess-comparisons)]) ; need two steps of decoding
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
    ((compose
      move-head-appendix
      postprocess-notes)
     tx))
  result)

;(define (post-process tx) tx)
;
;(define (map-txexpr proc tx)
;  (proc
;   (txexpr (get-tag tx)
;           (get-attrs tx)
;           (map (λ (e)
;                  (if (txexpr? e)
;                      (map-txexpr proc e)
;                      e))
;                (get-elements tx)))))
;
;(define (my->html xexpr-or-xexprs)
;  (define (my->html-aux x)
;    (if ((listof txexpr?) x)
;        (map my->html-aux x)
;        (map-txexpr post-process x)))
;  (->html (my->html-aux xexpr-or-xexprs)))
;(provide my->html)

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

(define (popquiz . elements)
  (txexpr 'span '((class "popquiz")) (append '("Pop quiz: ") elements)))
(provide popquiz)

; FIXME: een lijst van elementen (of quoted expressie) wordt nu opgeslagen als string

(define (glossaryterm #:explanation [explanation "TODO: add an explanation"] #:canonical [canonical #f] . elements)
  (set! canonical (or canonical (string-append* elements)))
  (define sqlc
    (sqlite3-connect #:database (build-path (current-project-root) "db.sqlite") #:mode 'read/write))
  (query-exec sqlc (format "INSERT INTO Glossary(term,explanation) VALUES ('~a','~s')" canonical explanation))
  (txexpr 'termlabel
          `((id ,(format "term-~a" canonical))
            (class "glossaryterm"))
          ; wat is hier aan de hand?
          ; hieronder komen de elementen
          elements))
(provide glossaryterm)

(define (glossaryref #:canonical [canonical #f] . elements)
  (txexpr 'a
          `((href ,(format "/coda/glossary.html#~a" (or canonical (string-append* elements))))
            (class "glossaryref"))
          elements))
(provide glossaryref)

(define (glossary)
  (define sqlc
    (sqlite3-connect #:database (build-path (current-project-root) "db.sqlite") #:mode 'read-only))
  (txexpr
   'dl
   '()
   (for*/list ([(term def) (in-query sqlc "SELECT * FROM Glossary")] [dt? '(#t #f)])
     (if dt?
         (txexpr 'dt '() (list term))
         ;(txexpr 'dd '() (list (read (open-input-string def))))
         (let ([readdef (read (open-input-string def))])
           (if (list? readdef)
               (txexpr 'dd '() readdef)
               (txexpr 'dd '() (list readdef))))))))
(provide glossary)

(provide highlight)

(provide includecode)

(define (predicate . elements)
  (txexpr 'code '() elements))
(provide predicate)

; veronderstelt dat pagina's die dit bevatten pas worden gerenderd na hun descendants!
(define (toc-for-descendants metas)
  (define here
    (path->pagenode (hash-ref metas 'here-path)))
  (define
    children-here
    (children here (build-path (current-project-root) "index.ptree")))
  (define sqlc
    (sqlite3-connect #:database (build-path (current-project-root) "db.sqlite") #:mode 'read-only))
  `(ul () ,@(map (λ (c) `(li () (a ((href ,(string-append "/" (symbol->string c)))) ,(query-value sqlc (format "SELECT title FROM Titles WHERE pagenode = '~a'" (symbol->string c)))))) children-here)))
(provide toc-for-descendants)

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
;(provide toc)

;; getting the top-level pagetree is straightforward, but how can I get the current page's pagenode from a function?

(define (todo . elements)
  (txexpr 'todonote '() (append (list "TODO: ") elements)))
(provide todo)

(define (title metas str)
  (define here
    (path->pagenode (hash-ref metas 'here-path)))
  (define sqlc
    (sqlite3-connect #:database (build-path (current-project-root) "db.sqlite") #:mode 'read/write))
  (query-exec sqlc (format "INSERT INTO Titles(pagenode,title) VALUES ('~a','~a')" here str))
  (txexpr 'h1 '() (list str)))
(provide title)

; FIXME
; dit veronderstelt dat (de titels van) alle voorouders al gegenereerd zijn
; anderzijds kunnen de voorouders uitgesteld zijn tot na hun afstammelingen (bv. inhoudstafel pas na inhoud)
; optie 1: HTML post-processen
; optie 2: in parallel renderen en blokkeren tot nodige info er is? in template plaatsen kan pas als doc af is.
; zou moeten gaan: render eerst het mogelijke => eerst titels, dan inhoudstafels, dan navbars => heb een knooppunt nodig... (voordeel is wel dat de Makefile dan niet meer zo strak moet ordenen)
; zou niet nodig zijn als eerst alle docs werden gegenereerd en dan pas in template werden geplaatst...
(define (navbar loc)
  ; creates a trail of page nodes, from root to current node
  (define (trail lst)
    (aif (parent (first lst))
         (trail (cons it lst))
         lst))
  (define pairs
    (map
     (λ (e)
       (cons e (select 'h1 e)))
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
  (define block-tags (append '(img exercise note-nb toc cmp) default-block-tags))
  ;; cache is disabled to keep TOC up to date
  (define render-cache-active #f))
