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
         (only-in racket/function curry)
         (only-in racket/list add-between append* drop group-by)
         (only-in racket/match match)
         (only-in racket/stream stream->list)
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
                 #:exclude-tags '(style script headappendix pre)
                 #:exclude-attrs '((class "ws") (class "code") (class "code"))
                 #:txexpr-proc move-head-appendix)])
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

(define (answer . elements)
  (txexpr 'span '((class "answer")) (append '("Answer: ") elements)))
(provide answer)

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

(define (exercise . elements)
  (txexpr 'p `((class "exercise")) (cons "Exercise: " elements)))
(provide exercise)

(define (notenum->anchor num)
  (txexpr 'a `((class "listingnote") (note-number ,(number->string num))) (list (number->string num))))

(define (codecmp #:f1 f1 #:lang1 [lang1 "racket"] #:fn1 [fn1 #f] #:f2 f2 #:lang2 [lang2 "racket"] #:fn2 [fn2 #f] #:notes [notes '()])
  ;; assign numbers like in enumerate in Python - could be in more general library
  (define (enumerate lst count)
    (match lst
      [(list) (list)]
      [(list-rest h t)
       (cons (cons count h) (enumerate t (add1 count)))]))
  ;; auxiliary function for collecting a list of (list of numbered notes for a single line)
  (define (number-notes-for-line grouped-line-notes line-num acc)
    (match acc
      [(cons lol-acc num-acc)
       (let* ([notes-on-line
               (cond [(findf (λ (p) (= (car (car p)) line-num)) grouped-line-notes) => (curry map cdr)]
                     [else empty])]
              [numbered-notes
               (enumerate notes-on-line num-acc)])
         (cons (append lol-acc (list numbered-notes)) (+ (length numbered-notes) num-acc)))]))
  ;; used to preserve line structure in included code
  (define (break-code-lines e acc)
    (match acc
      [(list-rest curr-line prev-lines)
       (if (and (string? e) (regexp-match? #rx"\n" e))
           (let* ([upto (cadr (regexp-match #rx"([^\n]*)\n" e))]
                  [remainder (regexp-replace (string-append upto "\n") e "")])
             (break-code-lines remainder (cons '() (cons (append curr-line (list upto)) prev-lines))))
           (cons (append curr-line (list e)) prev-lines))]))
  ;; for converting a numbered note to a paragraph
  (define (nn->p nn)
    (match nn
      [(cons num note)
       (let ([nns (number->string num)])
         (txexpr 'p `((class "comparative-listing-note")
                      (note-number ,nns))
                 `(,nns ". " ,note)))]))
  ;; add surrounding tags to preserve whitespace if necessary
  (define (preserve se)
    (if (string? se)
        (txexpr 'span '((class "ws")) (list se))
        se))
  ;; make sure a list of lines has the right length for comparison
  (define (extend lines num)
    (append lines (build-list (- num (length lines)) (λ (_) empty))))
  ;; finally, the top-level comparison div
  (let* ([pygmentized1 (includecode f1 #:lang lang1 #:filename (or fn1 f1))]
         [pygmentized2 (includecode f2 #:lang lang2 #:filename (or fn2 f2))]
         [pre1 (cadr (findf*-txexpr pygmentized1 (λ (tx) (and (txexpr? tx) (eq? (get-tag tx) 'pre)))))]
         [pre2 (cadr (findf*-txexpr pygmentized2 (λ (tx) (and (txexpr? tx) (eq? (get-tag tx) 'pre)))))]
         [pre1-lines (reverse (drop (foldl break-code-lines '(()) (get-elements pre1)) 1))]
         [pre2-lines (reverse (drop (foldl break-code-lines '(()) (get-elements pre2)) 1))]
         [grouped-line-notes (sort (group-by car notes) < #:key (compose car car))]
         [num-lines (max (length pre1-lines) (length pre2-lines))]
         [line-nums (in-range 1 (add1 num-lines))]
         [note-elem-groups (car (foldl (curry number-notes-for-line grouped-line-notes) (cons empty 1) (stream->list line-nums)))]
         [numbered-notes (append* note-elem-groups)])
    (txexpr 'div '((class "code-comparison"))
            (cons
             (txexpr 'div '((class "comparative-listing"))
                     (for/list ([ll (extend pre1-lines num-lines)]
                                [rl (extend pre2-lines num-lines)]
                                [note-grp note-elem-groups])
                       (txexpr 'div '((class "comparative-line"))
                               (list
                                (txexpr 'div '((class "comparative-snippet")) (map preserve ll))
                                (txexpr 'div '((class "comparative-snippet")) (map preserve rl))
                                (txexpr 'div '((class "comparative-lising-margin"))
                                        (add-between (map (compose notenum->anchor car) note-grp) " "))))))
             (map nn->p numbered-notes)))))
(provide codecmp)

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

(define (includecode path #:lang [lang "racket"] #:filename [fn ""] #:added-lines [added (list)] #:notelinenumbers [notes (list)])
  (highlight lang (file->string path #:mode 'text)))
(provide includecode)

(define (codenote . elements)
  (define (codenoteidx number)
    (txexpr 'codenoteidx empty (list "1")))
  (define (codenotecontents elements)
    (txexpr 'codenotecontents empty elements))
  (txexpr 'codenote empty
          (cons (codenoteidx 999)
                (list (codenotecontents elements)))))
(provide codenote)

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
