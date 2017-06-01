#lang pollen
◊(require file/convertible pict pict/color pict/tree-layout)
◊(define pict
   (naive-layered
   (tree-layout #:pict (text "likes(athena,X)")
                (tree-layout #:pict (vc-append (text "□") (text "(X = battle)")))
                (tree-layout #:pict (vc-append (text "□") (text "(X = logic)")))
                (tree-layout #:pict (ht-append
                                     (text "part(Z,athena)")
                                     (text " ∧ likes(athena,Z)"))
                             (tree-layout #:pict (red (text "X")))))))
◊(bytes->string/utf-8 (convert pict 'svg-bytes))