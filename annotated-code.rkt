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
  (only-in pollen/unstable/pygments highlight)
  txexpr)

;; assign numbers like in enumerate in Python - could be in more general library
(define (enumerate lst count)
  (match lst
    [(list) (list)]
    [(list-rest h t)
     (cons (cons count h) (enumerate t (add1 count)))]))

(define (insert-note note/no cmp)
  (define no (car note/no))
  (define note (cdr note/no))
  (define note-line (string->number (attr-ref note 'line)))
  (define cmp-1? (member "cmp-1" (string-split (attr-ref note 'class))))
  (define tbodies
    (findf*-txexpr
     cmp
     (λ (e)
       (and (txexpr? e)
            (eq? (get-tag e) 'tbody)))))
  (define tbody
    (if cmp-1?
        (first tbodies)
        (last tbodies)))
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
                      `((class ,(format "listingnote active-number-circle number-circle ~a" (if cmp-1? "left-number-circle" "right-number-circle")))
                        (target-note ,(attr-ref note 'id)))
                      (list (number->string no)))))))
  (let-values
      ([(replaced _)
        (splitf-txexpr
         cmp
         (λ (e)
           (and (txexpr? e)
                (equal?
                 (attr-ref e 'line-no #f)
                 (number->string note-line))
                (if cmp-1?
                    (string-contains? (attr-ref e 'class) "cmp-1")
                    (string-contains? (attr-ref e 'class) "cmp-2"))))
         (λ (_) new-cell))])
    replaced))

(define (number-note note/no)
  (define no (car note/no))
  (define note (cdr note/no))
  (define cmp-1? (member "cmp-1" (string-split (attr-ref note 'class))))
  (define cmp-2? (member "cmp-2" (string-split (attr-ref note 'class))))
  (define note-elements (get-elements note))
  (txexpr
   (get-tag note)
   (get-attrs note)
   (cons
    (txexpr
     'note-nb
     `((class ,(cond [cmp-1? "cmp-1"] [cmp-2? "cmp-2"] [else ""])))
     (list (number->string no)))
    note-elements)))

;; edit both the comparison (inserting note numbers in margin)
;; and the notes themselves (inserting numbers as elements)
(define (process-cmp/notes group)
  (define cmp (car group))
  (define notes/no (enumerate (cdr group) 1))
  (define inserted (foldl insert-note cmp notes/no))
  (define numbered (map number-note notes/no))
  (cons inserted numbered))

(define (codenote #:line line . elements)
  (txexpr
   'div
   `((class "code-note-container") (id ,(symbol->string (gensym 'note-nb-))) (line ,(number->string line)))
   (list (txexpr 'aside '() elements))))

(define (cmpnote/2 #:line line . elements)
;  (txexpr 'div `((class "code-note-container cmp-2") (id ,(symbol->string (gensym 'note-nb-))) (line ,(number->string line)))
;          (list (txexpr 'aside '((class "cmp-n cmp-2")) elements)))
  (txexpr 'dummy empty empty))

(define (cmpnote/1 #:line line . elements)
;  (txexpr 'div `((class "code-note-container cmp-1") (id ,(symbol->string (gensym 'note-nb-))) (line ,(number->string line)))
;          (list (txexpr 'aside '((class "cmp-n cmp-1")) elements)))
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

(define (code-trowify line/no new left?)
  (define op (if left? identity reverse))
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
   (op
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
      (map preserve (cdr line/no)))))))
(define (code-tbodify lines new left? num-lines)
  (txexpr
   'tbody
   '()
   (map
    (λ (l) (code-trowify l new left?))
    (enumerate (extend lines num-lines) 1))))
(define (code-theadify fn left?)
  (txexpr
   'thead
   `()
   (list (txexpr
          'tr
          '()
          (list
           (if left?
               (txexpr
                'td
                `((class "code-note-margin")
                  (id ,(symbol->string (gensym 'margin-cell-))))
                (list ""))
               "")
           (txexpr
            'td
            '()
            (list fn))
           (txexpr
            'td
            '()
            (list
             (txexpr
              'i
              '((class "fa fa-files-o")
                (aria-hidden "true"))
              empty)))
           (if (not left?)
               (txexpr
                'td
                `((class "code-note-margin")
                  (id ,(symbol->string (gensym 'margin-cell-))))
                (list ""))
               ""))))))
(define (code-tablify lines lang fn new left? num-lines)
  (txexpr
   'table
   `((class "code-table"))
   (if fn
       (list (code-theadify fn left?) (code-tbodify lines new left? num-lines))
       (list (code-tbodify lines new left? num-lines)))))

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

  (txexpr 'dummy empty empty)

  ; TODO replace this with highlight
;  (define pyg1 (includecode f1 #:lang lang1 #:filename (or fn1 f1)))
;  (define pyg2 (includecode f2 #:lang lang2 #:filename (or fn2 f2)))
;  
;  (define pre1 (cadr (findf*-txexpr pyg1 (λ (tx) (and (txexpr? tx) (eq? (get-tag tx) 'pre))))))
;  (define pre2 (cadr (findf*-txexpr pyg2 (λ (tx) (and (txexpr? tx) (eq? (get-tag tx) 'pre))))))
;
;  (define pre1-lines (reverse (drop (foldl break-code-lines '(()) (get-elements pre1)) 1)))
;  (define pre2-lines (reverse (drop (foldl break-code-lines '(()) (get-elements pre2)) 1)))
;
;  (define num-lines (max (length pre1-lines) (length pre2-lines)))
;  
;  (define table1 (code-tablify pre1-lines lang1 fn1 new/1 #t num-lines))
;  (define table2 (code-tablify pre2-lines lang2 fn2 new/2 #f num-lines))
;  
;  (txexpr 'div '((class "cmp")) (list table1 table2))
  )

(define (codecmp-generator/notes txexprs)
  ;; this works by grouping a comparison (or standalone bit of code) with the following elements
  ;; those are assumed to be notes
  (define groups
    (reverse
     (foldl
      (λ (e acc)
        (let ([class-attr-values (string-split (attr-ref e 'class ""))])
          (if (or
               (member "cmp" class-attr-values)
               (member "annotated-code" class-attr-values))
              (cons (list e) acc)
              (cons (append (car acc) (list e)) (cdr acc)))))
      empty
      txexprs)))
  (define processed-groups (map process-cmp/notes groups))
  (generator
   ()
   (for ([grp processed-groups])
     (for ([grp-elem grp])
       (yield grp-elem)))))

(define (postprocess-codecmp-notes tx)
  (if (eq? (get-tag tx) 'root)
      (let*-values
          ([(temp clippings)
            (splitf-txexpr
             tx
             (λ (e)
               (and (txexpr? e)
                    (let ([class-attr-values (string-split (attr-ref e 'class ""))])
                      (or
                       (member "annotated-code" class-attr-values)
                       (member "cmp" class-attr-values)
                       (member "code-note-container" class-attr-values)))))
             (λ (e) (txexpr 'placeholder '() '())))]
           [(clippings-generator)
            (codecmp-generator/notes clippings)])
        (let-values ([(replaced _)
                      (splitf-txexpr
                       temp
                       (λ (e)
                         (and (txexpr? e)
                              (eq? (get-tag e) 'placeholder)))
                       (λ (_) (clippings-generator)))])
          replaced))
      tx))

(define (includecode path #:lang [lang "racket"])
  (highlight
   lang
   (file->string path #:mode 'text)))

(define (newincludecode f #:lang [lang "racket"] #:fn [fn #f] #:new [new empty])
  (define pyg
    (highlight
     lang
     (file->string f #:mode 'text)))
  (define pre (cadr (findf*-txexpr pyg (λ (tx) (and (txexpr? tx) (eq? (get-tag tx) 'pre))))))
  (define pre-lines (reverse (drop (foldl break-code-lines '(()) (get-elements pre)) 1)))
  (define num-lines (length pre-lines))
  (define table (code-tablify pre-lines lang fn new #t num-lines))
  (txexpr 'div '((class "annotated-code")) (list table)))

(provide (all-defined-out))
