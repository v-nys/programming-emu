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
◊;{Trying to reorganize according to the approach in https://thomasbyttebier.be/blog/less-css-mess

simple guidelines
=================

- define Racket variables before the first place where they are used, but group constants of the same kind (e.g. colors)
- always use hyphens instead of underscores or camel casing
- alphabetic order is always the tie-breaker when other criteria are exhausted
- 2 spaces for indentation between {} --- if indentation comes up anywhere else in CSS code
- comments are always on separate lines
- comments are at most 80 columns
- name values using Pollen as a preprocessor wherever they have any meaning
- put multiple selectors on multiple lines
- use shorthand hex values
- always prefer double quotes
- quote attribute values in selectors
- avoid specifying units for 0-values
- for slight variations in multiple related declarations,
breaking the aforementioned whitespace rules to improve readability is okay
- for comma-separated values, line breaking to improve readability is okay
- avoid excessive selector nesting - ID's, custom elements, etc. are clear
- namespace CSS

itcss
=====
- generic layer
- base styles (unclassed elements)
- objects layer (repeating visual patterns that can go in a *reusable* independent snippet)
- components layer (specific visual elements, should be possible to copy-paste anywhere on the site)
- trumps (essentially like inline CSS, put together in thematically ordered files (e.g. w.r.t. alignment, visibility,...))

namespaced CSS
==============
prefixes g, b, o, c and t

BEM
===
.block for complete objects/components, .block__element for descendants, .block--modifier for states

documentation for front-end
===========================
TODO: put in the book itself or use Scribble
}

◊(require (only-in racket/string string-join))
◊;; i.e. percentage of page to left and right (combined) of content which is blank
◊(define content-margin-percentage 32)
◊;; i.e. percentage of page immediately to left and right (combined) of todo notes which is blank
◊(define todo-margin-percentage 2)
◊(define body-text-color "#333")
◊(require "fonts.rkt" "palette.rkt")

◊(define cmp-aqua aqua)
◊(define cmp-aqua-transparent "rgba(0,144,144,0.2)")
◊(define cmp-orange "#ff7700")
◊(define cmp-orange-transparent "rgba(244,167,66,0.2)")

#content {
margin-left: auto;
margin-right: auto;
width: ◊(- 100 content-margin-percentage)%;
}

#pageturn-left {
left: 0;
}

#pageturn-right {
right: 0;
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
font-family: ◊code-font-family;
line-height: 1.5;
width: 50%;
}

.code-note-margin.cmp-1 {
text-align: right;
}

.cmp-2 a {
color: ◊cmp-orange;
}

.cmp {
width: calc(100% + 200px);
position: relative;
right: 100px;
}

.code-note-margin {
min-width: 100px;
padding: 0px;
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

aside.cmp-n {
display: inline-block;
vertical-align: middle;
margin-bottom: 0px;
/* own width = entire div, without note width, note padding, own border, own padding*/
width: calc(100% - (5.5em + 2px) - 8px - 2px - 8px);
padding-top: .25em;
padding-bottom: .25em;
margin: .5em 0 .5em 0;
}

aside.cmp-1 {
border-left: 2px solid ◊cmp-aqua;
background-color: ◊cmp-aqua-transparent;
}

aside.cmp-2 {
border-left: 2px solid ◊cmp-orange;
background-color: ◊cmp-orange-transparent;
}

note-nb.cmp-1 {
color: ◊cmp-aqua;
}

note-nb.cmp-2 {
color: ◊cmp-orange;
}

.cmp-1 .added-line {
border-left: 1px dashed ◊cmp-aqua;
border-right: 1px dashed ◊cmp-aqua;
}

.cmp-2 .added-line {
border-left: 1px dashed ◊cmp-orange;
border-right: 1px dashed ◊cmp-orange;
}

.code {
font-family: ◊code-font-family;
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
font-family: ◊code-font-family;
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
font-family: ◊code-font-family;
font-size: 11px;
display: inline-block;
}

.active-number-circle.right-number-circle {
background: ◊cmp-orange;
}

.output {
font-family: ◊code-font-family;
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

aside {
padding-left: .5em;
background-color: ◊light-gray;
border-left: 2px solid gray;
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
