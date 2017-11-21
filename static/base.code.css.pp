#lang pollen
◊(require "base-code-params.rkt" "base-textual-structure-params.rkt" "fonts.rkt" "palette.rkt")

◊(define cmp-aqua aqua)
◊(define cmp-aqua-transparent "rgba(0,144,144,0.2)")
◊(define cmp-orange "#ff7700")
◊(define cmp-orange-transparent "rgba(244,167,66,0.2)")

note-nb {
width: ◊note-nb-width;
padding-right: ◊note-nb-padding-right;
display: inline-block;
vertical-align: middle;
height: 100%;
text-align: right;
}

.listingnote{
margin-right: .25em;
}

.listing-header i {
padding-left: .25em;
padding-right: .25em;
}

.fa-files-o {
cursor: pointer;
}

.code-note-margin {
display: flex;
justify-content: flex-end;
align-items: center;
}

.listing-header {
background-color: lightgrey;
border-top: 1px solid grey;
text-align: right;
}

.compared-snippet-1__listing-header-cls {
background-color: ◊cmp-aqua-transparent;
color: ◊cmp-aqua;
border-bottom: 1px solid ◊cmp-aqua;
border-top: 1px solid ◊cmp-aqua;
}

.compared-snippet-2__listing-header-cls {
background-color: ◊cmp-orange-transparent;
color: ◊cmp-orange;
border-bottom: 1px solid ◊cmp-orange;
border-top: 1px solid ◊cmp-orange;
}

.code-note-container {
margin-bottom: .25em;
}

.annotated-code {
width: calc(100% + 100px);
position: relative;
right: 100px;
}

.annotated-code .code-table {
width: 100%;
}

.code-table {
font-size: .7em;
}

.code-note-container aside {
display: inline-block;
width: calc(100% - ◊note-nb-width - ◊note-nb-padding-right - ◊aside-padding-left - ◊aside-border-left-width)
}

.code-table tbody tr:nth-child(odd) td.listing-line-content{
background-color: ◊very-light-gray;
}

.code-table tr:first-child .listing-line-content{
border-top: 1px solid gray;
}

.code-table tr:last-child .listing-line-content {
border-bottom: 1px solid gray;
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

.code-table {
border-collapse: collapse;
display: inline-block;
font-family: ◊code-font-family;
line-height: 1.5;
}

.code-table.cmp-1, .code-table.cmp-2 {
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

.included-code {
width: calc(100% + 100px);
position: relative;
right: 100px;
}

.standalone-code {
width: calc(100% + 100px);
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

.comparative-snippet pre {
margin-bottom: 0;
margin-top: 0;
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

.code-note-container {
width: calc(100% + 6em);
position: relative;
right: calc(6em);
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

.cmp-1 .first-added-line {
border-top: 1px dashed ◊cmp-aqua;
}

.cmp-2 .first-added-line {
border-top: 1px dashed ◊cmp-orange;
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
color: white;
text-align: center;
font-family: ◊code-font-family;
font-size: 11px;
display: inline-block;
}

.active-number-circle.right-number-circle {
background: ◊cmp-orange;
}

.ws {
white-space: pre;
}

aside.cmp-n {
display: inline-block;
vertical-align: middle;
margin-bottom: 0px;
/* own width = entire div, without note width, note padding, own border, own padding*/
width: calc(100% - (5.5em + 2px) - 8px - 2px - 8px);
margin: .5em 0 .5em 0;
}