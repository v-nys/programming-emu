#lang pollen
◊(require file/convertible pict racket/math graphviz)
◊(define query-pict
   (text "answer query"))
◊(define empty?-pict
   (text "empty?"))
◊(define apply-rule-pict
   (text "apply rule"))
◊(define answer-pict
   (text "yield answer"))
◊(define blocks
   (vc-append
    query-pict
    (vline 1 20)
    (vc-append 20
               empty?-pict
               (hc-append 60
                          answer-pict
                          apply-rule-pict))))
◊(define lines
   (inset
   (digraph->pict
    (make-digraph
     `(("answer" #:label "answer query" #:shape "none")
       ("empty" #:label "empty?" #:shape "none")
       ("yield" #:label "yield answer" #:shape "none")
       ("apply" #:label "apply rule" #:shape "none")

       (edge ("answer" "empty"))
       (edge ("empty" "yield") #:label "yes")
       (edge ("empty" "apply") #:label "no")
       (edge ("apply" "answer")))))
   0 0 0 0))
◊(bytes->string/utf-8 (convert lines 'svg-bytes))