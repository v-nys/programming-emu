<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>◊(select 'h1 doc)</title>
</head>
<body>
◊(->html doc #:splice? #t)
◊(local-require "htmltransforms.rkt")
◊(when (select 'toc doc)
   (format "<ul>~a</ul>" (->html (map tocentry->li (select* 'toc doc)))))
</body>
</html>
