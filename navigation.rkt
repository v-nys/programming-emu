#lang racket
(require pollen/core
         pollen/pagetree
         pollen/setup
         sugar/coerce
         txexpr)

(define (ptree->html-list ptree ol?) (ptree->html-list/aux ptree ol? select))
(define (ptree->html-list/aux ptree ol? select) ; for easy mocking
  (txexpr
   (if ol? 'ol 'ul)
   (if (eq? (car ptree) 'pagetree-root) '((class "toc")) '())
   (foldr
    (λ (t acc)
      (if (symbol? t)
          (cons `(li (a ((href ,(string-append "/" (symbol->string t)))) ,(let ([h2 (select 'h2 t)]) (or h2 t)))) acc)
          (cons `(li (a ((href ,(string-append "/" (symbol->string (car t))))) ,(let ([h2 (select 'h2 (car t))]) (or h2 (car t))))) (cons `(li ,(ptree->html-list/aux t ol? select)) acc))))
    empty
    (cdr ptree))))
(module+ test
  (let ([select (λ (el t) (if (symbol? t) t (car t)))])
    (check-equal?
     (ptree->html-list/aux '(pagetree-root (mama (son grandson1 grandson2) (daughter granddaughter1 granddaughter2)) uncle) #t select)
     '(ol ((class "toc"))
          (li (a ((href "mama")) mama))
          (li (ol
               (li (a ((href "son")) son))
               (li (ol (li (a ((href "grandson1")) grandson1)) (li (a ((href "grandson2")) grandson2))))
               (li (a ((href "daughter")) daughter))
               (li (ol (li (a ((href "granddaughter1")) granddaughter1)) (li (a ((href "granddaughter2")) granddaughter2))))))
          (li (a ((href "uncle")) uncle))))))
(provide ptree->html-list)

(define (prune-tree/depth se depth #:root [subtree-root 'pagetree-root])
  (cond
    [(not (list? se)) se]
    [(equal? depth 1)
     (cons subtree-root (children subtree-root se))]
    [(> depth 1)
     (cons
      subtree-root
      (map
       (λ (pt r) (prune-tree/depth pt (- depth 1) #:root r))
       (children/nested subtree-root se)
       (children subtree-root se)))]))
(module+ test
  (check-equal?
   (prune-tree/depth '(pagetree-root (mama son daughter) uncle) 1)
   '(pagetree-root mama uncle))
  (check-equal?
   (prune-tree/depth '(pagetree-root (mama (son grandson1 grandson2) (daughter granddaughter1 granddaughter2)) uncle) 1)
   '(pagetree-root mama uncle))
  (check-equal?
   (prune-tree/depth '(pagetree-root (mama (son grandson1 grandson2) (daughter granddaughter1 granddaughter2)) uncle) 2)
   '(pagetree-root (mama son daughter) uncle)))
(provide prune-tree/depth)

(define (children/nested p pt-or-path)
  (and pt-or-path p
       (let ([pagenode (->pagenode p)]
             [pt (get-pagetree pt-or-path)])
         (if (eq? pagenode (car pt))
             (cdr pt)
             (ormap (λ(x) (children/nested pagenode x)) (filter list? pt))))))
(module+ test
  (require rackunit)
  (check-equal?
   (children/nested
    'mama
    '(pagetree-root (mama (son grandson1 grandson2) (daughter granddaughter1 granddaughter2)) uncle))
   '((son grandson1 grandson2) (daughter granddaughter1 granddaughter2))))

(define (splice-out-nodes se clips)
  (define (aux se clips)
    (cond [(and (not (list? se)) (memq se clips)) (cons #f #f)]
          [(not (list? se)) (cons se #f)]
          [else
           (let* ([mapped-children
                   (filter car (for/list ([e (cdr se)]) (aux e clips)))]
                  [shifted-children
                   (foldr
                    (λ (p acc) (if (cdr p) (append (car p) acc) (cons (car p) acc)))
                    empty
                    mapped-children)]
                  [new-se (cons (car se) shifted-children)])
             (if (not (memq (car se) clips))
                 (cons new-se #f)
                 (cons shifted-children #t)))]))
  (car (aux se clips)))
(module+ test
  (check-equal?
   (splice-out-nodes '(pagetree-root (mama (son grandson1 grandson2) (daughter granddaughter1 granddaughter2)) uncle) '(daughter grandson2))
   '(pagetree-root (mama (son grandson1) granddaughter1 granddaughter2) uncle))
  (check-equal?
   (splice-out-nodes '(pagetree-root (mama (son grandson1 grandson2) (daughter granddaughter1 granddaughter2)) uncle) '(daughter grandson2 granddaughter1))
   '(pagetree-root (mama (son grandson1) granddaughter2) uncle)))
(provide splice-out-nodes)