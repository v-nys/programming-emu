◊(local-require (only-in racket/function curry))
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>◊(select 'h1 doc)</title>
</head>
<body>
◊(->html doc)
<ul>
◊(map (compose (curry format "<a href='~a'><li>~a</li></a>") (λ (e) (values e (select 'h1 e)))) (siblings here))
</ul>
</body>
</html>