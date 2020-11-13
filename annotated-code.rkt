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

(define (insert-note note/no ann-c)
  (match-define (cons no note) note/no)
  (define note-line (string->number (attr-ref note 'line)))
  (define cmp-1? (member "cmp-1" (string-split (attr-ref note 'class))))
  (define tbodies
    (findf*-txexpr
     ann-c
     (λ (e)
       (and (txexpr? e)
            (eq? (get-tag e) 'tbody)))))
  (define tbody
    (first tbodies))
  (define trow
    (list-ref
     (findf*-txexpr
      tbody
      (λ (e)
        (and (txexpr? e)
             (eq? (get-tag e) 'tr))))
     (sub1 note-line)))
  (define note-cell
    (findf-txexpr
     trow
     (λ (e)
       (and (txexpr? e)
            (eq? (get-tag e) 'td)
            (not (equal? (attr-ref e 'colspan #f) "2"))))))
  (define new-cell
    (txexpr 'td
            (get-attrs note-cell)
            (append (get-elements note-cell)
                    (list
                     (txexpr
                      'div
                      `((class ,(format "listingnote active-number-circle number-circle ~a" "left-number-circle"))
                        (target-note ,(attr-ref note 'id)))
                      (list (number->string no)))))))
  (let-values
      ([(replaced _)
        (splitf-txexpr
         ann-c
         (λ (e)
           (and (txexpr? e)
                (equal?
                 (attr-ref e 'line-no #f)
                 (number->string note-line))
                (string-contains? (attr-ref e 'class) "code-note-margin")))
         (λ (_) new-cell))])
    replaced))

(define (number-note note/no)
  (define no (car note/no))
  (define note (cdr note/no))
  (define note-elements (get-elements note))
  (txexpr
   (get-tag note)
   (get-attrs note)
   (cons
    (txexpr
     'note-nb
     empty
     (list (number->string no)))
    note-elements)))

;; edit both the comparison (inserting note numbers in margin)
;; and the notes themselves (inserting numbers as elements)
(define (process-annotated-code group)
  (define ann-c (car group))
  (define notes/no (enumerate (cdr group) 1))
  (define inserted (foldl insert-note ann-c notes/no))
  (define numbered (map number-note notes/no))
  (cons inserted numbered))

(define (codenote #:line line . elements)
  (txexpr
   'div
   `((class "code-note-container") (id ,(symbol->string (gensym 'note-nb-))) (line ,(number->string line)))
   (list (txexpr 'aside '() elements))))

(define (cmpnote/2 #:line line . elements)
  (txexpr 'dummy empty empty))

(define (cmpnote/1 #:line line . elements)
  (txexpr 'dummy empty empty))

;; used to preserve line structure in included code
(define (break-code-lines e acc)
  (match acc
    [(list-rest curr-line prev-lines)
     (if (and (string? e) (regexp-match? #rx"\n" e))
         (let* ([upto (cadr (regexp-match #rx"([^\n]*)\n" e))]
                [remainder (regexp-replace (string-append upto "\n") e "")])
           (break-code-lines remainder (cons '() (cons (append curr-line (list upto)) prev-lines))))
         (cons (append curr-line (list e)) prev-lines))]))

(define (code-trowify line/no new)
  (define (group-adjacent-lines e acc)
    (match acc
      [(cons groups newest)
       #:when (not (= (add1 newest) e))
       (cons
        (cons (list e) groups)
        e)]
      [(cons groups 0)
       (cons
        '((1))
        e)]
      [(cons groups newest)
       (cons
        (cons
         (append
          (first groups)
          (list e))
         (cdr groups))
        e)]))
  (define new-groups
    (car (foldl group-adjacent-lines (cons '() 0) (sort new <))))
  (define (first-in-group? e)
    (ormap (λ (g) (= (first g) e)) new-groups))
  (define (last-in-group? e)
    (ormap (λ (g) (= (last g) e)) new-groups))
  (txexpr
   'tr
   '()
   (list
    (txexpr
     'td
     `((class "code-note-margin")
       (line-no ,(number->string (car line/no))))
     '())
    (txexpr
     'td
     `((colspan "2")
       (class
           ,(string-append
             "listing-line-content"
             (if (member (car line/no) new) " added-line" "")
             (if (first-in-group? (car line/no)) " first-added-line" "")
             (if (last-in-group? (car line/no)) " last-added-line" "")))
       (line-no ,(number->string (car line/no))))
     (map preserve (cdr line/no))))))
(define (code-tbodify lines new num-lines)
  (txexpr
   'tbody
   '()
   (map
    (λ (l) (code-trowify l new))
    (enumerate (extend lines num-lines) 1))))
(define (code-theadify fn raw-source)
  (txexpr
   'thead
   `()
   (list (txexpr
          'tr
          '()
          (list
           (txexpr
            'td
            `((class "code-note-margin")
              (id ,(symbol->string (gensym 'margin-cell-))))
            (list ""))
           (txexpr
            'td
            '((class "listing-header")
              (colspan "2"))
            (list
             fn
             (let ([generated-id (symbol->string (gensym "clipped-code-"))])
               (txexpr
                'i
                `((class "fa fa-files-o")
                  (aria-hidden "true")
                  (data-clipboard-action "copy")
                  (data-clipboard-text ,raw-source)))))))))))
(define (code-tablify lines lang fn new num-lines raw-source)
  (txexpr
   'table
   `((class "code-table"))
   (if fn
       (list (code-theadify fn raw-source) (code-tbodify lines new num-lines))
       (list (code-theadify "" raw-source) (code-tbodify lines new num-lines)))))

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

(define (annotated-code-generator txexprs)
  ;; this works by grouping a comparison (or standalone bit of code) with the following elements
  ;; those are assumed to be notes
  (define groups
    (reverse
     (foldl
      (λ (e acc)
        (let ([class-attr-values (string-split (attr-ref e 'class ""))])
          (if (member "annotated-code" class-attr-values)
              (cons (list e) acc)
              (cons (append (car acc) (list e)) (cdr acc)))))
      empty
      txexprs)))
  (define processed-groups (map process-annotated-code groups))
  (generator
   ()
   (for ([grp processed-groups])
     (for ([grp-elem grp])
       (yield grp-elem)))))

(define (postprocess-comparisons tx)
  (define (classify-nested-snippet-components prefix nsc)
    (if
     (not (txexpr? nsc))
     nsc
     (let* ([class-attr (attr-ref nsc 'class "")]
            [classes (string-split class-attr " ")])
       (cond
         [(member "listing-header" classes)
          (let ([tl
                 (attr-set
                  nsc
                  'class
                  (string-join
                   (list
                    class-attr
                    (format "~a__listing-header-cls" prefix))
                   " "))])
            (txexpr
             (get-tag tl)
             (get-attrs tl)
             (map
              (curry classify-nested-snippet-components prefix)
              (get-elements tl))))]
         [(member "fa-files-o" classes)
          (attr-set nsc 'class (string-join (list class-attr (format "~a__fa-files-o-cls" prefix)) " "))]
         ;; FIXME why isn't class being applied here?
         [(member "number-circle" classes)
          (attr-set nsc 'class (string-join (list class-attr (format "~a__number-circle-cls" prefix)) " "))]
         [(eq? (get-tag nsc) 'a)
          (attr-set nsc 'class (string-join (list class-attr (format "~a__a" prefix)) " "))]
         [(not (null? (get-elements nsc)))
          (txexpr
           (get-tag nsc)
           (get-attrs nsc)
           (map
            (curry classify-nested-snippet-components prefix)
            (get-elements nsc)))]
         [else nsc]))))
  (define (classify-nested-note-components prefix nnc)
    (if (not (txexpr? nnc))
        nnc
        (let ([class-attr (attr-ref nnc 'class "")])
          (case (get-tag nnc)
            ['aside (attr-set nnc 'class (string-join (list class-attr (format "~a__aside" prefix)) " "))]
            ;; FIXME why isn't class being applied here?
            ['note-nb (attr-set nnc 'class (string-join (list class-attr (format "~a__note-nb" prefix)) " "))]
            [else nnc]))))
  (define (number-cmp-component comp cntr)
    (let* ([class-attr (attr-ref comp 'class "")]
           [classes (string-split class-attr " ")])
      (cond
        [(member "annotated-code" classes)
         (let* ([new-cntr
                 (add1 cntr)]
                [new-class
                 (format "compared-snippet-~a" new-cntr)]
                [tl-only
                 (attr-set
                  comp
                  'class
                  (format
                   "~a ~a"
                   class-attr
                   new-class))])
           (cons
            (txexpr
             (get-tag tl-only)
             (get-attrs tl-only)
             (map
              (curry classify-nested-snippet-components new-class)
              (get-elements tl-only)))
            new-cntr))]
        [(member "code-note-container" classes)
         (let* ([new-class
                 (format "snippet-~a-note" cntr)]
                [tl
                 (attr-set
                  comp
                  'class
                  (string-join (list class-attr new-class) " "))])
           (cons
            (txexpr
             (get-tag tl)
             (get-attrs tl)
             (map (curry classify-nested-note-components new-class) (get-elements tl)))
            cntr))]
        [else (cons comp cntr)])))
  (if (eq? (get-tag tx) 'cmp)
      (car
       (map-accumulatel
        number-cmp-component
        0
        (get-elements tx)))
      tx))
(provide postprocess-comparisons)

;(define (postprocess-notes tx)
;  ;; note: would be cleaner not to use placeholder tag, but will leave as is because comparison is not assumed
;  (if (eq? (get-tag tx) 'root)
;      (let*-values
;          ([(temp clippings)
;            (splitf-txexpr
;             tx
;             (λ (e)
;               (and (txexpr? e)
;                    (let ([class-attr-values (string-split (attr-ref e 'class ""))])
;                      (or
;                       (member "annotated-code" class-attr-values)
;                       (member "code-note-container" class-attr-values)))))
;             (λ (e) (txexpr 'placeholder '() '())))]
;           [(clippings-generator)
;            (annotated-code-generator clippings)])
;        (let-values ([(replaced _)
;                      (splitf-txexpr
;                       temp
;                       (λ (e)
;                         (and (txexpr? e)
;                              (eq? (get-tag e) 'placeholder)))
;                       (λ (_) (clippings-generator)))])
;          replaced))
;      tx))
(define postprocess-notes (λ (x) x))
(provide postprocess-notes)

(define (includecode path #:lang [lang "racket"])
  (highlight
   lang
   (file->string path #:mode 'text)))

(define (newincludecode f #:lang [lang "racket"] #:fn [fn #f] #:new [new empty])
  (define raw-source (file->string f #:mode 'text))
; TODO: terug opknappen
;  (define pyg
;    (highlight
;     lang
;     raw-source))
;  (define pre (cadr (findf*-txexpr pyg (λ (tx) (and (txexpr? tx) (eq? (get-tag tx) 'pre))))))
;  (define pre-lines (reverse (drop (foldl break-code-lines '(()) (get-elements pre)) 1)))
;  (define num-lines (length pre-lines))
;  (define table (code-tablify pre-lines lang fn new num-lines raw-source))
  (txexpr 'div '((class "annotated-code")) (list raw-source)))

(provide (all-defined-out))
