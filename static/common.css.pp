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

◊(require (only-in racket/string string-join) "base-textual-structure-params.rkt")

◊(require "fonts.rkt" "palette.rkt")

table.counterparts td:first-child {
border-right: 1px dashed;
padding-right: 1em;
}

table.counterparts td:last-child {
padding-left: 1em;
}

ul.toc li {
list-style-type: none;
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

.glossarytermlabel {
font-weight: bold;
}

.inactive-number-circle {
background: gray;
}

.code-note-container aside {
margin-top: 0;
margin-bottom: 0;
}

.toc {
padding: 0;
}
