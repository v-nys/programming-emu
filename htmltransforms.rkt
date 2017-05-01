#lang racket
(require racket/match)

(define (tocentry->li e)
  (match e
    [(list 'tocentry fn title)
     `(li (a ((href ,(symbol->string fn))) ,title))]
    [_ e]))
(provide tocentry->li)