;; MIT License
;; 
;; Copyright (c) 2017-2020 Vincent Nys
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
#lang at-exp racket
(require "logging.rkt"
         "navigation.rkt"
         "initSQLiteDB.rkt"
         anaphoric
         db
         sugar/coerce
         pollen/decode
         pollen/misc/tutorial
         pollen/pagetree
         pollen/setup
         (only-in racket/file file->string)
         (only-in racket/list add-between drop-right first)
         (only-in racket/match match match-lambda match-lambda**)
         racket/string
         txexpr
         scribble/srcdoc
         (for-doc racket/base scribble/manual))

;; creates database on the fly if necessary and returns path
(define dbpath/exists
  (let ([dbpath (build-path (current-project-root) "db.sqlite")])
    (if (file-exists? dbpath) dbpath (begin (setup-db!) dbpath))))

(define (root . elements)
  (let ([decoded
         (decode (txexpr 'root '() elements)
                 #:txexpr-elements-proc decode-paragraphs
                 #:string-proc (compose1 smart-quotes smart-dashes)
                 #:exclude-tags '(style script pre code listing)
                 #:exclude-attrs '((class "ws")))])
    decoded))
(provide root)

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
(provide
 (proc-doc
  code-discussion
  (->i
   ()
   ()
   #:rest [elems (listof txexpr?)]
   [result txexpr?])
  @{Wraps a number of listings produced by @racket[listing] with previous/next controls.}))
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

(define (listing #:fn [fn #f] #:highlights [hl empty] #:source src #:lang [lang "plaintext"] . elems)
  (let ([bare (bare-listing #:highlights hl #:source src #:lang lang)])
    `(listing
      ((class "annotated-listing"))
      ,bare
      (div ((class "code-annotation"))
           ,@elems))))
(provide
 (proc-doc
  listing
  (->i
   (#:source [src path-string?])
   (#:fn [fn (or/c string? #f)]
    #:highlights [hl (listof pair?)]
    #:lang [lang string?])
   #:rest [elems (listof (or/c string? txexpr?))]
   [result txexpr?])
  (#f empty "plaintext")
  @{Wraps a @racket[bare-listing] in a listing tag which also contains annotations supplied as @racket[elems].}))

(define (bare-listing #:highlights [hl empty] #:source src #:lang lang)
  `(pre
    ()
    (code
     ((class ,(format"lang-~a" lang)))
     ,(file->string src))))
(provide
 (proc-doc/names
  bare-listing
  (->*
   (#:source path-string? #:lang string?)
   (#:highlights (listof pair?))
   txexpr?)
  ((src lang) ((hl empty)))
  @{Wraps the contents of @racket[src] so that highlight.js can be applied. This procedure is incomplete. It does not highlight using @racket[hl] yet (which is an additional form of highlighting on top of highlight.js). @racket[hl] is a list of pairs indicating a line number and character number where highlighting is toggled.}))

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


(define (popquiz . elements)
  (txexpr 'span '((class "popquiz")) (append '("Pop quiz: ") elements)))
(provide popquiz)

; FIXME: een lijst van elementen (of quoted expressie) wordt nu opgeslagen als string

(define (glossaryterm #:explanation [explanation "TODO: add an explanation"] #:canonical [canonical #f] . elements)
  (set! canonical (or canonical (string-append* elements)))
  (define sqlc
    (sqlite3-connect #:database dbpath/exists #:mode 'read/write))
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
    (sqlite3-connect #:database dbpath/exists #:mode 'read-only))
  (txexpr
   'dl
   '()
   (for*/list ([(term def) (in-query sqlc "SELECT * FROM Glossary")] [dt? '(#t #f)])
     (if dt?
         (txexpr 'dt '() (list term))
         (let ([readdef (read (open-input-string def))])
           (if (list? readdef)
               (txexpr 'dd '() readdef)
               (txexpr 'dd '() (list readdef))))))))
(provide glossary)

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
    (sqlite3-connect #:database dbpath/exists #:mode 'read/write))
  (query-exec sqlc (format "INSERT INTO Titles(pagenode,title) VALUES ('~a','~a')" here str))
  (txexpr 'h1 '() (list str)))
(provide
 (proc-doc/names
  title (-> hash? string? txexpr?) (metas str)
  @{Registers @(racket str) as the title of the current page in the cross-referencing database and returns an @(code "h1") tagged X-expression containing @(racket str) as its contents.}))

(define (pagenode->pagetitle sym)
  (define sqlc
    (sqlite3-connect #:database dbpath/exists #:mode 'read-only))
  (or (query-maybe-value sqlc (format "SELECT title FROM Titles WHERE pagenode = '~a' LIMIT 1" (symbol->string sym))) "Untitled"))
(provide
 (proc-doc/names
  pagenode->pagetitle (-> symbol? string?) (sym)
  @{Looks up the title for the pagenode @(racket sym) in the cross-referencing database.}))


(define (navbar loc)
  (define (trail lst)
    (aif (parent (first lst))
         (trail (cons it lst))
         lst))
  (define pairs
    (map
     (λ (e)
       (cons e
             (match e
               ['index.html "Table of contents"]
               ['languages/index.html "Languages"]
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
(provide
 (proc-doc/names
  navbar
  (-> pagenode? (or/c "" txexpr?))
  (loc)
  @{Creates a nav element leading from the homepage to @racket[loc]. This is not a "smart" function. It does not work in the general case. Any page with a table of contents must be added to the code.}))

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
