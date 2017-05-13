<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>◊(select 'h2 doc)</title>
<link rel="stylesheet" type="text/css" href="/common.css" />
</head>
<body>
◊when/splice[(previous here)]{<a class="pageturn" id="pageturn-left" href="/◊(previous here)"></a>}
<div id="content">
<a id="booktitle" href="/index.html"><h1>Programming Emu</h1></a>
◊(->html doc #:splice? #t)
</div>
◊when/splice[(next here)]{<a class="pageturn" id="pageturn-right" href="/◊(next here)"></a>}
</body>
</html>
