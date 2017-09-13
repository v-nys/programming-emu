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

<!-- libraries -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css">
<!-- itcss generic layer (controlling general rendering by browser) -->
<link rel="stylesheet" type="text/css" href="/static/generic.normalize.css" />
<link rel="stylesheet" type="text/css" href="/static/generic.font-specifications.css" />
<!-- itcss base layer (unclassed elements) -->
<!-- could still add more, like lists, etc. -->
<link rel="stylesheet" type="text/css" href="/static/base.code.css" />
<link rel="stylesheet" type="text/css" href="/static/base.inputs.css" />
<link rel="stylesheet" type="text/css" href="/static/base.links.css" />
<link rel="stylesheet" type="text/css" href="/static/base.lists.css" />
<link rel="stylesheet" type="text/css" href="/static/base.non-structural-text-elements.css" />
<link rel="stylesheet" type="text/css" href="/static/base.textual-structure.css" />
<!-- components layer -->
<link rel="stylesheet" type="text/css" href="/static/header6.css" />
<link rel="stylesheet" type="text/css" href="/static/components.pagination.css" />
<!-- wins layer (very specific and breaks existing rules) -->
<link rel="stylesheet" type="text/css" href="/static/wins.image-placement.css" />
<link rel="stylesheet" type="text/css" href="/static/wins.show-hide.css" />
<!-- stuff I still need to port -->
<link rel="stylesheet" type="text/css" href="/static/common.css" />
<link href="//fonts.googleapis.com/css?family=Fira+Mono|Fira+Sans" rel="stylesheet">
<link href="https://fonts.googleapis.com/css?family=Gentium+Basic" rel="stylesheet"> 
<script src="/static/jquery.js"></script>
<script src="/static/clipboard.min.js"></script>
<script src="/static/copy-to-clipboard.js"></script>
<script src="/static/hide-listing-notes.js"></script>
<script src="/static/highlight-pageturns.js"></script>
<script src="/static/hide-js-warning.js"></script>

◊when/splice[(select 'headappendix doc)]{◊(my->html (select* 'headappendix doc))}
</head>
<body>
◊when/splice[(previous here)]{<a class="c-pageturn c-pageturn-left" href="/◊(previous here)"><img id="pageturn-left-img" class="c-pageturn-img" src="/images/turn-left-light.svg"></a>}
<content>
<p class="u-screen-size-p"><warning class="u-screen-size-p__warning">The current version of this book is not optimized for your screen resolution and/or zoom level. You may experience graphical glitches.</warning></p>
<p id="js-warning-p" class="u-js-p"><warning class="u-js-p__warning">It does not look like JavaScript is enabled on your system. While you can read the book without JavaScript, there are a lot of quality of life improvements that rely on Javascript, so I recommend turning it on.</warning></p>

◊(->html (navbar here))

◊(my->html (select* 'unmoved doc))
</content>
◊when/splice[(next here)]{<a class="c-pageturn c-pageturn-right" href="/◊(next here)"><img id="pageturn-right-img" class="c-pageturn-img c-pageturn-right__img" src="/images/turn-left-light.svg"></a>}
</body>
</html>
