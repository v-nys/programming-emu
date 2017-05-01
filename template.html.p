◊(local-require txexpr
                "htmltransforms.rkt")
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>◊(select 'h1 doc)</title>
</head>
<body>
◊(define-values (no-toc tocs)
   (splitf-txexpr doc (λ (e) (and (txexpr? e) (equal? 'toc (get-tag e))))))
◊(->html no-toc #:splice? #t)
◊(when (not (null? tocs))
   (map (λ (toc) (format "<ul>~a</ul>" (->html (map tocentry->li (get-elements toc))))) tocs))
</body>
</html>
