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
◊(map (compose1 (curry format "<li>~a</li>") (curry select 'h1)) (siblings here))
</ul>
</body>
</html>
