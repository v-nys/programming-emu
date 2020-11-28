#lang racket
(require pict graphviz)
(define drawing
  (inset
   (digraph->pict
    (make-digraph
     `(("Top" #:label "likes(athena,X)" #:shape "none")
       ("Outcome1" #:label "□" #:shape "none")
       ("Outcome2" #:label "□" #:shape "none")
       ("Intermediate1" #:label "part(Z,athena),likes(athena,Z)" #:shape "none")
       ("Failure1" #:label "✗" #:shape "none")
       (edge ("Top" "Outcome1") #:label "X = battle")
       (edge ("Top" "Outcome2") #:label "X = logic")
       (edge ("Top" "Intermediate1") #:label "X = athena")
       (edge ("Intermediate1" "Failure1")))))
   10 0 -13 0))
(provide drawing)