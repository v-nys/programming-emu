#lang racket
(require pict pict/color pict/tree-layout)
(define (underline p) p)
(naive-layered
 (tree-layout #:pict (text "likes(athena,Something)")
              (tree-layout #:pict (text "□"))
              (tree-layout #:pict (text "□"))
              (tree-layout #:pict (ht-append
                                   (underline
                                    (text "part(Z,Something)"))
                                   (text " ∧ likes(athena,Z)"))
                           (tree-layout #:pict (text "likes(athena,primes)")
                                        (tree-layout #:pict (red (text "X"))))
                           (tree-layout #:pict (text "likes(athena,triangles)")
                                        (tree-layout #:pict (red (text "X"))))
                           (tree-layout #:pict (text "likes(athena,logic)")
                                        (tree-layout #:pict (text "□"))))))