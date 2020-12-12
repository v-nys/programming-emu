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
         "highlight-spans.rkt"
         anaphoric
         db
         sugar/coerce
         pollen/core
         pollen/decode
         pollen/misc/tutorial
         pollen/pagetree
         pollen/setup
         (only-in racket/file file->lines file->string)
         (only-in pollen/template/html ->html)
         (only-in pollen/unstable/pygments highlight)
         (only-in racket/contract listof)
         (only-in racket/list add-between append* drop drop-right first flatten group-by last)
         (only-in racket/match match match-lambda match-lambda**)
         racket/string
         txexpr)

(define (root . elements)
  (let ([decoded
         (decode (txexpr 'root '() elements)
                  #:txexpr-elements-proc decode-paragraphs
                  #:inline-txexpr-proc link-to-docs
                  #:string-proc (compose1 smart-quotes smart-dashes)
                  #:exclude-tags '(style script headappendix pre code listing)
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
    ((compose
      move-head-appendix)
     tx))
  result)

;; volgende stap:
;; bij attribuutwijziging wordt klasse hidden verwijderd van descendant listings
;; en toegevoegd aan descendant listings met ander nummer dan current-listing

;; ten slotte spans highlighten -> in de define van listing, niet hier
(define (code-discussion . elems)
  (define (listing? e) (and (txexpr? e) (eq? (get-tag e) 'listing)))
  (define listings (filter listing? elems))
  (define
    numbered-listings
    (reverse
     (cdr
      (foldl
       (match-lambda**
        [(listing (cons counter listings))
         (let ([numbered-listing
                (attr-set
                 listing
                 'listing-number
                 (->string counter))])
           (cons
            (add1 counter)
            (cons
             (if (> counter 1) (attr-join numbered-listing 'class "hidden") numbered-listing)
             listings)))])
       (cons 1 (list))
       listings))))
  ; TODO: check that there is at least one element
  ; TODO: check that all elements are listings or whitespace
  `(div ((class "code-discussion")
         (style "border: 1px solid")
         (num-listings
          ,(->string
            (length listings)))
         (current-listing "1"))
        ; first step will be te number listings
        (div ((class "code-discussion-controls")) (button "previous") (button "next"))
        ,@numbered-listings))
(provide code-discussion)
;; TODO: simplify tests
(module+ test
  (require rackunit)
  (test-equal?
   "code gebruikt op pagina"
   (listing #:fn "myfile.rkt" #:highlights '((1 1) (3 4)) #:source "languages/Racket/Parenlog/code/my-compile-rule.rkt" "Op regel 1 merk je... Op regel 3 zie je...")
   "blabla")
  (test-equal?
   "code discussion op pagina"
   (code-discussion
    (listing #:fn "myfile.rkt" #:highlights '((1 1) (3 4)) #:source "languages/Racket/Parenlog/code/my-compile-rule.rkt" "Op regel 1 merk je... Op regel 3 zie je...")
    (listing #:fn "myfile.rkt" #:highlights '((1 1) (3 4)) #:source "languages/Racket/Parenlog/code/my-compile-rule.rkt" "Op regel 2 merk je... Op regel 3 zie je..."))
   "blablabla"))

;; elems: de annotaties!
(define (listing #:fn [fn #f] #:highlights [hl empty] #:source src #:lang [lang "plaintext"] . elems)
  (let ([bare (bare-listing #:highlights hl #:source src #:lang lang)])
    `(listing ((class "annotated-listing")) ,bare (div ((class "code-annotation")) ,@elems))))
(provide listing)

(define (bare-listing #:highlights [hl empty] #:source src #:lang lang)
  `(pre
    ()
    (code
     ((class ,lang))
     ,(file->string src))))
(provide bare-listing)

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

(provide codecmp)

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
  `(ul () ,@(map (λ (c) `(li () (a ((href ,(string-append "/" (symbol->string c)))) ,(pagenode->pagetitle c)))) children-here)))
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

(define (pagenode->pagetitle sym)
  (define sqlc
    (sqlite3-connect #:database (build-path (current-project-root) "db.sqlite") #:mode 'read-only))
  (query-value sqlc (format "SELECT title FROM Titles WHERE pagenode = '~a' LIMIT 1" (symbol->string sym))))

; FIXME
; dit veronderstelt dat (de titels van) alle voorouders al gegenereerd zijn
; anderzijds kunnen de voorouders uitgesteld zijn tot na hun afstammelingen (bv. inhoudstafel pas na inhoud)
; korte termijnoplossing: conventies
; lange termijnoplossing: in parallel renderen en blokkeren tot nodige info er is; in template plaatsen kan pas als doc af is.
; zou moeten gaan: render eerst het mogelijke => eerst titels, dan inhoudstafels, dan navbars,...
; voordeel is dat ik de Makefile dan niet meer zo strak moet ordenen
; kan misschien zonder patchen als decodefunctie checkt of er nog "unmet dependencies" zijn, dan thread.sleep of iets dergelijks oproept...
(define (navbar loc)
  ; creates a trail of page nodes, from root to current node
  ; starts from a list with the current node, prepends most recent remaining ancestor until done
  (define (trail lst)
    (aif (parent (first lst))
         (trail (cons it lst))
         lst))
  ; transforms trail of pagenodes into trail of pagenodes with displayable representation
  ; so this is what I should change
  ; basically, for everything which has "languages"
  (define pairs
    (map
     ; this is less than ideal
     ; will have to do until parallel rendering with dependencies is working
     (λ (e)
       (cons e
             (match e
               ['index.html "Table of contents"]
               ['languages/index.html "Languages"]
               ;['languages/C♯/index.html "C♯"]
               ;['languages/Python/index.html "Python"]
               ['languages/Racket/index.html "Racket"]
               ['languages/Racket/Parenlog/parenlog.html "Parenlog"]
               [_ (pagenode->pagetitle e)])))
     (trail (list loc))))
  (if (> (length pairs) 1)
      (txexpr
       'nav
       '((id "header6"))
       (add-between
        (cons
         (txexpr 'a `((class "fa fa-home") (href ,(format "/~a" (caar pairs))))) ; for home symbol
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
