#lang pollen
◊;; i.e. percentage of page to left and right (combined) of content which is blank
◊(define content-margin-percentage 32)
◊;; i.e. percentage of page immediately to left and right (combined) of todo notes which is blank
◊(define todo-margin-percentage 2)
◊(define body-text-color "#333333")
◊(define fuchsia "#cc0066")
◊(define mint-green "#00cc66")
◊(define orange "#ff6600")
◊(define regular-link-color mint-green)
◊(require (only-in racket/string string-join))

◊(define fontfacestr #<<HERE
@font-face {
font-family: ~a;
src: url(/static/~a.woff);
}
HERE
)
◊(string-join
  (for/list ([font '(fanwood junction lindenhill prociono leaguespartan raleway)])
    (format fontfacestr (capitalize (symbol->string font)) font))
  "\n")

◊;; selectors are organized by points first, then alphabetically
a {
color: ◊regular-link-color;
text-decoration: none;
}

body {
font-family: Fanwood;
color: ◊body-text-color;
}

h1, h2, h3, h4, h5, h6 {
font-family: Leaguespartan;
}

p {
line-height: 150%;
}

.pageturn {
position: fixed;
height: 100%;
top: 0%;
width: ◊(/ content-margin-percentage 2)%;
}

.pageturn:hover {
background-color: #eeeeee33;
}

.warning {
font-weight: bold;
}

.work {
font-style: italic;
}

.toc {
padding: 0;
}

.todonote {
position: absolute;
right: ◊(/ todo-margin-percentage 2)%;
width: ◊(- (/ content-margin-percentage 2) todo-margin-percentage)%;
}

.toc li {
font-family: Junction;
font-variant: small-caps;
list-style-type: none;
margin: 0;
padding: 0;
}

.toc li a {
}

#booktitle {
color: ◊body-text-color;
}

#content {
margin-left: auto;
margin-right: auto;
width: ◊(- 100 content-margin-percentage)%;
}

#pageturn-left {
left: 0px;
}

#pageturn-right {
right: 0px;
}
