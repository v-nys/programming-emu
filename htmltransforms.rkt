#lang racket
(require racket/match)

(define (tocentry->li e)
  (match e
    [(list-rest 'tocentry fn title)
     (list 'li fn title)]
    [_ e]))
(provide tocentry->li)