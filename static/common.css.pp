#lang pollen
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
◊(require (only-in racket/string string-join))
◊;; i.e. percentage of page to left and right (combined) of content which is blank
◊(define content-margin-percentage 32)
◊;; i.e. percentage of page immediately to left and right (combined) of todo notes which is blank
◊(define todo-margin-percentage 2)
◊(define body-text-color "#333333")
◊(define aqua "#009999")
◊(define forest-green "#009933")
◊(define fuchsia "#cc0066")
◊(define mint-green "#00cc66")
◊(define orange "#ff6600")
◊(define regular-link-color aqua)

◊;; organizing principle: by specificity, then alphabetically, with space followed by @#.:
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

ul.toc li {
list-style-type: none;
}

.pageturn:hover {
background-color: #eeeeee33;
}

.toc li {
font-family: 'Fira Sans';
font-variant: small-caps;
list-style-position: inside;
margin: 0;
padding: 0;
}

.aside {
position: absolute;
right: ◊(/ todo-margin-percentage 2)%;
width: ◊(- (/ content-margin-percentage 2) todo-margin-percentage)%;
}

.linenos {
display: none;
}

.pageturn {
position: fixed;
height: 100%;
top: 0%;
width: ◊(/ content-margin-percentage 2)%;
}

.toc {
padding: 0;
}

.warning {
font-weight: bold;
}

.work {
font-style: italic;
}

◊;; selectors are organized by points first, then alphabetically
a {
color: ◊regular-link-color;
text-decoration: none;
}

body {
font-family: 'Fira Sans';
color: ◊body-text-color;
}

h1, h2, h3, h4, h5, h6 {
font-family: 'Fira Sans';
}

p {
line-height: 150%;
}

pre {
font-family: 'Fira Mono';
}
