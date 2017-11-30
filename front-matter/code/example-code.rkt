#lang racket
(let ([displayed-thing-1 "Hello"]
      [displayed-thing-2 "World!"])
  (displayln
   (string-join
    `(,displayed-thing-1 ,displayed-thing-2))))