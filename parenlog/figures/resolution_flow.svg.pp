#lang pollen
◊(require file/convertible pict racket/math)
◊(define pict
   (vc-append
    (text "top")
    (hc-append
     (text "n" null 12 (/ pi 2))
     (arrow 10 (/ pi 2))
     (arrow 10 (- (/ pi 2)))
     (text "1" null 12 (- (/ pi 2))))
    (text "answer query")
    (hc-append
     (text "3,5,...,n-1" null 12 (/ pi 2))
     (arrow 10 (/ pi 2))
     (arrow 10 (- (/ pi 2)))
     (text "2,4,...n-2" null 12 (- (/ pi 2))))
    (text "apply rule")))
◊(bytes->string/utf-8 (convert pict 'svg-bytes))