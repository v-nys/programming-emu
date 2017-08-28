#lang pollen
◊(require file/convertible pict pict/color pict/tree-layout)
◊(define pict
   (naive-layered
   (tree-layout #:pict (text "likes(athena,Something)")
                (tree-layout #:pict (vc-append (text "□") (text "(Something = battle)")))
                (tree-layout #:pict (vc-append (text "□") (text "(Something = logic)")))
                (tree-layout #:pict (ht-append
                                     (text "part(Z,Something)")
                                     (text " ∧ likes(athena,Z)"))
                             (tree-layout #:pict (vc-append
                                                  (text "likes(athena,primes)")
                                                  (text "(Something = math; Z = primes)"))
                                          (tree-layout #:pict (red (text "X"))))
                             (tree-layout #:pict (vc-append
                                                  (text "likes(athena,triangles)")
                                                  (text "(Something = math; Z = triangles)"))
                                          (tree-layout #:pict (red (text "X"))))
                             (tree-layout #:pict (vc-append
                                                  (text "likes(athena,logic)")
                                                  (text "(Something = math; Z = logic)"))
                                          (tree-layout #:pict (text "□")))))))
◊(bytes->string/utf-8 (convert pict 'svg-bytes))