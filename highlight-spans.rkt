#lang racket
(require txexpr sugar)
(define (replace-last lst elem)
  (append
   (drop-right lst 1)
   (list elem)))
(define (highlight-spans/line txt toggles #:start-highlighting? [start-highlighting? #f])
  (match-let ([(list char-counter end-highlighting? _ highlighted-line)
               (foldl
                (match-lambda**
                 [(next-char (list pos highlighting? past-whitespace? sexps))
                  (let ([new-highlighting? (xor (memq pos toggles) highlighting?)]
                        [new-past-whitespace?
                         (or past-whitespace? (not (char-whitespace? next-char)))])
                    (list
                     (add1 pos)
                     new-highlighting?
                     new-past-whitespace?
                     (if
                      (and new-highlighting? new-past-whitespace?)
                      (if
                       (and
                        (not (null? sexps))
                        (txexpr? (last sexps))) ; specifically: a span
                       (let ([final-span (last sexps)])
                         (replace-last
                          sexps
                          `(,(get-tag final-span)
                            ,(get-attrs final-span)
                            ,@(replace-last
                               (get-elements final-span)
                               (string-append
                                (last (get-elements final-span))
                                (->string next-char))))))
                       (append sexps (list `(span ((class "highlighted")) ,(->string next-char)))))
                      (if
                       (and
                        (not (null? sexps))
                        (string? (last sexps)))
                       (replace-last
                        sexps
                        (string-append
                         (last sexps)
                         (->string next-char)))
                       (append
                        sexps
                        (list (->string next-char)))))))])
                (list 0 start-highlighting? #f empty)
                (string->list (string-trim txt #:left? #f #:right? #t)))])
    (list end-highlighting? highlighted-line)))
(module+ test
  (require rackunit)
  (test-equal?
   "zonder leading / trailing WS en zonder toggles"
   (second
    (highlight-spans/line
     "dit is een regel tekst"
     empty))
   '("dit is een regel tekst"))
  (test-equal?
   "zonder leading / trailing WS en met één toggle"
   (second
    (highlight-spans/line
     "dit is een regel tekst"
     '(0)))
   `((span () "dit is een regel tekst")))
  (test-equal?
   "zonder leading / trailing WS en met twee toggles"
   (second
    (highlight-spans/line
     "dit is een regel tekst"
     '(0 4)))
   `((span () "dit ") "is een regel tekst"))
  (test-equal?
   "zonder leading / trailing WS en met drie toggles"
   (second
    (highlight-spans/line
     "dit is een regel tekst"
     '(0 4 5)))
   `((span () "dit ") "i" (span () "s een regel tekst")))
  (test-equal?
   "zonder leading / trailing WS en met vier toggles"
   (second
    (highlight-spans/line
     "dit is een regel tekst"
     '(0 4 5 7)))
   `((span () "dit ") "i" (span () "s ") "een regel tekst"))
  (test-equal?
   "met leading WS en met één toggle"
   (second
    (highlight-spans/line
     "   dit is een regel tekst"
     '(0)))
   `("   " (span () "dit is een regel tekst")))
  (test-equal?
   "met leading WS en met één toggle"
   (second
    (highlight-spans/line
     "   dit is een regel tekst"
     '(1 6)))
   `("   " (span () "dit") " is een regel tekst")))

(define (highlight-spans lines toggles)
  (define sorted-toggles
    (sort
     toggles
     (λ (e1 e2) (or (< (first e1) (first e2)) (and (= (first e1) (first e2)) (< (second e1) (second e2)))))))
  (reverse
   (third
    (foldl
     (match-lambda**
      [(line (list counter currently-highlighting? highlighted-lines))
       (match-let* ([line-toggles (map second (filter (λ (e) (eq? (first e) counter)) sorted-toggles))]
                    [(list eol-highlighting? highlighted-line)
                     (highlight-spans/line line line-toggles #:start-highlighting? currently-highlighting?)])
         (list (add1 counter) eol-highlighting? (cons highlighted-line highlighted-lines)))])
     (list 1 #f empty)
     lines))))
(provide highlight-spans)
(module+ test
  (test-equal?
   "zonder leading / trailing WS en met vier toggles"
   (highlight-spans
    '("dit is een regel tekst" "dit is de volgende regel")
    '((1 0) (1 4) (1 5) (2 7)))
   '(((span () "dit ") "i" (span () "s een regel tekst"))
     ((span () "dit is ") "de volgende regel"))))