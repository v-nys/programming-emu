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
◊(define codefont "Fira Mono")
◊(define code-line-height "1.25em")
◊(define code-pt-size "10pt")
◊(define forest-green "#009933")
◊(define fuchsia "#cc0066")
◊(define light-gray "#cccccc")
◊(define very-light-gray "#eeeeee")
◊(define mint-green "#00cc66")
◊(define orange "#ff6600")
◊(define white "#ffffff")
◊(define regular-link-color aqua)
◊(define cmp-aqua "#009999")
◊(define cmp-aqua-transparent "rgba(0,144,144,0.2)")
◊(define cmp-orange "orange")
◊(define cmp-orange-transparent "rgba(244,167,66,0.2)")

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

table.counterparts td:first-child {
border-right: 1px dashed;
padding-right: 1em;
}

table.counterparts td:last-child {
padding-left: 1em;
}

.cmp .code-table {
border-collapse: collapse;
display: inline-block;
font-family: ◊codefont;
line-height: 1.5;
width: 50%;
}

.cmp {
width: calc(100% + 200px);
position: relative;
right: 100px;
}

.comparative-line:nth-child(odd) .comparative-snippet{
background-color: ◊very-light-gray;
}

ul.toc li {
list-style-type: none;
}

td span.code {
background-color: ◊white;
}

.comparative-snippet:first-child {
padding-left: 0;
border-right: 1em solid white;
}

.pageturn:hover {
background-color: #eeeeee33;
}

.comparative-snippet pre {
margin-bottom: 0;
margin-top: 0;
}

.toc li {
font-family: 'Fira Sans';
font-variant: small-caps;
list-style-position: inside;
margin: 0;
padding: 0;
}

a.glossaryref {
border-bottom: thin dotted ◊aqua;
color: ◊body-text-color;
}

aside.cmp-1 {
display: inline-block;
border-left: 2px solid ◊cmp-aqua;
background-color: ◊cmp-aqua-transparent;
vertical-align: middle;
margin-bottom: 0px;
}

aside.cmp-2 {
display: inline-block;
border-left: 2px solid ◊cmp-orange;
background-color: ◊cmp-orange-transparent;
vertical-align: middle;
margin-bottom: 0px;
}

note-nb.cmp-1 {
color: ◊cmp-aqua;
}

note-nb.cmp-2 {
color: ◊cmp-orange;
}

span.code {
background-color: ◊light-gray;
}

.aside {
position: absolute;
right: ◊(/ todo-margin-percentage 2)%;
width: ◊(- (/ content-margin-percentage 2) todo-margin-percentage)%;
}

.code {
font-family: ◊codefont;
}

.code-note-container {
width: calc(100% + 6em);
position: relative;
right: 1em;
}

.comparative-line {
display: table-row;
width: 100%;
}

.comparative-listing {
display: table;
}

.comparative-listing-margin {
display: table-cell;
padding-left: .5em;
}

.comparative-snippet {
display: table-cell;
font-family: ◊codefont;
font-size: ◊code-pt-size;
height: ◊code-line-height;
}

.exercise {
font-weight: bold;
}

.glossarytermlabel {
font-weight: bold;
}

.linenos {
display: none;
}

.output {
font-family: ◊codefont;
color: ◊fuchsia;
}

.pageturn {
position: fixed;
height: 100%;
top: 0%;
width: ◊(/ content-margin-percentage 4)%;
}

.toc {
padding: 0;
}

.todonote {
position: absolute;
right: ◊(/ todo-margin-percentage 2)%;
width: ◊(- (/ content-margin-percentage 2) todo-margin-percentage)%;
}

.warning {
font-weight: bold;
}

.work {
font-style: italic;
}

.ws {
white-space: pre;
}

◊;; selectors are organized by points first, then alphabetically
a {
color: ◊regular-link-color;
text-decoration: none;
}

aside {
padding-left: .5em;
}

body {
font-family: 'Fira Sans';
color: ◊body-text-color;
}

h1, h2, h3, h4, h5, h6 {
font-family: 'Fira Sans';
}

note-nb {
display: inline;
vertical-align: middle;
height: 100%;
padding-right: .5em;
}

p {
line-height: 150%;
}

pre {
border-left: 1px dashed;
font-size: ◊code-pt-size;
padding-left: 1em;
}
