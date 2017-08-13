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
◊(define cmp-orange "#ff7a00")
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

.code-table.cmp-1 tbody tr:nth-child(odd) td:nth-child(2),
.code-table.cmp-2 tbody tr:nth-child(odd) td:nth-child(1){
background-color: ◊very-light-gray;
}

.code-table.cmp-1 thead td:nth-child(2),
.code-table.cmp-1 thead td:nth-child(3){
background-color: ◊cmp-aqua-transparent;
color: ◊cmp-aqua;
}

.code-table.cmp-2 thead td:nth-child(1),
.code-table.cmp-2 thead td:nth-child(2){
background-color: ◊cmp-orange-transparent;
color: ◊cmp-orange;
}

.cmp-1 tr:first-child .listing-line-content{
border-top: 1px solid ◊cmp-aqua;
}

.cmp-1 tr:last-child .listing-line-content {
border-bottom: 1px solid ◊cmp-aqua;
}

.cmp-2 tr:first-child .listing-line-content{
border-top: 1px solid ◊cmp-orange;
}

.cmp-2 tr:last-child .listing-line-content {
border-bottom: 1px solid ◊cmp-orange;
}

.cmp-2 a {
color: ◊cmp-orange;
}

.code-note-margin {
min-width: 100px;
padding: 0px;
}

.code-note-margin.cmp-1 {
text-align: right;
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

.code-table td {
height: 1.5em;
}

.comparative-snippet:first-child {
padding-left: 0;
border-right: 1em solid white;
}

.listing-line-content {
width: 100%;
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
/* own width = entire div, without note width, note padding, own border, own padding*/
width: calc(100% - (5.5em + 2px) - 8px - 2px - 8px);
padding-top: .25em;
padding-bottom: .25em;
margin: .5em 0 .5em 0;
}

aside.cmp-2 {
display: inline-block;
border-left: 2px solid ◊cmp-orange;
background-color: ◊cmp-orange-transparent;
vertical-align: middle;
margin-bottom: 0px;
/* own width = entire div, without note width, note padding, own border, own padding*/
width: calc(100% - (5.5em + 2px) - 8px - 2px - 8px);
padding-top: .25em;
padding-bottom: .25em;
margin: .5em 0 .5em 0;
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

.cmp-1 .added-line {
border-left: 1px dashed ◊cmp-aqua;
border-right: 1px dashed ◊cmp-aqua;
}

.cmp-2 .added-line {
border-left: 1px dashed ◊cmp-orange;
border-right: 1px dashed ◊cmp-orange;
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
right: calc(6em + 2px);
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

.cmp-1 .first-added-line {
border-top: 1px dashed ◊cmp-aqua;
}

.cmp-2 .first-added-line {
border-top: 1px dashed ◊cmp-orange;
}

.glossarytermlabel {
font-weight: bold;
}

.inactive-number-circle {
background: gray;
}

.cmp-1 .last-added-line {
border-bottom: 1px dashed ◊cmp-aqua;
}

.cmp-2 .last-added-line {
border-bottom: 1px dashed ◊cmp-orange;
}

.active-number-circle.left-number-circle {
background: ◊cmp-aqua;
}

.linenos {
display: none;
}

.number-circle {
border-radius: 50%;
width: 15px;
height: 15px;
padding: 2px;
border: 1px solid white;
color: white;
text-align: center;
font-family: ◊codefont;
font-size: 11px;
display: inline-block;
}

.active-number-circle.right-number-circle {
background: ◊cmp-orange;
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
background-color: ◊light-gray;
border-left: 2px solid gray;
}

body {
font-family: 'Fira Sans';
color: ◊body-text-color;
}

h1, h2, h3, h4, h5, h6 {
font-family: 'Fira Sans';
}

note-nb {
display: inline-block;
vertical-align: middle;
height: 100%;
padding-right: .5em;
width: calc(5.5em + 2px);
text-align: right;
}

p {
line-height: 150%;
}

pre {
border-left: 1px dashed;
font-size: ◊code-pt-size;
padding-left: 1em;
}
