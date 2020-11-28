#lang racket
(require pict graphviz)
(define drawing
  (inset
   (digraph->pict
    (make-digraph
     `(("Top" #:label "likes(athena,Something" #:shape "none")
       ("Outcome1" #:label "□" #:shape "none")
       ("Outcome2" #:label "□" #:shape "none")
       ("Intermediate1" #:label "part(Z,math),likes(athena,Z)" #:shape "none")
       ("DeadEnd1" #:label "likes(athena,primes)" #:shape "none")
       ("DeadEnd2" #:label "likes(athena,triangles)" #:shape "none")
       ("Intermediate2" #:label "likes(athena,logic)" #:shape "none")
       ("Outcome3" #:label "□" #:shape "none")
       ; krijg dit niet rood...
       ("Failure1" #:label "✗" #:shape "none")
       ("Failure2" #:label "✗" #:shape "none")
       (edge ("Top" "Outcome1") #:label "Something = battle")
       (edge ("Top" "Outcome2") #:label "Something = logic")
       (edge ("Top" "Intermediate1") #:label "Something = math")
       (edge ("Intermediate1" "DeadEnd1"))
       (edge ("Intermediate1" "DeadEnd2"))
       (edge ("Intermediate1" "Intermediate2"))
       (edge ("Intermediate2" "Outcome3"))
       (edge ("DeadEnd1" "Failure1"))
       (edge ("DeadEnd2" "Failure2"))
       )))
   40 0 -13 0))
(provide drawing)