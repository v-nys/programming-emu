#lang pollen
◊(require file/convertible pict racket/math)
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
   (pin-arrow-line
    5
    (pin-arrow-line
     5
     (pin-arrow-line
      5 blocks
      apply-rule-pict ct-find
      query-pict rc-find
      #:start-angle (/ pi 2)
      #:end-angle pi)
     empty?-pict cb-find
     apply-rule-pict ct-find
     #:label (text "no"))
    empty?-pict cb-find
    answer-pict ct-find
    #:label (text "yes")))
◊(bytes->string/utf-8 (convert lines 'svg-bytes))