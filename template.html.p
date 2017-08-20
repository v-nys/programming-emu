◊;{MIT License

Copyright (c) 2017 Vincent Nys

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.}
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>◊(select 'h2 doc)</title>
<!-- itcss generic layer (controlling general rendering by browser) -->
<link rel="stylesheet" type="text/css" href="/static/generic.normalize.css" />
<!-- itcss base layer (unclassed elements) -->
<!-- could still add more, like lists, etc. -->
<link rel="stylesheet" type="text/css" href="/static/base.links.css" />
<link rel="stylesheet" type="text/css" href="/static/base.inputs.css" />
<link rel="stylesheet" type="text/css" href="/static/base.non-structural-text-elements.css" />
<link rel="stylesheet" type="text/css" href="/static/base.textual-structure.css" />
<!-- objects layer (could be generic) -->
<link rel="stylesheet" type="text/css" href="/static/objects.breadcrumbs.css" />
<link rel="stylesheet" type="text/css" href="/static/objects.codeblocks.css" />
<!-- components layer (very specific to Programming Emu) -->
<!-- wins layer (very specific and breaks existing rules) -->
<!-- only have one file for now because there shouldn't be too many exceptions -->
<link rel="stylesheet" type="text/css" href="/static/wins.css" />
<!-- stuff I still need to port -->
<link rel="stylesheet" type="text/css" href="/static/common.css" />
<link href="//fonts.googleapis.com/css?family=Fira+Mono|Fira+Sans" rel="stylesheet">

<script src="/static/jquery.js"></script>
<script src="/static/hide-listing-notes.js"></script>
◊when/splice[(select 'headappendix doc)]{◊(my->html (select* 'headappendix doc))}
</head>
<body>
◊when/splice[(previous here)]{<a class="pageturn" id="pageturn-left" href="/◊(previous here)"></a>}
<content>
  <nav id="header6">
    <a href="#" style="color: #333333"><i class="fa fa-home"></i></a> »
    <a href="#">Projects</a> »
    <a href="#">ProjectName</a> »
    <a href="#">Section</a></nav>
◊(my->html (select* 'unmoved doc))
</content>
◊when/splice[(next here)]{<a class="pageturn" id="pageturn-right" href="/◊(next here)"></a>}
</body>
</html>
