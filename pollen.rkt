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
(require (only-in control while)
         pollen/core
         pollen/decode
         pollen/misc/tutorial
         pollen/pagetree
         pollen/setup
         (only-in pollen/unstable/pygments highlight)
         racket/file
         racket/match
         racket/string
         scribble/xref
         setup/xref
         sugar/coerce
         txexpr)

(provide highlight)

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
         (log-emu-debug (format "export argument is: ~s" (string-join (get-elements tx) "")))
         (log-emu-debug (format "remaining arguments are: ~s" (cdr (get-elements tx))))
         (docs 'racket (string-join (get-elements tx) ""))]
        [else tx]))

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
    (log-emu-debug (format "generating TOC for ~v at ~v" ptree ptree-fn))
    ;; shows that current-directory is that of a source file
    (log-emu-debug (format "project root is ~v" (current-project-root)))
    (log-emu-debug (format "current directory is ~v" (current-directory)))
    (log-emu-debug (format "path diff is ~v" (string-replace (path->string (current-directory)) (path->string (current-project-root)) "")))
    (ptree->html-list
     (map-elements
      (λ (e) (if (symbol? e) (string->symbol (string-append prefix (symbol->string e))) e))
      (splice-out-nodes (prune-tree/depth ptree depth) exceptions)) ol?)))
(provide toc)

(define (ptree->html-list ptree ol?) (ptree->html-list/aux ptree ol? select))
(define (ptree->html-list/aux ptree ol? select) ; for easy mocking
  (txexpr
   (if ol? 'ol 'ul)
   (if (eq? (car ptree) 'pagetree-root) '((class "toc")) '())
   (foldr
    (λ (t acc)
      (if (symbol? t)
          (cons `(li (a ((href ,(string-append "/" (symbol->string t)))) ,(let ([h2 (select 'h2 t)]) (or h2 t)))) acc)
          (cons `(li (a ((href ,(string-append "/" (symbol->string (car t))))) ,(let ([h2 (select 'h2 (car t))]) (or h2 (car t))))) (cons `(li ,(ptree->html-list/aux t ol? select)) acc))))
    empty
    (cdr ptree))))
(module+ test
  (let ([select (λ (el t) (if (symbol? t) t (car t)))])
    (check-equal?
     (ptree->html-list/aux '(pagetree-root (mama (son grandson1 grandson2) (daughter granddaughter1 granddaughter2)) uncle) #t select)
     '(ol ((class "toc"))
          (li (a ((href "/mama")) mama))
          (li (ol
               (li (a ((href "/son")) son))
               (li (ol (li (a ((href "/grandson1")) grandson1)) (li (a ((href "/grandson2")) grandson2))))
               (li (a ((href "/daughter")) daughter))
               (li (ol (li (a ((href "/granddaughter1")) granddaughter1)) (li (a ((href "/granddaughter2")) granddaughter2))))))
          (li (a ((href "/uncle")) uncle))))))

;; adapted from MB's code for children
(define (children/nested p [pt-or-path (current-pagetree)])
  (and pt-or-path p
       (let ([pagenode (->pagenode p)]
             [pt (get-pagetree pt-or-path)])
         (if (eq? pagenode (car pt))
             (cdr pt)
             (ormap (λ(x) (children/nested pagenode x)) (filter list? pt))))))
(module+ test
  (require rackunit)
  (check-equal?
   (children/nested
    'mama
    '(pagetree-root (mama (son grandson1 grandson2) (daughter granddaughter1 granddaughter2)) uncle))
   '((son grandson1 grandson2) (daughter granddaughter1 granddaughter2))))

(define (prune-tree/depth se depth #:root [subtree-root 'pagetree-root])
  (cond
    [(not (list? se)) se]
    [(equal? depth 1)
     (cons subtree-root (children subtree-root se))]
    [(> depth 1)
     (cons
      subtree-root
      (map
       (λ (pt r) (prune-tree/depth pt (- depth 1) #:root r))
       (children/nested subtree-root se)
       (children subtree-root se)))]))
(module+ test
  (check-equal?
   (prune-tree/depth '(pagetree-root (mama son daughter) uncle) 1)
   '(pagetree-root mama uncle))
  (check-equal?
   (prune-tree/depth '(pagetree-root (mama (son grandson1 grandson2) (daughter granddaughter1 granddaughter2)) uncle) 1)
   '(pagetree-root mama uncle))
  (check-equal?
   (prune-tree/depth '(pagetree-root (mama (son grandson1 grandson2) (daughter granddaughter1 granddaughter2)) uncle) 2)
   '(pagetree-root (mama son daughter) uncle)))

(define (splice-out-nodes se clips)
  ;; second value indicates a hierarchical shift
  ;; if parent is clipped, grandchildren become children
  (define (aux se clips)
    (cond [(and (not (list? se)) (memq se clips)) (cons #f #f)]
          [(not (list? se)) (cons se #f)]
          [else
           (let* ([mapped-children
                   (filter car (for/list ([e (cdr se)]) (aux e clips)))]
                  [shifted-children
                   (foldr
                    (λ (p acc) (if (cdr p) (append (car p) acc) (cons (car p) acc)))
                    empty
                    mapped-children)]
                  [new-se (cons (car se) shifted-children)])
             (if (not (memq (car se) clips))
                 (cons new-se #f)
                 (cons shifted-children #t)))]))
  (car (aux se clips)))

(module+ test
  (check-equal?
   (splice-out-nodes '(pagetree-root (mama (son grandson1 grandson2) (daughter granddaughter1 granddaughter2)) uncle) '(daughter grandson2))
   '(pagetree-root (mama (son grandson1) granddaughter1 granddaughter2) uncle)))

(module+ test
  (check-equal?
   (splice-out-nodes '(pagetree-root (mama (son grandson1 grandson2) (daughter granddaughter1 granddaughter2)) uncle) '(daughter grandson2 granddaughter1))
   '(pagetree-root (mama (son grandson1) granddaughter2) uncle)))

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

(define-logger emu)
(define err-receiver (make-log-receiver emu-logger 'debug))
(void
 (thread
  (λ ()
    (while #t
           (match-let ([(vector lvl msg _val topic) (sync err-receiver)])
             (displayln
              (format "[~a](~a):~a" lvl topic msg)
              (current-error-port)))))))

(module setup racket/base
  (provide (all-defined-out))
  (require pollen/setup)
  (define block-tags (cons 'toc default-block-tags))
  ;; cache is disabled to keep TOC up to date
  (define render-cache-active #f))
